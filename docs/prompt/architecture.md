# WinResSelector 设计文档

## 1. 简介
一个简单的 Windows 分辨率切换工具，通过快捷键快速切换屏幕分辨率。

## 2. 基本功能
- 最多支持 9 组分辨率预设
- 每组预设包含：分辨率、色深、刷新率
- 通过快捷键（如 Ctrl+Alt+1 到 Ctrl+Alt+9）快速切换
- 系统托盘运行，右键菜单设置

## 3. 技术实现
### 3.1 基础环境
- 开发框架：.NET 6.0
- UI 框架：WPF (Windows Presentation Foundation)
- 配置：JSON 文件
- 设计模式：MVVM

### 3.2 核心实现
1. **分辨率管理**
   ```csharp
   public class DisplaySettings
   {
       public int Width { get; set; }
       public int Height { get; set; }
       public int ColorDepth { get; set; }
       public int RefreshRate { get; set; }
   }
   ```

2. **快捷键处理**
   ```csharp
   public class HotkeyManager
   {
       // 使用 Windows.Forms.Keys 处理全局热键
       private Dictionary<Keys, Action> _hotkeyMappings;
       
       public void RegisterHotkey(Keys key, Action action)
       {
           // 注册全局热键
       }
   }
   ```

3. **配置存储**
   ```json
   {
     "profiles": [
       {
         "id": 1,
         "hotkey": {
           "key": "D1",
           "modifiers": ["Control", "Alt"]
         },
         "display": {
           "width": 1920,
           "height": 1080,
           "colorDepth": 32,
           "refreshRate": 60
         }
       }
     ],
     "settings": {
       "startWithWindows": true,
       "minimizeToTray": true
     }
   }
   ```

## 4. 界面设计
- 系统托盘图标（使用 WPF NotifyIcon）
- XAML 设置窗口：
  ```xaml
  <Window x:Class="WinResSelector.SettingsWindow"
          xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
          Style="{StaticResource ModernWindowStyle}">
      <Grid>
          <ComboBox ItemsSource="{Binding Resolutions}"/>
          <ComboBox ItemsSource="{Binding ColorDepths}"/>
          <ComboBox ItemsSource="{Binding RefreshRates}"/>
          <TextBox Text="{Binding Hotkey}"/>
      </Grid>
  </Window>
  ```

## 5. 开发计划
1. 搭建 WPF MVVM 基础框架
2. 实现分辨率管理核心功能
3. 添加热键支持和系统托盘
4. 完成设置界面和配置存储

