using System.Windows.Input;

namespace WinResSelector.Models
{
    public class DisplayProfile
    {
        public int Id { get; set; }
        public DisplaySettings Display { get; set; } = new DisplaySettings();
    }

    public class DisplaySettings
    {
        public int Width { get; set; }
        public int Height { get; set; }
        public int ColorDepth { get; set; }
        public int RefreshRate { get; set; }

        public override string ToString()
        {
            return $"{Width}x{Height} {RefreshRate}Hz {ColorDepth}bit";
        }
    }

    public class AppSettings
    {
        public bool StartWithWindows { get; set; }
        public bool MinimizeToTray { get; set; }
    }
} 