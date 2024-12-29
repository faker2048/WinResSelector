using System.Windows.Input;
using Newtonsoft.Json;

namespace WinResSelector.Models
{
    public class DisplayProfile
    {
        public int Id { get; set; }
        public HotkeySettings Hotkey { get; set; } = new();
        public DisplaySettings Display { get; set; } = new();
    }

    public class HotkeySettings
    {
        public Key Key { get; set; }
        public ModifierKeys Modifiers { get; set; }
    }

    public class DisplaySettings
    {
        public int Width { get; set; }
        public int Height { get; set; }
        public int ColorDepth { get; set; }
        public int RefreshRate { get; set; }

        public override string ToString()
        {
            return $"{Width}x{Height} @ {RefreshRate}Hz ({ColorDepth}bit)";
        }
    }
} 