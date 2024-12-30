using System;
using System.Windows;
using System.Windows.Interop;
using WinResSelector.Services;
using WinResSelector.ViewModels;

namespace WinResSelector
{
    public partial class MainWindow : Window
    {
        private MainViewModel? _viewModel;

        public MainWindow()
        {
            InitializeComponent();

            var configService = new ConfigService();
            var displayService = new DisplayService();
            
            // 等待窗口句柄创建后再初始化
            Loaded += (s, e) =>
            {
                _viewModel = new MainViewModel(
                    configService,
                    displayService,
                    () => { Show(); WindowState = WindowState.Normal; },
                    () => Application.Current.Shutdown()
                );

                DataContext = _viewModel;

                // 处理关闭按钮
                Closing += (sender, args) =>
                {
                    if (_viewModel?.MinimizeToTray == true)
                    {
                        args.Cancel = true;
                        Hide();
                    }
                };
            };
        }

        private void NotifyIcon_TrayLeftMouseDown(object sender, RoutedEventArgs e)
        {
            Show();
            WindowState = WindowState.Normal;
        }
    }
}