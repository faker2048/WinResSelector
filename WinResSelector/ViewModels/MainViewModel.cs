using System;
using System.Collections.ObjectModel;
using System.Threading.Tasks;
using System.Windows.Media;
using System.Linq;
using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using WinResSelector.Models;
using WinResSelector.Services;

namespace WinResSelector.ViewModels
{
    public partial class MainViewModel : ObservableObject
    {
        private readonly ConfigService _configService;
        private readonly DisplayService _displayService;
        private readonly Action _showWindow;
        private readonly Action _closeWindow;

        [ObservableProperty]
        private string _statusMessage = "";

        [ObservableProperty]
        private string _currentResolution = "";

        [ObservableProperty]
        private Brush _statusMessageColor = Brushes.Black;

        [ObservableProperty]
        private bool _startWithWindows;

        [ObservableProperty]
        private bool _minimizeToTray;

        public ObservableCollection<DisplayProfile> Profiles { get; }
        public ObservableCollection<DisplaySettings> AvailableResolutions { get; }

        public MainViewModel(ConfigService configService, DisplayService displayService,
                           Action showWindow, Action closeWindow)
        {
            _configService = configService;
            _displayService = displayService;
            _showWindow = showWindow;
            _closeWindow = closeWindow;

            Profiles = new ObservableCollection<DisplayProfile>();
            AvailableResolutions = new ObservableCollection<DisplaySettings>();

            LoadData();
            UpdateCurrentResolution();
        }

        private async void ClearStatusMessageAfterDelay()
        {
            await Task.Delay(3000); // 3秒后清除消息
            StatusMessage = "";
        }

        partial void OnStatusMessageChanged(string value)
        {
            if (!string.IsNullOrEmpty(value))
            {
                ClearStatusMessageAfterDelay();
            }
        }

        public void UpdateCurrentResolution()
        {
            var currentSettings = _displayService.GetCurrentResolution();
            CurrentResolution = $"当前分辨率: {currentSettings}";
        }

        private void SaveSettings()
        {
            _configService.SaveSettings(new Models.AppSettings
            {
                StartWithWindows = StartWithWindows,
                MinimizeToTray = MinimizeToTray
            });
        }

        private void SaveProfiles()
        {
            _configService.SaveProfiles(new System.Collections.Generic.List<DisplayProfile>(Profiles));
        }

        [RelayCommand]
        private void AddProfile()
        {
            var profile = new DisplayProfile
            {
                Id = Profiles.Count + 1,
                Display = AvailableResolutions.Count > 0 ? AvailableResolutions[0] : new DisplaySettings()
            };
            Profiles.Add(profile);
        }

        [RelayCommand]
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

        [RelayCommand]
        private void TestProfile(DisplayProfile profile)
        {
            if (profile != null)
            {
                ApplyProfile(profile);
            }
        }

        [RelayCommand]
        private void ShowWindow()
        {
            _showWindow();
        }

        [RelayCommand]
        private void Exit()
        {
            SaveSettings();
            SaveProfiles();
            _configService.SaveConfigIfNeeded();
            _closeWindow();
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
    }
} 