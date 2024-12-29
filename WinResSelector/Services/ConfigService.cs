using System;
using System.IO;
using System.Collections.Generic;
using System.Reflection;
using Newtonsoft.Json;
using WinResSelector.Models;

namespace WinResSelector.Services
{
    public class ConfigService
    {
        private readonly string _configPath;
        private Config _currentConfig = new();

        public event EventHandler<SaveConfigEventArgs>? ConfigSaved;

        public ConfigService()
        {
            string exePath = Assembly.GetExecutingAssembly().Location;
            string exeDir = Path.GetDirectoryName(exePath) ?? "";
            _configPath = Path.Combine(exeDir, "config.json");
            
            _currentConfig = new Config
            {
                Profiles = new List<DisplayProfile>(),
                Settings = new AppSettings
                {
                    StartWithWindows = false,
                    MinimizeToTray = true
                }
            };
        }

        public void LoadConfig()
        {
            try
            {
                if (File.Exists(_configPath))
                {
                    string json = File.ReadAllText(_configPath);
                    var loadedConfig = JsonConvert.DeserializeObject<Config>(json);
                    if (loadedConfig != null)
                    {
                        _currentConfig = loadedConfig;
                    }
                }
                else
                {
                    SaveConfig();
                }
            }
            catch (Exception ex)
            {
                ConfigSaved?.Invoke(this, new SaveConfigEventArgs(false, ex.Message));
            }
        }

        public void SaveConfig()
        {
            try
            {
                string json = JsonConvert.SerializeObject(_currentConfig, Formatting.Indented);
                File.WriteAllText(_configPath, json);
                ConfigSaved?.Invoke(this, new SaveConfigEventArgs(true, "配置已保存"));
            }
            catch (Exception ex)
            {
                ConfigSaved?.Invoke(this, new SaveConfigEventArgs(false, $"保存失败: {ex.Message}"));
            }
        }

        public List<DisplayProfile> GetProfiles()
        {
            return _currentConfig.Profiles;
        }

        public void SaveProfiles(List<DisplayProfile> profiles)
        {
            _currentConfig.Profiles = profiles;
            SaveConfig();
        }

        public AppSettings GetSettings()
        {
            return _currentConfig.Settings;
        }

        public void SaveSettings(AppSettings settings)
        {
            _currentConfig.Settings = settings;
            SaveConfig();
        }
    }

    public class Config
    {
        public List<DisplayProfile> Profiles { get; set; } = new();
        public AppSettings Settings { get; set; } = new();
    }

    public class AppSettings
    {
        public bool StartWithWindows { get; set; }
        public bool MinimizeToTray { get; set; }
    }

    public class SaveConfigEventArgs : EventArgs
    {
        public bool Success { get; }
        public string Message { get; }

        public SaveConfigEventArgs(bool success, string message)
        {
            Success = success;
            Message = message;
        }
    }
} 