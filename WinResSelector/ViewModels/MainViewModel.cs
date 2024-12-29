using System;
using System.Collections.ObjectModel;
using System.Windows.Input;
using System.ComponentModel;
using System.Runtime.CompilerServices;
using System.Windows.Media;
using System.Threading.Tasks;
using WinResSelector.Models;
using WinResSelector.Services;
using System.Linq;

namespace WinResSelector.ViewModels
{
    public class MainViewModel : INotifyPropertyChanged
    {
        private readonly ConfigService _configService;
        private readonly DisplayService _displayService;
        private readonly Action _showWindow;
        private readonly Action _closeWindow;

        private string _statusMessage = "";
        public string StatusMessage
        {
            get => _statusMessage;
            set
            {
                if (_statusMessage != value)
                {
                    _statusMessage = value;
                    OnPropertyChanged();
                    if (!string.IsNullOrEmpty(value))
                    {
                        ClearStatusMessageAfterDelay();
                    }
                }
            }
        }

        private string _currentResolution = "";
        public string CurrentResolution
        {
            get => _currentResolution;
            set
            {
                if (_currentResolution != value)
                {
                    _currentResolution = value;
                    OnPropertyChanged();
                }
            }
        }

        private async void ClearStatusMessageAfterDelay()
        {
            await Task.Delay(3000); // 3秒后清除消息
            StatusMessage = "";
        }

        public void UpdateCurrentResolution()
        {
            var currentSettings = _displayService.GetCurrentResolution();
            CurrentResolution = $"当前分辨率: {currentSettings}";
        }

        private Brush _statusMessageColor = Brushes.Black;
        public Brush StatusMessageColor
        {
            get => _statusMessageColor;
            set
            {
                if (_statusMessageColor != value)
                {
                    _statusMessageColor = value;
                    OnPropertyChanged();
                }
            }
        }

        private bool _startWithWindows;
        public bool StartWithWindows
        {
            get => _startWithWindows;
            set
            {
                if (_startWithWindows != value)
                {
                    _startWithWindows = value;
                    OnPropertyChanged();
                }
            }
        }

        private bool _minimizeToTray;
        public bool MinimizeToTray
        {
            get => _minimizeToTray;
            set
            {
                if (_minimizeToTray != value)
                {
                    _minimizeToTray = value;
                    OnPropertyChanged();
                }
            }
        }

        public ObservableCollection<DisplayProfile> Profiles { get; }
        public ObservableCollection<DisplaySettings> AvailableResolutions { get; }

        public ICommand AddProfileCommand { get; }
        public ICommand DeleteProfileCommand { get; }
        public ICommand TestProfileCommand { get; }
        public ICommand SaveCommand { get; }
        public ICommand ShowWindowCommand { get; }
        public ICommand ExitCommand { get; }

        public MainViewModel(ConfigService configService, DisplayService displayService,
                           Action showWindow, Action closeWindow)
        {
            _configService = configService;
            _displayService = displayService;
            _showWindow = showWindow;
            _closeWindow = closeWindow;

            // 订阅配置保存事件
            _configService.ConfigSaved += (s, e) =>
            {
                StatusMessage = e.Message;
                StatusMessageColor = e.Success ? Brushes.Green : Brushes.Red;
            };

            Profiles = new ObservableCollection<DisplayProfile>();
            AvailableResolutions = new ObservableCollection<DisplaySettings>();

            AddProfileCommand = new RelayCommand(AddProfile);
            DeleteProfileCommand = new RelayCommand<DisplayProfile>(DeleteProfile);
            TestProfileCommand = new RelayCommand<DisplayProfile>(TestProfile);
            SaveCommand = new RelayCommand(Save);
            ShowWindowCommand = new RelayCommand(() => _showWindow());
            ExitCommand = new RelayCommand(() => _closeWindow());

            LoadData();
            UpdateCurrentResolution();
        }

