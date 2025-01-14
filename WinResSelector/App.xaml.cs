using System;
using System.Windows;
using Microsoft.Extensions.DependencyInjection;
using WinResSelector.Services;
using WinResSelector.ViewModels;
using WinResSelector.View;

namespace WinResSelector
{
    public partial class App : Application
    {
        public IServiceProvider Services { get; } = ConfigureServices();

        private static IServiceProvider ConfigureServices()
        {
            var services = new ServiceCollection();

            // 注册服务
            services.AddSingleton<ConfigService>();
            services.AddSingleton<DisplayService>();

            // 注册 ViewModel
            services.AddSingleton<MainViewModel>(sp => new MainViewModel(
                sp.GetRequiredService<ConfigService>(),
                sp.GetRequiredService<DisplayService>(),
                () => sp.GetRequiredService<MainWindow>().Show(),
                () => Current.Shutdown()
            ));

            // 注册视图
            services.AddSingleton<MainWindow>();

            return services.BuildServiceProvider();
        }

        protected override void OnStartup(StartupEventArgs e)
        {
            base.OnStartup(e);

            var mainWindow = Services.GetRequiredService<MainWindow>();
            mainWindow.Show();
        }
    }
}

