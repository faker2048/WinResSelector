using System;
using System.Runtime.InteropServices;
using System.Collections.Generic;
using WinResSelector.Models;

namespace WinResSelector.Services
{
    public class DisplayService
    {
        [StructLayout(LayoutKind.Sequential)]
        public struct DEVMODE
        {
            private const int CCHDEVICENAME = 32;
            [MarshalAs(UnmanagedType.ByValTStr, SizeConst = CCHDEVICENAME)]
            public string dmDeviceName;
            public short dmSpecVersion;
            public short dmDriverVersion;
            public short dmSize;
            public short dmDriverExtra;
            public int dmFields;
            public int dmPositionX;
            public int dmPositionY;
            public int dmDisplayOrientation;
            public int dmDisplayFixedOutput;
            public short dmColor;
            public short dmDuplex;
            public short dmYResolution;
            public short dmTTOption;
            public short dmCollate;
            [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 32)]
            public string dmFormName;
            public short dmLogPixels;
            public int dmBitsPerPel;
            public int dmPelsWidth;
            public int dmPelsHeight;
            public int dmDisplayFlags;
            public int dmDisplayFrequency;
        }

        [DllImport("user32.dll")]
        public static extern int EnumDisplaySettings(string? deviceName, int modeNum, ref DEVMODE devMode);

        [DllImport("user32.dll")]
        public static extern int ChangeDisplaySettings(ref DEVMODE devMode, int flags);

        private const int ENUM_CURRENT_SETTINGS = -1;
        private const int ENUM_REGISTRY_SETTINGS = -2;
        private const int CDS_UPDATEREGISTRY = 0x01;
        private const int CDS_TEST = 0x02;
        private const int DISP_CHANGE_SUCCESSFUL = 0;
        private const int DISP_CHANGE_RESTART = 1;
        private const int DISP_CHANGE_FAILED = -1;

        public List<DisplaySettings> GetAvailableResolutions()
        {
            var resolutions = new List<DisplaySettings>();
            var dm = new DEVMODE();
            dm.dmSize = (short)Marshal.SizeOf(typeof(DEVMODE));

            int modeNum = 0;
            while (EnumDisplaySettings(null, modeNum, ref dm) != 0)
            {
                var settings = new DisplaySettings
                {
                    Width = dm.dmPelsWidth,
                    Height = dm.dmPelsHeight,
                    ColorDepth = dm.dmBitsPerPel,
                    RefreshRate = dm.dmDisplayFrequency
                };

                if (!resolutions.Exists(x => 
                    x.Width == settings.Width && 
                    x.Height == settings.Height && 
                    x.ColorDepth == settings.ColorDepth && 
                    x.RefreshRate == settings.RefreshRate))
                {
                    resolutions.Add(settings);
                }

                modeNum++;
            }

            return resolutions;
        }

        public bool ChangeResolution(DisplaySettings settings)
        {
            var dm = new DEVMODE();
            dm.dmSize = (short)Marshal.SizeOf(typeof(DEVMODE));

            if (EnumDisplaySettings(null, ENUM_CURRENT_SETTINGS, ref dm) != 0)
            {
                dm.dmPelsWidth = settings.Width;
                dm.dmPelsHeight = settings.Height;
                dm.dmBitsPerPel = settings.ColorDepth;
                dm.dmDisplayFrequency = settings.RefreshRate;

                int result = ChangeDisplaySettings(ref dm, CDS_UPDATEREGISTRY);
                return result == DISP_CHANGE_SUCCESSFUL;
            }

            return false;
        }
    }
} 