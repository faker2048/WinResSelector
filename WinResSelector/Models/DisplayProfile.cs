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
        public int Width { get; init; }
        public int Height { get; init; }
        public int ColorDepth { get; init; }
        public int RefreshRate { get; init; }

        public override string ToString()
        {
            return $"{Width}x{Height} {RefreshRate}Hz {ColorDepth}bit";
        }
    }

    public class AppSettings
    {
        public bool StartWithWindows { get; init; }
        public bool MinimizeToTray { get; init; }
    }
} 