        private void LoadData()
        {
            // 先加载可用分辨率
            var resolutions = _displayService.GetAvailableResolutions();
            AvailableResolutions.Clear();
            foreach (var resolution in resolutions)
            {
                AvailableResolutions.Add(resolution);
            }

            // 再加载配置
            _configService.LoadConfig();
            var settings = _configService.GetSettings();
            StartWithWindows = settings.StartWithWindows;
            MinimizeToTray = settings.MinimizeToTray;

            var profiles = _configService.GetProfiles();
            Profiles.Clear();
            foreach (var profile in profiles)
            {
                // 查找匹配的分辨率
                var matchingResolution = AvailableResolutions.FirstOrDefault(r =>
                    r.Width == profile.Display.Width &&
                    r.Height == profile.Display.Height &&
                    r.ColorDepth == profile.Display.ColorDepth &&
                    r.RefreshRate == profile.Display.RefreshRate);

                if (matchingResolution != null)
                {
                    profile.Display = matchingResolution;
                }
                Profiles.Add(profile);
            }
        }

        private void AddProfile()
        {
            var profile = new DisplayProfile
            {
                Id = Profiles.Count + 1,
                Display = AvailableResolutions.Count > 0 ? AvailableResolutions[0] : new DisplaySettings()
            };
            Profiles.Add(profile);
        }

        private void DeleteProfile(DisplayProfile profile)
        {
            if (profile != null)
            {
                Profiles.Remove(profile);
                // 重新排序 ID
                for (int i = 0; i < Profiles.Count; i++)
                {
                    Profiles[i].Id = i + 1;
                }
            }
        }

        private void TestProfile(DisplayProfile profile)
        {
            if (profile != null)
            {
                ApplyProfile(profile);
            }
        }

        private void ApplyProfile(DisplayProfile profile)
        {
            if (profile?.Display != null)
            {
                bool success = _displayService.ChangeResolution(profile.Display);
                if (!success)
                {
                    StatusMessage = "分辨率切换失败";
                    StatusMessageColor = Brushes.Red;
                }
                UpdateCurrentResolution();
            }
        }

        private void Save()
        {
            _configService.SaveProfiles(new System.Collections.Generic.List<DisplayProfile>(Profiles));
            _configService.SaveSettings(new Models.AppSettings
            {
                StartWithWindows = StartWithWindows,
                MinimizeToTray = MinimizeToTray
            });
        }

        public event PropertyChangedEventHandler? PropertyChanged;
        protected virtual void OnPropertyChanged([CallerMemberName] string? propertyName = null)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
        }
    }

    public class RelayCommand : ICommand
    {
        private readonly Action _execute;
        private readonly Func<bool>? _canExecute;

        public RelayCommand(Action execute, Func<bool>? canExecute = null)
        {
            _execute = execute ?? throw new ArgumentNullException(nameof(execute));
            _canExecute = canExecute;
        }

        public bool CanExecute(object? parameter)
        {
            return _canExecute?.Invoke() ?? true;
        }

        public void Execute(object? parameter)
        {
            _execute();
        }

        public event EventHandler? CanExecuteChanged
        {
            add { CommandManager.RequerySuggested += value; }
            remove { CommandManager.RequerySuggested -= value; }
        }
    }

    public class RelayCommand<T> : ICommand
    {
        private readonly Action<T> _execute;
        private readonly Func<T, bool>? _canExecute;

        public RelayCommand(Action<T> execute, Func<T, bool>? canExecute = null)
        {
            _execute = execute ?? throw new ArgumentNullException(nameof(execute));
            _canExecute = canExecute;
        }

        public bool CanExecute(object? parameter)
        {
            return parameter is T typedParameter && (_canExecute?.Invoke(typedParameter) ?? true);
        }

        public void Execute(object? parameter)
        {
            if (parameter is T typedParameter)
            {
                _execute(typedParameter);
            }
        }

        public event EventHandler? CanExecuteChanged
        {
            add { CommandManager.RequerySuggested += value; }
            remove { CommandManager.RequerySuggested -= value; }
        }
    }
} 