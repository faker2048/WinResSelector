using System;
using System.IO;
using System.Collections.Generic;
using Newtonsoft.Json;
using WinResSelector.Models;

namespace WinResSelector.Services
{
    public class ConfigService
    {
        private readonly string _configPath;
        private Config? _config;

        public event EventHandler<SaveConfigEventArgs>? ConfigSaved;

        private class Config
        {
            public List<DisplayProfile> Profiles { get; set; } = new();
            public AppSettings Settings { get; set; } = new();
        }

        public ConfigService()
        {
            var appData = Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData);
            var appFolder = Path.Combine(appData, "WinResSelector");
            Directory.CreateDirectory(appFolder);
            _configPath = Path.Combine(appFolder, "config.json");
        }

        public void LoadConfig()
        {
            if (File.Exists(_configPath))
            {
                try
                {
                    var json = File.ReadAllText(_configPath);
                    _config = JsonConvert.DeserializeObject<Config>(json);
                }
                catch
                {
                    _config = new Config();
                }
            }
            else
            {
                _config = new Config();
            }
        }

        public List<DisplayProfile> GetProfiles()
        {
            return _config?.Profiles ?? new List<DisplayProfile>();
        }

        public AppSettings GetSettings()
        {
            return _config?.Settings ?? new AppSettings();
        }

        public void SaveProfiles(List<DisplayProfile> profiles)
        {
            if (_config == null) _config = new Config();
            _config.Profiles = profiles;
            SaveConfig();
        }

        public void SaveSettings(AppSettings settings)
        {
            if (_config == null) _config = new Config();
            _config.Settings = settings;
            SaveConfig();
        }

        private void SaveConfig()
        {
            try
            {
                var json = JsonConvert.SerializeObject(_config, Formatting.Indented);
                File.WriteAllText(_configPath, json);
                ConfigSaved?.Invoke(this, new SaveConfigEventArgs(true, "配置已保存"));
            }
            catch (Exception ex)
            {
                ConfigSaved?.Invoke(this, new SaveConfigEventArgs(false, $"保存失败: {ex.Message}"));
            }
        }
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