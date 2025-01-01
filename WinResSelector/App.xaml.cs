using System.Configuration;
using System.Data;
using System.Windows;
using System.Diagnostics;
using System.Linq;

namespace WinResSelector;

/// <summary>
/// Interaction logic for App.xaml
/// </summary>
public partial class App : Application
{
    protected override void OnStartup(StartupEventArgs e)
    {
        string procName = Process.GetCurrentProcess().ProcessName;
        if (Process.GetProcessesByName(procName).Count() > 1)
        {
            MessageBox.Show("程序已经在运行啦~ 🎈\n不需要重复启动哦 (｡◕‿◕｡)", "温馨提示 ✨", MessageBoxButton.OK, MessageBoxImage.Information);
            Current.Shutdown();
            return;
        }

        base.OnStartup(e);
    }
}

