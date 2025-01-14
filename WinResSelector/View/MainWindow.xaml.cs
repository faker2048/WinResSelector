using System.Windows;
using Microsoft.Extensions.DependencyInjection;
using WinResSelector.ViewModels;

namespace WinResSelector.View
{
    public partial class MainWindow : Window
    {
        public MainWindow()
        {
            InitializeComponent();
            
            // 使用依赖注入获取 ViewModel
            DataContext = ((App)Application.Current).Services.GetService<MainViewModel>();
            
            // 处理关闭按钮
            Closing += (sender, args) =>
            {
                if (DataContext is not MainViewModel { MinimizeToTray: true }) return;
                args.Cancel = true;
                Hide();
            };
        }

        private void NotifyIcon_TrayLeftMouseDown(object sender, RoutedEventArgs e)
        {
            Show();
            WindowState = WindowState.Normal;
        }
    }
}