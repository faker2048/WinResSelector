using System;
using System.Runtime.InteropServices;
using System.Windows.Input;
using System.Collections.Generic;
using WinResSelector.Models;

namespace WinResSelector.Services
{
    public class HotkeyService
    {
        [DllImport("user32.dll")]
        private static extern bool RegisterHotKey(IntPtr hWnd, int id, uint fsModifiers, uint vk);

        [DllImport("user32.dll")]
        private static extern bool UnregisterHotKey(IntPtr hWnd, int id);

        private readonly Dictionary<int, Action> _hotkeyActions = new Dictionary<int, Action>();
        private readonly IntPtr _windowHandle;
        private int _currentId = 1;

        public HotkeyService(IntPtr windowHandle)
        {
            _windowHandle = windowHandle;
        }

        public bool RegisterHotkey(HotkeySettings settings, Action action)
        {
            uint modifiers = 0;
            if (settings.Modifiers.HasFlag(ModifierKeys.Alt)) modifiers |= 0x0001;
            if (settings.Modifiers.HasFlag(ModifierKeys.Control)) modifiers |= 0x0002;
            if (settings.Modifiers.HasFlag(ModifierKeys.Shift)) modifiers |= 0x0004;
            if (settings.Modifiers.HasFlag(ModifierKeys.Windows)) modifiers |= 0x0008;

            uint vk = (uint)KeyInterop.VirtualKeyFromKey(settings.Key);
            
            if (RegisterHotKey(_windowHandle, _currentId, modifiers, vk))
            {
                _hotkeyActions[_currentId] = action;
                _currentId++;
                return true;
            }

            return false;
        }

        public void UnregisterAll()
        {
            foreach (var id in _hotkeyActions.Keys)
            {
                UnregisterHotKey(_windowHandle, id);
            }
            _hotkeyActions.Clear();
        }

        public bool HandleHotkey(IntPtr wParam)
        {
            int id = wParam.ToInt32();
            if (_hotkeyActions.TryGetValue(id, out var action))
            {
                action.Invoke();
                return true;
            }
            return false;
        }
    }
} 