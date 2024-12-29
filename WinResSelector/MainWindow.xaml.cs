using System;
using System.Windows;
using System.Windows.Interop;
using WinResSelector.Services;
using WinResSelector.ViewModels;

namespace WinResSelector
{
    public partial class MainWindow : Window
    {
        private HotkeyService? _hotkeyService;
        private MainViewModel? _viewModel;
        private const int WM_DISPLAYCHANGE = 0x007E;

        public MainWindow()
        {
            InitializeComponent();

            var configService = new ConfigService();
            var displayService = new DisplayService();
            
            // 等待窗口句柄创建后再初始化热键服务
            Loaded += (s, e) =>
            {
                var windowHandle = new WindowInteropHelper(this).Handle;
                _hotkeyService = new HotkeyService(windowHandle);
                
                _viewModel = new MainViewModel(
                    configService,
                    displayService,
                    _hotkeyService,
                    () => { Show(); WindowState = WindowState.Normal; },
                    () => Application.Current.Shutdown()
                );

                DataContext = _viewModel;

                // 处理窗口消息
                var source = HwndSource.FromHwnd(windowHandle);
                source?.AddHook(WndProc);

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

        private IntPtr WndProc(IntPtr hwnd, int msg, IntPtr wParam, IntPtr lParam, ref bool handled)
        {
            const int WM_HOTKEY = 0x0312;

            switch (msg)
            {
                case WM_HOTKEY when _hotkeyService != null:
                    _hotkeyService.HandleHotkey(wParam);
                    handled = true;
                    break;
                
                case WM_DISPLAYCHANGE:
                    _viewModel?.UpdateCurrentResolution();
                    handled = true;
                    break;
            }

            return IntPtr.Zero;
        }
    }
}