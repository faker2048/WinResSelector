#NoTrayIcon
#region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=_Icons\display_16.ico
#AutoIt3Wrapper_Outfile=HRC.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Res_Comment=© HRC - HotKey Resolution Changer 2009 - 2012 by Karsten Funk. All rights reserved. http://www.funk.eu
#AutoIt3Wrapper_Res_Description=HRC - HotKey Resolution Changer
#AutoIt3Wrapper_Res_Fileversion=2.1.0.0
#AutoIt3Wrapper_Res_LegalCopyright=Creative Commons License "by-nc-sa 3.0", this program is freeware under Creative Commons License "by-nc-sa 3.0" (http://creativecommons.org/licenses/by-nc-sa/3.0/)
#AutoIt3Wrapper_Res_requestedExecutionLevel=asInvoker
#AutoIt3Wrapper_Res_Field=Made By|Karsten Funk
#AutoIt3Wrapper_Res_Field=AutoIt Version|%AutoItVer%
#AutoIt3Wrapper_Res_Field=Compile Date|%date% %time%
#AutoIt3Wrapper_Run_AU3Check=n
#AutoIt3Wrapper_Tidy_Stop_OnError=n
#AutoIt3Wrapper_Run_Obfuscator=y
#Obfuscator_Parameters=/sf /sv /om /cs=0 /cn=0
#endregion ;**** Directives created by AutoIt3Wrapper_GUI ****
#Obfuscator_Ignore_Funcs=_ApplySettingsHK,_HRC_Recover

; ~~~~~~~~~~~~~~~ MUST before next Release ~~~~~~~~~~

; ~~~~~~~~~~~~~~~ Optional Features ~~~~~~~~~~

#region DllOpen_PostProcessor START
Global $h_DLL_msvcrt = DllOpen("msvcrt.dll")
Global $h_DLL_Kernel32 = DllOpen("kernel32.dll")
Global $h_DLL_user32 = DllOpen("user32.dll")
Global $h_DLL_GDI32 = DllOpen("gdi32.dll")
Global $h_DLL_ComCTL32 = DllOpen("comctl32.dll")
Global $h_DLL_OLE32 = DllOpen("ole32.dll")
Global $h_DLL_OLEAut32 = DllOpen("oleaut32.dll")
Global $h_DLL_Crypt32 = DllOpen("Crypt32.dll")
Global $h_DLL_NTDll = DllOpen("ntdll.dll")
#region DllOpen_PostProcessor END

Global $versionnumber = "v2.1 (2012-May-16)"
Global $h_HookMsgBox

#cs ----------------------------------------------------------------------------

	AutoIt Version: 3.3.8.0
	Author:         KaFu (http://www.funk.eu)

	Script Function:
	HRC - HotKey Resolution Changer

#ce ----------------------------------------------------------------------------

; Func _ChangeScreenRes(

; ChangeDisplaySettings() only changes the default display. If you want to change another display device, you can use the ChangeDisplaySettingsEx() function.

; http://www.codeproject.com/KB/dotnet/changing-display-settings.aspx?display=Print

; Enumeration and Display Control
; http://msdn.microsoft.com/en-us/library/dd162617%28VS.85%29.aspx

; On a Windows 2000 or Windows XP-based system, when you use the ChangeDisplaySettingsEx function to attach a secondary monitor to the desktop,
; the change does not take effect until you restart the computer.

; To resolve this problem, call ChangeDisplaySettings(NULL, 0) to update the desktop immediately after you call ChangeDisplaySettingsEx to
; attach the secondary monitor to the desktop. This causes the system to use the settings in the registry and resets each of the display devices.
; http://support.microsoft.com/kb/308216/en-gb

; Vista+ only
; SetDisplayConfig()
; http://msdn.microsoft.com/en-us/library/windows/hardware/ff569533(v=vs.85).aspx

#cs
	dmDisplayOrientation
	For display devices only, the orientation at which images should be presented. If DM_DISPLAYORIENTATION is not set, this member must be zero.
	If DM_DISPLAYORIENTATION is set, this member must be one of the following values

	Value Meaning
	DMDO_DEFAULT The display orientation is the natural orientation of the display device; it should be used as the default.
	DMDO_90 The display orientation is rotated 90 degrees (measured clockwise) from DMDO_DEFAULT.
	DMDO_180 The display orientation is rotated 180 degrees (measured clockwise) from DMDO_DEFAULT.
	DMDO_270 The display orientation is rotated 270 degrees (measured clockwise) from DMDO_DEFAULT.
#ce

Global Const $DMDO_DEFAULT = 0
Global Const $DMDO_90 = 1
Global Const $DMDO_180 = 2
Global Const $DMDO_270 = 3

Global Const $SMTO_ABORTIFHUNG = 0x0002
Global Const $MSG_TIMEOUT = 250

Global $b_Res_Orientation_Rotation_Supported = False
Global $i_Initial_Width, $i_Initial_Heigth

Global $s_Global_Font, $i_Font_Adjustment = 0
If FileExists(@WindowsDir & '\Fonts\ARIAL.ttf') Then
	$s_Global_Font = "Arial"
ElseIf FileExists(@WindowsDir & '\Fonts\TAHOMA.ttf') Then
	$s_Global_Font = "Tahoma"
	$i_Font_Adjustment = -0.1
ElseIf FileExists(@WindowsDir & '\Fonts\Verdana.ttf') Then
	$s_Global_Font = "Verdana"
	$i_Font_Adjustment = -1
Else
	$s_Global_Font = "Arial" ; fall-back to default font
EndIf

#cs
	Set selection of bit depth fixed to:
	32 Bit - 4 billion colors
	16 Bit - 65k colors
	8 Bit - 256 colors
#ce

#cs
	Check if Freq is adjusted when Res has been changed in dropdown:
	$sCombo_MonitorFreq
	$sCombo_ColorDepth
	$sCombo_ColorDepth_Default
#ce

#cs
	_GUICtrlComboBoxEx_Create
	=> add custom res => on _GUICtrlComboBoxEx_Create exit check entered value, if wrong reset to default and trigger a tooltip
#ce

#include <Constants.au3>
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <Misc.au3>
#include <EditConstants.au3>
#include <WinAPI.au3>
#include <Array.au3>
#include <GDIPlus.au3>

#include <GUIComboBox.au3>

#include <GuiImageList.au3>
#include <GuiButton.au3>

Global $i__HotKey_Event = 0 ; processed in main loop
#include <HotKey_UDFs\HotKey.au3>
#include <HotKey_UDFs\HotKeyInput.au3>
#include <WinAPIEx_3.7_3380\WinAPIEx.au3>

_KeyLock(0x062E) ; Lock CTRL-ALT-DEL for Hotkey Input control, but not for Windows
_KeyLock(0x0652) ; Lock CTRL-ALT-R (Recover) for Hotkey Input control, but not for Windows
_KeyLock(0x0752) ; Lock CTRL-ALT-SHIFT-R (Reset to Initial) for emergency purpose

Global $HotkeyInput[1]
Global $HotkeyInputLock[1]
Global $sGUID = "f2190b02-b21b-4402-93b0-4bc6a04859e3"
Global $mainguititel = "HRC - HotKey Resolution Changer, " & $versionnumber
Global $mainguititel_label

Global Const $STM_SETIMAGE = 0x0172

Global $i_IniWriteTest = Random(1, 9999, 1)
IniWrite(@ScriptDir & "\HRC.ini", 'Settings', 'HRC_IniWriteTest', $i_IniWriteTest)
If IniRead(@ScriptDir & "\HRC.ini", 'Settings', 'HRC_IniWriteTest', "") <> $i_IniWriteTest Then
	_MsgBox_English(16 + 262144, "HRC Error", "HRC can not write to the ini file" & @CRLF & @CRLF & @ScriptDir & "\HRC.ini" & @CRLF & @CRLF & "Settings will not be saved. Check directory permissions or change HRC.exe location.")
EndIf

; Command Line Parameter Parsing - Start

Global $CmdLine_i_TriggerID
Global $CmdLine_b_TrayIcon_Hide = False ; switch
Global $CmdLine_b_Exit_After_Execution = False
Global $CmdLine_s_Execute_CommandLine
Global $CmdLine_s_Execute_Parameter
Global $CmdLine_b_Show_GUI = False
Global $CmdLine_b_Execute_Always = False ; switch, if true, execute command always, otherwise command is only executed on successful res-change

; If $CmdLine[0] Then _ArrayDisplay($CmdLine)

For $i = 1 To $CmdLine[0]

	If StringLen($CmdLine[$i]) = 2 And StringLeft($CmdLine[$i], 1) = "R" Then
		$CmdLine_i_TriggerID = $CmdLine[$i]
		$CmdLine_i_TriggerID = Int(StringRight($CmdLine_i_TriggerID, 1))
		If $CmdLine_i_TriggerID > 0 And $CmdLine_i_TriggerID < 10 Then
			If Not IniRead(@ScriptDir & "\HRC.ini", 'Settings', 'Res' & $CmdLine_i_TriggerID, "") Or Not IniRead(@ScriptDir & "\HRC.ini", 'Settings', 'Col' & $CmdLine_i_TriggerID, "") Or Not IniRead(@ScriptDir & "\HRC.ini", 'Settings', 'Fre' & $CmdLine_i_TriggerID, "") Then
				$CmdLine_i_TriggerID = ""
			Else
				$CmdLine_i_TriggerID = ($CmdLine_i_TriggerID * 2) + 1
			EndIf
		Else
			$CmdLine_i_TriggerID = ""
		EndIf
	EndIf

	Switch StringLower($CmdLine[$i])
		Case "/exit"
			$CmdLine_b_Exit_After_Execution = True
		Case "/hidetrayicon"
			$CmdLine_b_TrayIcon_Hide = True
		Case "/cmd_exe"
			If $CmdLine[0] >= $i + 1 Then $CmdLine_s_Execute_CommandLine = $CmdLine[$i + 1]
		Case "/cmd_param"
			If $CmdLine[0] >= $i + 1 Then $CmdLine_s_Execute_Parameter = $CmdLine[$i + 1]
		Case "/cmd_always"
			$CmdLine_b_Execute_Always = True
		Case "/show"
			$CmdLine_b_Show_GUI = True
	EndSwitch

Next

#cs
	_MsgBox_English(0, "", $CmdLine_i_TriggerID & @CRLF & _
	$CmdLine_b_TrayIcon_Hide & @CRLF & _
	$CmdLine_b_Exit_After_Execution & @CRLF & _
	$CmdLine_s_Execute_CommandLine & @CRLF & _
	$CmdLine_s_Execute_Parameter & @CRLF & _
	$CmdLine_b_Show_GUI & @CRLF & _
	$CmdLine_b_Execute_Always)
#ce

; Command Line Parameter Parsing - End

Global $hwnd_AutoIt = _EnforceSingleInstance($sGUID) ; any 'unique' string; created with http://www.guidgen.com/Index.aspx

If IniRead(@ScriptDir & "\HRC.ini", 'Settings', 'HRC_Version', "") <> $versionnumber Then
	IniWrite(@ScriptDir & "\HRC.ini", 'Settings', 'HRC_Version', $versionnumber)
	_MsgBox_English(48 + 262144, "HRC - First StartUp", @CRLF & "If you are stuck with a disabled display, remember to use the forced HotKey" & @CRLF & @CRLF & """CTRL-ALT-SHIFT-R""" & @CRLF & @CRLF & "which will reset the display to the initial resolution and acts as an emergency fallback." & @CRLF & @CRLF & "If that does not work, restart the computer in safe-mode and reset the resolution manually." & @CRLF & @CRLF & "I share this program with NO WARRANTIES and NO LIABILITY FOR DAMAGES!" & @CRLF & @CRLF & "Take a look at the help-screen (?) for details on available command line parameters.")
EndIf

Opt('GuiOnEventMode', 1)

; =================================================
; Get Resolutions START
; =================================================
; http://www.autoitscript.com/forum/index.php?showtopic=70679
; Mix from rasim and other replies
Global Const $ENUM_CURRENT_SETTINGS = -1
Global Const $ENUM_REGISTRY_SETTINGS = -2

Global $aSupportedResolutions[1][6]
Global $sCurrent_Setting_ColorDepth, $sCurrent_Setting_DesktopWidth, $sCurrent_Setting_DesktopHeigth, $sCurrent_Setting_MonitorFrequency
Global $sCombo_Resolution, $sCombo_ColorDepth, $sCombo_ColorDepth_Default, $sCombo_MonitorFreq

Global $hGUI_HRC_Main
Global $c_Hyperlink_URL_homepage, $c_Hyperlink_CC, $c_Hyperlink_Donate_Picture
Global $nCombo_Number, $nCombo_Number_Save, $nButton_Refresh
Global $nCombo_Res[10], $nCombo_Res_Save[10], $nCombo_Res_State[10], $nCombo_Fre[10], $nCombo_Col[10], $nButton_Apl[10]
Global $c_checkbox_Rawmode, $c_label_Rawmode
Global $c_checkbox_Rotatedmode, $c_label_Rotatedmode
;Global $c_checkbox_Largemode, $c_label_Largemode
Global $nCombo_Orientation

#include <Memory.au3>
Global $pEnumProc_ArraySortClib_Mem1 = _MemVirtualAlloc(0, 64, $MEM_COMMIT, $PAGE_EXECUTE_READWRITE) ; needed for _ArraySortClib()
Global $pEnumProc_ArraySortClib_Mem2 = _MemVirtualAlloc(0, 64, $MEM_COMMIT, $PAGE_EXECUTE_READWRITE) ; needed for _ArraySortClib()
Global $pEnumProc_ArraySortClib_Mem3 = _MemVirtualAlloc(0, 36, $MEM_COMMIT, $PAGE_EXECUTE_READWRITE) ; needed for _ArraySortClib()

#cs
	Global Const $tagDEVMODE = "char dmDeviceName[32];ushort dmSpecVersion;ushort dmDriverVersion;short dmSize;" & _
	"ushort dmDriverExtra;dword dmFields;short dmOrientation;short dmPaperSize;short dmPaperLength;" & _
	"short dmPaperWidth;short dmScale;short dmCopies;short dmDefaultSource;short dmPrintQuality;" & _
	"short dmColor;short dmDuplex;short dmYResolution;short dmTTOption;short dmCollate;" & _
	"byte dmFormName[32];dword dmBitsPerPel;int dmPelsWidth;dword dmPelsHeight;" & _
	"dword dmDisplayFlags;dword dmDisplayFrequency"
#ce

Global Const $_tag_POINTL = "long x;long y"
Global Const $_tag_DEVMODE = "char dmDeviceName[32];ushort dmSpecVersion;ushort dmDriverVersion;short dmSize;" & _
		"ushort dmDriverExtra;dword dmFields;" & $_tag_POINTL & ";dword dmDisplayOrientation;dword dmDisplayFixedOutput;" & _
		"short dmColor;short dmDuplex;short dmYResolution;short dmTTOption;short dmCollate;" & _
		"byte dmFormName[32];ushort LogPixels;dword dmBitsPerPel;int dmPelsWidth;dword dmPelsHeight;" & _
		"dword dmDisplayFlags;dword dmDisplayFrequency"

#cs
	Global Const $_tag_DEVMODE = "CHAR dmDeviceName[32];WORD dmSpecVersion;WORD dmDriverVersion;" & _
	"WORD dmSize;WORD dmDriverExtra;DWORD dmFields;LONG dmPositionx;LONG dmPositiony;DWORD dmDisplayOrientation;DWORD dmDisplayFixedOutput;" & _
	"short dmColor;short dmDuplex;short dmYResolution;short dmTTOption;short dmCollate;" & _
	"CHAR dmFormName[32];WORD dmLogPixels;DWORD dmBitsPerPel;DWORD dmPelsWidth;DWORD dmPelsHeight;" & _
	"DWORD dmDisplayFlags;DWORD dmDisplayFrequency;"

	Global Const $_tag_DEVMODE = "char dmDeviceName[32];ushort dmSpecVersion;ushort dmDriverVersion;short dmSize;" & _
	"ushort dmDriverExtra;dword dmFields;short dmOrientation;short dmPaperSize;short dmPaperLength;" & _
	"short dmPaperWidth;short dmScale;short dmCopies;short dmDefaultSource;short dmPrintQuality;" & _
	"short dmColor;short dmDuplex;short dmYResolution;short dmTTOption;short dmCollate;" & _
	"byte dmFormName[32];dword dmBitsPerPel;int dmPelsWidth;dword dmPelsHeight;" & _
	"dword dmDisplayFlags;dword dmDisplayFrequency"
#ce

; =======================
; Get initial DEVMODE structure for emergency recovery
; Trigger reset by calling _ApplySettings($i__HotKey_Event) with $i__HotKey_Event = 10
; =======================

Global $_Initial_DEVMODE
If Not _Initial_DEVMODE_Get() Then
	_MsgBox_English(16 + 262144, "HRC - StartUp ERROR", "HRC can not aquire the initial display setting. This is needed as an emergency fallback. HRC will exit now.")
	Exit
EndIf

; =======================
; Enum_Possible_Resolutions
; =======================

_Enum_Possible_Resolutions(1)
; ConsoleWrite("_Is_Orientation_Rotation_Supported" & @TAB & $b_Res_Orientation_Rotation_Supported & @CRLF)
_Enum_Possible_Resolutions()

_GDIPlus_Startup()

Global $hGUI_Help, $c_Help_Hyperlink_CC, $c_Help_Hyperlink_Funk

Global $hIML_Button_Apl = _GUIImageList_Create(39, 39, 5, 3, 1)
$hBitmap = _Load_BMP_From_Mem(_Base64String_BMP_Display(), True)
_GUIImageList_Add($hIML_Button_Apl, $hBitmap)
_WinAPI_DeleteObject($hBitmap)

; =======================
; Init Tray Settings
; =======================

TraySetClick(8)
Opt("TrayOnEventMode", 1)
Opt("TrayMenuMode", 3)
Opt("TrayAutoPause", 0)
TraySetOnEvent(-7, "_HRC_Recover")
$c_TrayItem_Restore = TrayCreateItem("Restore")
TrayItemSetOnEvent(-1, "_HRC_Recover")
$c_TrayItem_Exit = TrayCreateItem("Exit")
TrayItemSetOnEvent(-1, "_HRC_Exit")
TrayCreateItem("")
Global $a_TrayItem_Activate[1]
TraySetToolTip('HRC - HotKey Resolution Changer')

_GUI_Help_Create()
Global $iHotKeyBoxOffset
_GUICreate()
GUIRegisterMsg($WM_COMMAND, "WM_COMMAND")

If Not $CmdLine_b_TrayIcon_Hide And Not $CmdLine_b_Exit_After_Execution Then TraySetState()

; =================================================
; Main Loop
; =================================================

Global $iSuccess_TriggerID
If $CmdLine_i_TriggerID Then $iSuccess_TriggerID = _ApplySettings(($CmdLine_i_TriggerID - 1) / 2)
If ($iSuccess_TriggerID Or $CmdLine_b_Execute_Always) And $CmdLine_s_Execute_CommandLine Then ShellExecute($CmdLine_s_Execute_CommandLine, $CmdLine_s_Execute_Parameter)
If $CmdLine_b_Exit_After_Execution Then _HRC_Exit()

GUIRegisterMsg($WM_COPYDATA, "WM_COPYDATA")

If $CmdLine_b_Show_GUI Then _HRC_Recover()

AdlibRegister("_Reregister_Hotkeys", 3 * 60 * 1000)

While 1
	Sleep(10)
	If $i__HotKey_Event Then
		_ApplySettings($i__HotKey_Event)
		$i__HotKey_Event = 0
	EndIf
WEnd

Exit

Func _Reregister_Hotkeys()
	_HotKey_Disable()
	_HotKey_Enable()
EndFunc   ;==>_Reregister_Hotkeys

Func _Initial_DEVMODE_Get()
	$_Initial_DEVMODE = DllStructCreate($_tag_DEVMODE)
	DllStructSetData($_Initial_DEVMODE, "dmSize", DllStructGetSize($_Initial_DEVMODE))
	Local $i_DllRet = DllCall($h_DLL_user32, "int", "EnumDisplaySettingsEx", "ptr", 0, "dword", $ENUM_CURRENT_SETTINGS, "ptr", DllStructGetPtr($_Initial_DEVMODE), "dword", 0)
	If $i_DllRet[0] = 0 Then Return 0
	Return 1
EndFunc   ;==>_Initial_DEVMODE_Get

Func _Initial_DEVMODE_Reset_To()
	Local Const $HWND_BROADCAST = 0xffff
	Local Const $WM_DISPLAYCHANGE = 0x007E
	Local Const $CDS_UPDATEREGISTRY = 0x00000001
	Local Const $CDS_TEST = 0x00000002
	Local $i_DllRet = DllCall($h_DLL_user32, "int", "ChangeDisplaySettingsEx", "ptr", 0, "ptr", DllStructGetPtr($_Initial_DEVMODE), "hwnd", 0, "int", $CDS_TEST, "ptr", 0)
	$i_DllRet = DllCall($h_DLL_user32, "int", "ChangeDisplaySettingsEx", "ptr", 0, "ptr", DllStructGetPtr($_Initial_DEVMODE), "hwnd", 0, "int", $CDS_UPDATEREGISTRY, "ptr", 0)
	_SendMessageTimeout_Ex($HWND_BROADCAST, $WM_DISPLAYCHANGE, DllStructGetData($_Initial_DEVMODE, "dmBitsPerPel"), DllStructGetData($_Initial_DEVMODE, "dmPelsHeight") * 2 ^ 16 + DllStructGetData($_Initial_DEVMODE, "dmPelsWidth"))
EndFunc   ;==>_Initial_DEVMODE_Reset_To

Func _Initial_DEVMODE_HotKey()
	$i__HotKey_Event = 10
EndFunc   ;==>_Initial_DEVMODE_HotKey

; =================================================
; Get all possible resolutions from WinAPI
; =================================================

Func _Enum_Possible_Resolutions($is_Orientation_Rotation_Supported = 0)

	#cs
		To ensure that the DEVMODE structure passed to ChangeDisplaySettingsEx is valid and contains only values supported by the display driver, use the DEVMODE returned by the EnumDisplaySettings function.
		When adding a display monitor to a multiple-monitor system programmatically, set DEVMODE.dmFields to DM_POSITION and specify a position (in DEVMODE.dmPosition) for the monitor you are adding that is adjacent to at least one pixel of the display area of an existing monitor. To detach the monitor, set DEVMODE.dmFields to DM_POSITION but set DEVMODE.dmPelsWidth and DEVMODE.dmPelsHeight to zero. For more information, see Multiple Display Monitors.
	#ce

	Local $DEVMODE = DllStructCreate($_tag_DEVMODE)
	DllStructSetData($DEVMODE, "dmSize", DllStructGetSize($DEVMODE))

	Local $iFlags = 0
	Local Const $EDS_RAWMODE = 0x00000002
	; If set, the function will return all graphics modes reported by the adapter driver, regardless of monitor capabilities. Otherwise, it will only return modes that are compatible with current monitors.
	Local Const $EDS_ROTATEDMODE = 0x00000004
	; If set, the function will return graphics modes in all orientations. Otherwise, it will only return modes that have the same orientation as the one currently set for the requested display.
	If Not $is_Orientation_Rotation_Supported Then
		If IniRead(@ScriptDir & "\HRC.ini", 'Settings', 'RAWMODE', 4) = 1 Then $iFlags = BitOR($iFlags, $EDS_RAWMODE)
		If IniRead(@ScriptDir & "\HRC.ini", 'Settings', 'ROTATEDMODE', 4) = 1 Then $iFlags = BitOR($iFlags, $EDS_ROTATEDMODE)
	EndIf

	#cs
		Local $b_Largemode = False
		If IniRead(@ScriptDir & "\HRC.ini", 'Settings', 'Largemode', 4) = 1 Then $b_Largemode = True
	#ce

	; Get current graphic settings
	; =================================================
	$DllRet = DllCall($h_DLL_user32, "int", "EnumDisplaySettingsEx", "ptr", 0, "dword", $ENUM_CURRENT_SETTINGS, "ptr", DllStructGetPtr($DEVMODE), "dword", 0)
	If $DllRet[0] = 0 Then
		ConsoleWrite(@CRLF & "From reg" & @CRLF)
		$DllRet = DllCall($h_DLL_user32, "int", "EnumDisplaySettingsEx", "ptr", 0, "dword", $ENUM_REGISTRY_SETTINGS, "ptr", DllStructGetPtr($DEVMODE), "dword", 0)
	EndIf

	$sCurrent_Setting_ColorDepth = DllStructGetData($DEVMODE, "dmBitsPerPel")
	$sCurrent_Setting_DesktopWidth = DllStructGetData($DEVMODE, "dmPelsWidth")
	$sCurrent_Setting_DesktopHeigth = DllStructGetData($DEVMODE, "dmPelsHeight")
	$sCurrent_Setting_MonitorFrequency = DllStructGetData($DEVMODE, "dmDisplayFrequency")

	If Not $i_Initial_Width Then $i_Initial_Width = $sCurrent_Setting_DesktopWidth
	If Not $i_Initial_Heigth Then $i_Initial_Heigth = $sCurrent_Setting_DesktopHeigth

	$ENUM_ALL_SETTINGS = 0
	$i = 0
	ReDim $aSupportedResolutions[1000][6]

	Local $i_current_Width, $i_current_Height

	Do
		$DllRet = DllCall($h_DLL_user32, "int", "EnumDisplaySettingsEx", "ptr", 0, "dword", $ENUM_ALL_SETTINGS, "ptr", DllStructGetPtr($DEVMODE), "dword", $iFlags)
		$DllRet = $DllRet[0]

		$i_current_Width = DllStructGetData($DEVMODE, "dmPelsWidth")
		$i_current_Height = DllStructGetData($DEVMODE, "dmPelsHeight")

		If $is_Orientation_Rotation_Supported Then
			If Not $b_Res_Orientation_Rotation_Supported Then
				If DllStructGetData($DEVMODE, "dmDisplayOrientation") Then $b_Res_Orientation_Rotation_Supported = True
			EndIf
		EndIf

		If Not BitAND($iFlags, $EDS_ROTATEDMODE) Then
			If $i_current_Height > $i_current_Width Then
				$ENUM_ALL_SETTINGS += 1
				ContinueLoop
			EndIf
		EndIf

		#cs
			If Not $b_Largemode Then
			If $b_Res_Orientation_Rotation_Supported Then
			If ($i_current_Width > $i_Initial_Width And $i_current_Width > $i_Initial_Heigth) Or ($i_current_Height > $i_Initial_Heigth And $i_current_Height > $i_Initial_Width) Then
			$ENUM_ALL_SETTINGS += 1
			ContinueLoop
			EndIf
			Else
			If $i_current_Width > $i_Initial_Width Or $i_current_Height > $i_Initial_Heigth Then
			$ENUM_ALL_SETTINGS += 1
			ContinueLoop
			EndIf
			EndIf
			EndIf
		#ce

		$aSupportedResolutions[$i][0] = $i_current_Width
		$aSupportedResolutions[$i][1] = $i_current_Height
		$aSupportedResolutions[$i][2] = DllStructGetData($DEVMODE, "dmBitsPerPel") ; Color Bits
		$aSupportedResolutions[$i][4] = DllStructGetData($DEVMODE, "dmDisplayFrequency") ; Frequency

		#cs
			ConsoleWrite(DllStructGetData($DEVMODE, "dmPelsWidth") & @CRLF)
			ConsoleWrite(DllStructGetData($DEVMODE, "dmPelsHeight") & @CRLF)
			ConsoleWrite(DllStructGetData($DEVMODE, "dmBitsPerPel") & @CRLF)
			ConsoleWrite(DllStructGetData($DEVMODE, "dmDisplayFrequency") & @CRLF)
			ConsoleWrite(DllStructGetData($DEVMODE, "dmDisplayOrientation") & @CRLF)
			ConsoleWrite(@CRLF)
		#ce

		; Color Names
		Switch $aSupportedResolutions[$i][2]
			Case 1
				$aSupportedResolutions[$i][3] = "1 Bit - 2 colors"
			Case 2
				$aSupportedResolutions[$i][3] = "2 Bit - 4 colors"
			Case 3
				$aSupportedResolutions[$i][3] = "3 Bit - 8 colors"
			Case 4
				$aSupportedResolutions[$i][3] = "4 Bit - 16 colors"
			Case 5
				$aSupportedResolutions[$i][3] = "5 Bit - 32 colors"
			Case 6
				$aSupportedResolutions[$i][3] = "6 Bit - 64 colors"
			Case 8
				$aSupportedResolutions[$i][3] = "8 Bit - 256 colors"
			Case 12
				$aSupportedResolutions[$i][3] = "12 Bit - 4.096 colors"
			Case 16
				$aSupportedResolutions[$i][3] = "16 Bit - 65k colors"
			Case 32
				$aSupportedResolutions[$i][3] = "32 Bit - 4 billion colors"
		EndSwitch

		; Sort Column
		$aSupportedResolutions[$i][5] = StringFormat("%04i", $aSupportedResolutions[$i][0]) & StringFormat("%04i", $aSupportedResolutions[$i][1]) & StringFormat("%02i", $aSupportedResolutions[$i][2]) & StringFormat("%03i", $aSupportedResolutions[$i][4])

		If $DllRet <> 0 Then
			$ENUM_ALL_SETTINGS += 1
			$i += 1
			If Not Mod(1000, $i) Then ReDim $aSupportedResolutions[UBound($aSupportedResolutions) + 1000][6]
		EndIf

	Until $DllRet = 0

	ReDim $aSupportedResolutions[$i + 1][6]
	; ConsoleWrite(TimerInit() & @TAB & $i + 1 & @TAB & $ENUM_ALL_SETTINGS & @CRLF)

	$DEVMODE = 0

	_ArraySortClib($aSupportedResolutions, 0, True, 0, 0, 5)

	; =================================================
	; Get Resolutions END
	; =================================================

	$sCombo_Resolution = ""
	For $i = 0 To UBound($aSupportedResolutions) - 1
		If Not StringInStr($sCombo_Resolution, $aSupportedResolutions[$i][0] & " x " & $aSupportedResolutions[$i][1]) Then $sCombo_Resolution &= "|" & $aSupportedResolutions[$i][0] & " x " & $aSupportedResolutions[$i][1]
	Next
	$sCombo_ColorDepth = ""
	$sCombo_ColorDepth_Default = ""
	For $i = 0 To UBound($aSupportedResolutions) - 1
		If StringInStr($sCurrent_Setting_DesktopWidth & " x " & $sCurrent_Setting_DesktopHeigth, $aSupportedResolutions[$i][0] & " x " & $aSupportedResolutions[$i][1]) And Not StringInStr($sCombo_ColorDepth, $aSupportedResolutions[$i][3]) Then $sCombo_ColorDepth &= "|" & $aSupportedResolutions[$i][3]
		If $aSupportedResolutions[$i][2] = $sCurrent_Setting_ColorDepth Then $sCombo_ColorDepth_Default = $aSupportedResolutions[$i][3]
	Next
	$sCombo_MonitorFreq = ""
	For $i = 0 To UBound($aSupportedResolutions) - 1
		If $sCurrent_Setting_DesktopWidth & " x " & $sCurrent_Setting_DesktopHeigth = $aSupportedResolutions[$i][0] & " x " & $aSupportedResolutions[$i][1] Then
			If Not StringInStr($sCombo_MonitorFreq, $aSupportedResolutions[$i][4]) Then $sCombo_MonitorFreq &= "|" & $aSupportedResolutions[$i][4] & " Hertz"
		EndIf
	Next

	$nCombo_Res[0] = IniRead(@ScriptDir & "\HRC.ini", 'Settings', 'NumberOfHotKeyBoxes', 2) + 1

EndFunc   ;==>_Enum_Possible_Resolutions


; =================================================
; GUI Creation
; =================================================
Func _GUICreate()

	$iHotKeyBoxOffset = IniRead(@ScriptDir & "\HRC.ini", 'Settings', 'NumberOfHotKeyBoxes', 2) + 1

	If IsHWnd($hGUI_HRC_Main) Then
		For $i = 1 To UBound($HotkeyInput) - 1
			_GUICtrlHKI_Destroy($HotkeyInput[$i])
		Next
		#cs
			For $i = $iHotKeyBoxOffset To 9
			IniDelete(@ScriptDir & "\HRC.ini", 'Settings', 'Res' & $i)
			IniDelete(@ScriptDir & "\HRC.ini", 'Settings', 'Col' & $i)
			IniDelete(@ScriptDir & "\HRC.ini", 'Settings', 'Fre' & $i)
			IniDelete(@ScriptDir & "\HRC.ini", 'Settings', 'HotkeyInput' & $i)
			Next
		#ce
	EndIf

	$hGUI_HRC_Main = GUICreate($mainguititel & " " & $sGUID, 420, 30 + 228 + (($iHotKeyBoxOffset - 3) * 80), Default, Default, BitOR($WS_POPUP, $WS_BORDER), BitOR($WS_EX_DLGMODALFRAME, $WS_EX_TOPMOST, $WS_EX_TOOLWINDOW))
	WinSetOnTop($hGUI_HRC_Main, '', 1)
	GUISetOnEvent($GUI_EVENT_CLOSE, "_HRC_MinToTray")


	_SetFont_hWnd($i_Font_Adjustment + 8, 400, 0, $s_Global_Font)

	ControlSetText($hwnd_AutoIt, '', ControlGetHandle($hwnd_AutoIt, '', 'Edit1'), $hGUI_HRC_Main) ; to pass hWnd of main GUI to AutoIt default GUI

	#cs
		GUICtrlCreateButton("", 0, 0, 0, 0)
		GUICtrlSetOnEvent(-1, "_HRC_Exit")
	#ce

	; GUI Header
	GUICtrlCreateLabel("", 0, 0, 360, 24, 0, $GUI_WS_EX_PARENTDRAG)
	GUICtrlSetBkColor(-1, 0xEEF1F6)
	GUICtrlCreateLabel("", 0, 21, 421, 1)
	GUICtrlSetBkColor(-1, 0x434343)

	$mainguititel_label = GUICtrlCreateLabel($mainguititel, 25, 3, 320, 20, 0, $GUI_WS_EX_PARENTDRAG)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	_SetFont_Ctrl(-1, $i_Font_Adjustment + 9, 800, 0, $s_Global_Font)
	GUICtrlCreateIcon(@ScriptName, -1, 3, 3, 16, 16)

	$c_Icon_Help = GUICtrlCreatePic("", 360, 3, 16, 16)
	GUICtrlSetCursor(-1, 0)
	GUICtrlSetTip(-1, "Help")
	GUICtrlSetOnEvent(-1, "_HRC_Help")
	$hBitmap = _Load_BMP_From_Mem(_Base64String_Icon_Help(), True)
	_WinAPI_DeleteObject(GUICtrlSendMsg($c_Icon_Help, $STM_SETIMAGE, $IMAGE_BITMAP, $hBitmap))
	_WinAPI_DeleteObject($hBitmap)

	$c_Icon_Minimize = GUICtrlCreatePic("", 380, 3, 16, 16)
	GUICtrlSetCursor(-1, 0)
	GUICtrlSetTip(-1, "Minimize to tray")
	GUICtrlSetOnEvent(-1, "_HRC_MinToTray")
	$hBitmap = _Load_BMP_From_Mem(_Base64String_Icon_Minimize(), True)
	_WinAPI_DeleteObject(GUICtrlSendMsg($c_Icon_Minimize, $STM_SETIMAGE, $IMAGE_BITMAP, $hBitmap))
	_WinAPI_DeleteObject($hBitmap)

	$c_Icon_Close = GUICtrlCreatePic("", 400, 3, 16, 16)
	GUICtrlSetCursor(-1, 0)
	GUICtrlSetTip(-1, "Exit HCR")
	GUICtrlSetOnEvent(-1, "_HRC_Exit")

	$hBitmap = _Load_BMP_From_Mem(_Base64String_Icon_Close(), True)
	_WinAPI_DeleteObject(GUICtrlSendMsg($c_Icon_Close, $STM_SETIMAGE, $IMAGE_BITMAP, $hBitmap))
	_WinAPI_DeleteObject($hBitmap)

	GUICtrlCreateLabel("", 0, 22, 420, 40 + 210 - 22 + (($iHotKeyBoxOffset - 3) * 80) + 20)
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetBkColor(-1, 0xFFFFFF)

	; GUI Footer

	GUICtrlCreateLabel("Number of HotKeys", 7, 187 + (($iHotKeyBoxOffset - 3) * 80), 90, 17)
	GUICtrlSetColor(-1, 0xA7A6AA)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	_SetFont_Ctrl(-1, $i_Font_Adjustment + 8, 400, 0, $s_Global_Font)
	GUICtrlSetTip(-1, "Select the number of resolution hotkey combos to customize")
	GUICtrlSetCursor(-1, 0)
	$nCombo_Number = GUICtrlCreateCombo("", 105, 184 + (($iHotKeyBoxOffset - 3) * 80), 45, 20, BitOR($CBS_DROPDOWNLIST, $WS_VSCROLL))
	GUICtrlSetOnEvent(-1, 'ControlEvents')
	_SetFont_Ctrl(-1, $i_Font_Adjustment + 8, 800, 0, $s_Global_Font)
	GUICtrlSetData(-1, "2|3|4|5|6|7|8|9", $iHotKeyBoxOffset - 1)

	GUICtrlCreateLabel("CTRL-ALT-R", 210 - 40 - 4, 1 + 182 + (($iHotKeyBoxOffset - 3) * 80), 210, 17)
	_SetFont_Ctrl(-1, $i_Font_Adjustment + 6.8, 400, 0, $s_Global_Font)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetColor(-1, 0xA7A6AA)
	GUICtrlCreateLabel("- recover from tray", 210 - 40 - 4 + 85, 1 + 182 + (($iHotKeyBoxOffset - 3) * 80), 210, 17)
	_SetFont_Ctrl(-1, $i_Font_Adjustment + 6.8, 400, 0, $s_Global_Font)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetColor(-1, 0xA7A6AA)

	GUICtrlCreateLabel("CTRL-ALT-SHIFT-R", 210 - 40 - 4, 1 + 12 + 182 + (($iHotKeyBoxOffset - 3) * 80), 270, 17)
	_SetFont_Ctrl(-1, $i_Font_Adjustment + 6.8, 400, 0, $s_Global_Font)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetColor(-1, 0xA7A6AA)
	GUICtrlCreateLabel("- initial resolution", 210 - 40 - 4 + 85, 1 + 12 + 182 + (($iHotKeyBoxOffset - 3) * 80), 270, 17)
	_SetFont_Ctrl(-1, $i_Font_Adjustment + 6.8, 400, 0, $s_Global_Font)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetColor(-1, 0xA7A6AA)

	GUICtrlCreateLabel("Default Orientation", 7, 2 + (($iHotKeyBoxOffset - 3) * 80) + 210, 90, 14)
	_SetFont_Ctrl(-1, $i_Font_Adjustment + 8, 400, 0, $s_Global_Font)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetColor(-1, 0xA7A6AA)
	If Not $b_Res_Orientation_Rotation_Supported Then
		GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlSetTip(-1, "Portrait format resolutions does not seem to be supported by your monitor")
	Else
		GUICtrlSetCursor(-1, 0)
		GUICtrlSetTip(-1, "Set the default rotation to use for portrait format resolutions")
	EndIf
	$nCombo_Orientation = GUICtrlCreateCombo("", 105, 2 + (($iHotKeyBoxOffset - 3) * 80) + 210 - 4, 45, 20, BitOR($CBS_DROPDOWNLIST, $WS_VSCROLL))
	_SetFont_Ctrl(-1, $i_Font_Adjustment + 8, 800, 0, $s_Global_Font)
	GUICtrlSetOnEvent(-1, 'ControlEvents')
	GUICtrlSetData(-1, "090|270", IniRead(@ScriptDir & "\HRC.ini", 'Settings', 'Default_Orientation', "090"))
	If Not $b_Res_Orientation_Rotation_Supported Then
		GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlSetTip(-1, "Portrait format resolutions does not seem to be supported by your monitor")
	Else
		GUICtrlSetTip(-1, "Set the default rotation to use for portrait format resolutions")
	EndIf

	Local $sTipText = "If set, HRC will return all graphics modes reported by the adapter driver, regardless of monitor capabilities." & @CRLF & "Otherwise, HRC will only return modes that are compatible with current monitors."
	$c_checkbox_Rawmode = GUICtrlCreateCheckbox("", 210 - 40 - 4, 2 + (($iHotKeyBoxOffset - 3) * 80) + 210, 14, 14)
	GUICtrlSetCursor(-1, 0)
	GUICtrlSetTip(-1, $sTipText)
	GUICtrlSetOnEvent(-1, 'ControlEvents')
	GUICtrlSetState($c_checkbox_Rawmode, IniRead(@ScriptDir & "\HRC.ini", 'Settings', 'RAWMODE', 4))
	$c_label_Rawmode = GUICtrlCreateLabel(" Rawmode", 224 - 40 - 4, 2 + (($iHotKeyBoxOffset - 3) * 80) + 210, 52, 14)
	_SetFont_Ctrl(-1, $i_Font_Adjustment + 8, 400, 0, $s_Global_Font)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetColor(-1, 0xA7A6AA)
	GUICtrlSetCursor(-1, 0)
	GUICtrlSetTip(-1, $sTipText)

	$sTipText = "If set, HRC will return graphics modes in all orientations." & @CRLF & "Otherwise, HRC will only return modes that have the same orientation as the one currently set for the requested display."
	$c_checkbox_Rotatedmode = GUICtrlCreateCheckbox("", 310 - 63, 2 + (($iHotKeyBoxOffset - 3) * 80) + 210, 14, 14)
	If Not $b_Res_Orientation_Rotation_Supported Then
		GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlSetTip(-1, "Portrait format resolutions does not seem to be supported by your monitor")
	Else
		GUICtrlSetOnEvent(-1, 'ControlEvents')
		GUICtrlSetState($c_checkbox_Rotatedmode, IniRead(@ScriptDir & "\HRC.ini", 'Settings', 'ROTATEDMODE', 4))
		GUICtrlSetCursor(-1, 0)
		GUICtrlSetTip(-1, $sTipText)
	EndIf
	$c_label_Rotatedmode = GUICtrlCreateLabel(" Rotatedmode", 324 - 63, 2 + (($iHotKeyBoxOffset - 3) * 80) + 210, 68, 14)
	_SetFont_Ctrl(-1, $i_Font_Adjustment + 8, 400, 0, $s_Global_Font)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetColor(-1, 0xA7A6AA)
	If Not $b_Res_Orientation_Rotation_Supported Then
		GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlSetTip(-1, "Portrait format resolutions does not seem to be supported by your monitor")
	Else
		GUICtrlSetTip(-1, $sTipText)
		GUICtrlSetCursor(-1, 0)
	EndIf

	#cs
		$sTipText = "If set, HRC will allow selection of larger than the initial resolution size." & @CRLF & @CRLF & "Warning: This might disable you display and force you to restart Windows in save mode!"
		$c_checkbox_Largemode = GUICtrlCreateCheckbox("", 310 + 30, 2 + (($iHotKeyBoxOffset - 3) * 80) + 210, 14, 14)
		GUICtrlSetCursor(-1, 0)
		GUICtrlSetTip(-1, $sTipText)
		GUICtrlSetOnEvent(-1, 'ControlEvents')
		GUICtrlSetState($c_checkbox_Largemode, IniRead(@ScriptDir & "\HRC.ini", 'Settings', 'Largemode', 4))
		$c_label_Largemode = GUICtrlCreateLabel(" Largemode", 324 + 30, 2 + (($iHotKeyBoxOffset - 3) * 80) + 210, 68, 14)
		_SetFont_Ctrl(-1, $i_Font_Adjustment + 8, 400, 0, $s_Global_Font)
		GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
		GUICtrlSetColor(-1, 0xA7A6AA)
		GUICtrlSetCursor(-1, 0)
		GUICtrlSetTip(-1, $sTipText)
	#ce


	$c_Hyperlink_CC = GUICtrlCreatePic("", 10, 2 + 234 + (($iHotKeyBoxOffset - 3) * 80), 80, 15, $SS_NOTIFY)
	GUICtrlSetCursor($c_Hyperlink_CC, 0)
	GUICtrlSetBkColor(-1, 0x00ff00)

	GUICtrlCreateLabel("For support visit ", 140 - 7, 5 + 234 + (($iHotKeyBoxOffset - 3) * 80), 74, 17)
	_SetFont_Ctrl(-1, $i_Font_Adjustment + 7, 400, 0, $s_Global_Font)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetColor(-1, 0xA7A6AA)

	$c_Hyperlink_URL_homepage = GUICtrlCreateLabel('http://www.funk.eu', 213 - 7, 5 + 234 + (($iHotKeyBoxOffset - 3) * 80), 78, 17)
	_SetFont_Ctrl(-1, $i_Font_Adjustment + 7, 400, 0, $s_Global_Font)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetColor(-1, 0x1111CC)
	GUICtrlSetCursor(-1, 0)

	$c_Hyperlink_Donate_Picture = GUICtrlCreatePic("", 310, 233 + (($iHotKeyBoxOffset - 3) * 80), 100, 20, $SS_NOTIFY)
	GUICtrlSetCursor($c_Hyperlink_Donate_Picture, 0)
	GUICtrlSetBkColor(-1, 0x00ff00)

	Local $hBitmap_License = _Load_BMP_From_Mem(_BinaryString_Picture_License(), True)
	_WinAPI_DeleteObject(GUICtrlSendMsg($c_Hyperlink_CC, $STM_SETIMAGE, $IMAGE_BITMAP, $hBitmap_License))
	_WinAPI_DeleteObject($hBitmap_License)
	Local $hBitmap_Donate = _Load_BMP_From_Mem(_BinaryString_Picture_Donate(), True)
	_WinAPI_DeleteObject(GUICtrlSendMsg($c_Hyperlink_Donate_Picture, $STM_SETIMAGE, $IMAGE_BITMAP, $hBitmap_Donate))
	_WinAPI_DeleteObject($hBitmap_Donate)

	; Create HotKey Settings Section
	ReDim $HotkeyInput[$iHotKeyBoxOffset]
	ReDim $HotkeyInputLock[$iHotKeyBoxOffset]
	Local $sIniRead

	For $iHotKeyBoxOffset_Enum = 1 To GUICtrlRead($nCombo_Number)

		GUICtrlCreateLabel("", 6, 28 + (($iHotKeyBoxOffset_Enum - 1) * 80), 408, 71)
		GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlSetBkColor(-1, 0xababab)

		GUICtrlCreateLabel("", 7, 29 + (($iHotKeyBoxOffset_Enum - 1) * 80), 406, 69)
		GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlSetBkColor(-1, 0xEEF1F6)

		If $iHotKeyBoxOffset_Enum = 1 Then
			$nButton_Refresh = GUICtrlCreateButton("Refresh supported resolutions", 247, 32, 160, 15)
			_SetFont_Ctrl(-1, $i_Font_Adjustment + 7, 400, 0, $s_Global_Font)
			GUICtrlSetOnEvent(-1, 'ControlEvents')
		EndIf

		GUICtrlCreateLabel("Hotkey", 16, 32 + (($iHotKeyBoxOffset_Enum - 1) * 80) + 2, 35, 15)
		_SetFont_Ctrl(-1, $i_Font_Adjustment + 7, 800, 0, $s_Global_Font)
		$HotkeyInput[$iHotKeyBoxOffset_Enum] = _GUICtrlHKI_Create(IniRead(@ScriptDir & "\HRC.ini", 'Settings', 'HotkeyInput' & $iHotKeyBoxOffset_Enum, "0x0000"), 16 + 35, 32 + (($iHotKeyBoxOffset_Enum - 1) * 80), 60, 15)
		GUICtrlSetBkColor(-1, 0xFFFED8)
		_SetFont_Ctrl(-1, $i_Font_Adjustment + 7, 800, 0, $s_Global_Font)
		GUICtrlSetState(-1, $GUI_DISABLE)

		$HotkeyInputLock[$iHotKeyBoxOffset_Enum] = GUICtrlCreateButton("Change", 115, 32 + (($iHotKeyBoxOffset_Enum - 1) * 80), 50, 15)
		_SetFont_Ctrl(-1, $i_Font_Adjustment + 7, 800, 0, $s_Global_Font)

		#cs
			GUICtrlCreateLabel("""HRC.exe R" & $iHotKeyBoxOffset_Enum & """", 170, 34 + (($iHotKeyBoxOffset_Enum - 1) * 80), 78, 12)
			_SetFont_Ctrl(-1, $i_Font_Adjustment + 7, 400, 0, $s_Global_Font)
		#ce

		$nCombo_Res[$iHotKeyBoxOffset_Enum] = GUICtrlCreateCombo("", 15, 50 + (($iHotKeyBoxOffset_Enum - 1) * 80), 210, 25, BitOR($CBS_DROPDOWNLIST, $WS_VSCROLL))
		GUICtrlSetOnEvent(-1, 'ControlEvents')
		_SetFont_Ctrl(-1, $i_Font_Adjustment + 22, 800, 0, $s_Global_Font)

		_GUICtrlComboBox_InitStorage($nCombo_Res[$iHotKeyBoxOffset_Enum], 50, 500)

		$nCombo_Col[$iHotKeyBoxOffset_Enum] = GUICtrlCreateCombo("", 230, 50 + (($iHotKeyBoxOffset_Enum - 1) * 80), 127, 20, BitOR($CBS_DROPDOWNLIST, $WS_VSCROLL))
		_SetFont_Ctrl(-1, $i_Font_Adjustment + 7, 400, 0, $s_Global_Font)

		$nCombo_Fre[$iHotKeyBoxOffset_Enum] = GUICtrlCreateCombo("", 230, 71 + (($iHotKeyBoxOffset_Enum - 1) * 80), 127, 20, BitOR($CBS_DROPDOWNLIST, $WS_VSCROLL))
		_SetFont_Ctrl(-1, $i_Font_Adjustment + 7, 400, 0, $s_Global_Font)

		$nButton_Apl[$iHotKeyBoxOffset_Enum] = GUICtrlCreateButton("", 367, 50 + (($iHotKeyBoxOffset_Enum - 1) * 80), 39, 39, $BS_BITMAP)
		_GUICtrlButton_SetImageList($nButton_Apl[$iHotKeyBoxOffset_Enum], $hIML_Button_Apl, 4)
		GUICtrlSetCursor(-1, 0)

		$sIniRead = IniRead(@ScriptDir & "\HRC.ini", 'Settings', 'Res' & $iHotKeyBoxOffset_Enum, "")
		_GUICtrlComboBox_BeginUpdate($nCombo_Res[$iHotKeyBoxOffset_Enum])
		If StringInStr($sCombo_Resolution, $sIniRead) Then
			GUICtrlSetData($nCombo_Res[$iHotKeyBoxOffset_Enum], $sCombo_Resolution, $sIniRead)
		Else
			GUICtrlSetData($nCombo_Res[$iHotKeyBoxOffset_Enum], $sCombo_Resolution, $sCurrent_Setting_DesktopWidth & " x " & $sCurrent_Setting_DesktopHeigth)
		EndIf
		_GUICtrlComboBox_EndUpdate($nCombo_Res[$iHotKeyBoxOffset_Enum])

		$nCombo_Res_Save[$iHotKeyBoxOffset_Enum] = GUICtrlRead($nCombo_Res[$iHotKeyBoxOffset_Enum])
		$sCombo_ColorDepth = ""
		$sCombo_ColorDepth_Default = ""
		For $i = 0 To UBound($aSupportedResolutions) - 1
			If StringInStr($nCombo_Res_Save[$iHotKeyBoxOffset_Enum], $aSupportedResolutions[$i][0] & " x " & $aSupportedResolutions[$i][1]) And Not StringInStr($sCombo_ColorDepth, $aSupportedResolutions[$i][3]) Then $sCombo_ColorDepth &= "|" & $aSupportedResolutions[$i][3]
			If $aSupportedResolutions[$i][2] = $sCurrent_Setting_ColorDepth Then $sCombo_ColorDepth_Default = $aSupportedResolutions[$i][3]
		Next
		$sCombo_MonitorFreq = ""
		For $i = 0 To UBound($aSupportedResolutions) - 1
			If StringInStr($sCombo_ColorDepth, $aSupportedResolutions[$i][3]) And StringInStr($nCombo_Res_Save[$iHotKeyBoxOffset_Enum], $aSupportedResolutions[$i][0] & " x " & $aSupportedResolutions[$i][1]) And Not StringInStr($sCombo_MonitorFreq, $aSupportedResolutions[$i][4]) Then $sCombo_MonitorFreq &= "|" & $aSupportedResolutions[$i][4] & " Hertz"
		Next

		$sIniRead = IniRead(@ScriptDir & "\HRC.ini", 'Settings', 'Col' & $iHotKeyBoxOffset_Enum, "")
		If StringInStr($sCombo_ColorDepth, $sIniRead) Then
			GUICtrlSetData($nCombo_Col[$iHotKeyBoxOffset_Enum], $sCombo_ColorDepth, $sIniRead)
		Else
			GUICtrlSetData($nCombo_Col[$iHotKeyBoxOffset_Enum], $sCombo_ColorDepth, $sCombo_ColorDepth_Default)
		EndIf

		$sIniRead = IniRead(@ScriptDir & "\HRC.ini", 'Settings', 'Fre' & $iHotKeyBoxOffset_Enum, "")
		If StringInStr($sCombo_MonitorFreq, $sIniRead) Then
			GUICtrlSetData($nCombo_Fre[$iHotKeyBoxOffset_Enum], $sCombo_MonitorFreq, $sIniRead)
		Else
			GUICtrlSetData($nCombo_Fre[$iHotKeyBoxOffset_Enum], $sCombo_MonitorFreq, $sCurrent_Setting_MonitorFrequency & " Hertz")
		EndIf
		$nCombo_Res_Save[$iHotKeyBoxOffset_Enum] = GUICtrlRead($nCombo_Res[$iHotKeyBoxOffset_Enum])

	Next

	$nCombo_Number_Save = GUICtrlRead($nCombo_Number)

	_HotKey_Release()
	For $iHotKeyBoxOffset_Enum = 1 To GUICtrlRead($nCombo_Number)
		_ReAssignHotkeys($HotkeyInput[$iHotKeyBoxOffset_Enum])
	Next

	_Update_TrayItems()

EndFunc   ;==>_GUICreate

Func _Update_TrayItems()
	For $i = 1 To UBound($a_TrayItem_Activate) - 1
		TrayItemDelete($a_TrayItem_Activate[$i])
	Next
	$iHotKeyBoxOffset = IniRead(@ScriptDir & "\HRC.ini", 'Settings', 'NumberOfHotKeyBoxes', 2) + 1
	ReDim $a_TrayItem_Activate[$iHotKeyBoxOffset]
	For $iHotKeyBoxOffset_Enum = 1 To GUICtrlRead($nCombo_Number)
		$a_TrayItem_Activate[$iHotKeyBoxOffset_Enum] = TrayCreateItem($iHotKeyBoxOffset_Enum & ": " & GUICtrlRead($nCombo_Res[$iHotKeyBoxOffset_Enum]) & " @ " & StringReplace(GUICtrlRead($nCombo_Fre[$iHotKeyBoxOffset_Enum]), "Hertz", "Hz"))
		TrayItemSetOnEvent(-1, "_ControlEvents_TRAY")
	Next
EndFunc   ;==>_Update_TrayItems

Func WM_COMMAND($hWnd, $Msg, $wParam, $lParam)
	$nNotifyCode = BitShift($wParam, 16)
	$nID = BitAND($wParam, 0x0000FFFF)
	$hCtrl = $lParam

	Switch $nID

		Case $c_label_Rawmode
			ControlClick($hGUI_HRC_Main, "", $c_checkbox_Rawmode)
			Return $GUI_RUNDEFMSG

		Case $c_label_Rotatedmode
			If $b_Res_Orientation_Rotation_Supported Then ControlClick($hGUI_HRC_Main, "", $c_checkbox_Rotatedmode)
			Return $GUI_RUNDEFMSG

			#cs
				Case $c_label_Largemode
				ControlClick($hGUI_HRC_Main, "", $c_checkbox_Largemode)
				Return $GUI_RUNDEFMSG
			#ce

		Case $c_Hyperlink_URL_homepage
			ShellExecute('http://www.funk.eu')
			Return $GUI_RUNDEFMSG

		Case $c_Hyperlink_Donate_Picture
			ShellExecute("https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=donate%40funk%2eeu&item_name=Thank%20you%20for%20your%20donation%20to%20HRC...&no_shipping=0&no_note=1&tax=0&currency_code=EUR&lc=US&bn=PP%2dDonationsBF&charset=UTF%2d8")
			Return $GUI_RUNDEFMSG

		Case $c_Hyperlink_CC
			ShellExecute("http://creativecommons.org/licenses/by-nc-nd/3.0/us/")
			Return $GUI_RUNDEFMSG

	EndSwitch

	For $iHotKeyBoxOffset_Enum = 1 To UBound($HotkeyInput) - 1
		Switch $nID

			Case $nCombo_Res[$iHotKeyBoxOffset_Enum], $nCombo_Col[$iHotKeyBoxOffset_Enum], $nCombo_Fre[$iHotKeyBoxOffset_Enum]
				If $nNotifyCode = 1 Then
					_Save_Combo_States()
					_Update_TrayItems()
				EndIf
				If $nNotifyCode = 8 Then _WinAPI_InvalidateRect(ControlGetHandle($hGUI_HRC_Main, "", $nID))
				Return $GUI_RUNDEFMSG

			Case $HotkeyInput[$iHotKeyBoxOffset_Enum]
				Switch $nNotifyCode
					Case 256 ; get focus
						_HotKey_Release()
						Return $GUI_RUNDEFMSG
					Case 512 ; lose focus
						ControlClick($hGUI_HRC_Main, '', $HotkeyInputLock[$iHotKeyBoxOffset_Enum])
						Return $GUI_RUNDEFMSG
				EndSwitch
				Return $GUI_RUNDEFMSG

			Case $HotkeyInputLock[$iHotKeyBoxOffset_Enum]
				Switch GUICtrlRead($HotkeyInputLock[$iHotKeyBoxOffset_Enum])
					Case "Change"
						GUICtrlSetData($HotkeyInputLock[$iHotKeyBoxOffset_Enum], "Set")
						GUICtrlSetState($HotkeyInput[$iHotKeyBoxOffset_Enum], $GUI_ENABLE)
						GUICtrlSetState($HotkeyInput[$iHotKeyBoxOffset_Enum], $GUI_FOCUS)
						Return $GUI_RUNDEFMSG
					Case "Set"
						GUICtrlSetData($HotkeyInputLock[$iHotKeyBoxOffset_Enum], "Change")
						GUICtrlSetState($HotkeyInput[$iHotKeyBoxOffset_Enum], $GUI_DISABLE)
						GUICtrlSetState($mainguititel_label, $GUI_FOCUS)
						_ReAssignHotkeys($HotkeyInput[$iHotKeyBoxOffset_Enum])
						Return $GUI_RUNDEFMSG
				EndSwitch
				Return $GUI_RUNDEFMSG

			Case $nButton_Apl[$iHotKeyBoxOffset_Enum]
				_ApplySettings($iHotKeyBoxOffset_Enum)
				Return $GUI_RUNDEFMSG

		EndSwitch
	Next

	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_COMMAND

Func _ReAssignHotkeys($nID)
	Local $sDefinedHotkeys = ""
	For $iHotKeyBoxOffset_Enum = 1 To UBound($HotkeyInput) - 1
		If $nID = $HotkeyInput[$iHotKeyBoxOffset_Enum] Then ContinueLoop
		$sDefinedHotkeys &= '0x' & StringRight(Hex(_GUICtrlHKI_GetHotKey($HotkeyInput[$iHotKeyBoxOffset_Enum])), 4) & ", "
	Next
	If StringInStr($sDefinedHotkeys, '0x' & StringRight(Hex(_GUICtrlHKI_GetHotKey($nID)), 4)) Then GUICtrlSetData($nID, "None")
	For $iHotKeyBoxOffset_Enum = 1 To UBound($HotkeyInput) - 1
		_HotKey_Assign('0x' & StringRight(Hex(_GUICtrlHKI_GetHotKey($HotkeyInput[$iHotKeyBoxOffset_Enum])), 4), '_ApplySettingsHK', BitOR($HK_FLAG_DEFAULT, $HK_FLAG_EXTENDEDCALL))
		IniWrite(@ScriptDir & "\HRC.ini", 'Settings', 'HotkeyInput' & $iHotKeyBoxOffset_Enum, '0x' & StringRight(Hex(_GUICtrlHKI_GetHotKey($HotkeyInput[$iHotKeyBoxOffset_Enum])), 4))
	Next
	_HotKey_Assign(0x0652, '_HRC_Recover')
	_HotKey_Assign(0x0752, '_Initial_DEVMODE_HotKey')
EndFunc   ;==>_ReAssignHotkeys

Func _Save_Combo_States()
	For $i = 1 To UBound($nCombo_Res) - 1
		If GUICtrlRead($nCombo_Res[$i]) Then IniWrite(@ScriptDir & "\HRC.ini", 'Settings', 'Res' & $i, GUICtrlRead($nCombo_Res[$i]))
		If GUICtrlRead($nCombo_Col[$i]) Then IniWrite(@ScriptDir & "\HRC.ini", 'Settings', 'Col' & $i, GUICtrlRead($nCombo_Col[$i]))
		If GUICtrlRead($nCombo_Fre[$i]) Then IniWrite(@ScriptDir & "\HRC.ini", 'Settings', 'Fre' & $i, GUICtrlRead($nCombo_Fre[$i]))
	Next
EndFunc   ;==>_Save_Combo_States


; =================================================
; Functions
; =================================================
Func _HRC_Exit()

	AdlibUnRegister("_Reregister_Hotkeys")

	IniWrite(@ScriptDir & "\HRC.ini", 'Settings', 'NumberOfHotKeyBoxes', GUICtrlRead($nCombo_Number))
	IniWrite(@ScriptDir & "\HRC.ini", 'Settings', 'Default_Orientation', GUICtrlRead($nCombo_Orientation))

	_Save_Combo_States()

	_MemVirtualFree($pEnumProc_ArraySortClib_Mem1, 64, $MEM_DECOMMIT) ; release mem reserved for _ArraySortClib()
	_MemVirtualFree($pEnumProc_ArraySortClib_Mem2, 64, $MEM_DECOMMIT) ; release mem reserved for _ArraySortClib()
	_MemVirtualFree($pEnumProc_ArraySortClib_Mem3, 36, $MEM_DECOMMIT) ; release mem reserved for _ArraySortClib()

	_GDIPlus_Shutdown()

	_GUIImageList_Destroy($hIML_Button_Apl)

	DllClose($h_DLL_msvcrt)
	DllClose($h_DLL_Kernel32)
	DllClose($h_DLL_user32)
	DllClose($h_DLL_GDI32)
	DllClose($h_DLL_ComCTL32)
	DllClose($h_DLL_OLE32)
	DllClose($h_DLL_OLEAut32)
	DllClose($h_DLL_Crypt32)
	DllClose($h_DLL_NTDll)

	Exit

EndFunc   ;==>_HRC_Exit


Func _HRC_MinToTray()
	GUISetState(@SW_HIDE, $hGUI_HRC_Main)
EndFunc   ;==>_HRC_MinToTray

Func _HRC_Recover()
	If BitAND(WinGetState($hGUI_HRC_Main, ''), 2) Then
		GUISetState(@SW_HIDE, $hGUI_HRC_Main)
	Else
		GUISetState(@SW_SHOW, $hGUI_HRC_Main)
	EndIf
EndFunc   ;==>_HRC_Recover

Func _ApplySettingsHK($iKey = 0)
	If $i__HotKey_Event Then Return ; last event not finished processing
	For $iHotKeyBoxOffset_Enum = 1 To GUICtrlRead($nCombo_Number)
		If '0x' & StringRight(Hex(_GUICtrlHKI_GetHotKey($HotkeyInput[$iHotKeyBoxOffset_Enum])), 4) = '0x' & Hex($iKey, 4) Then ExitLoop
	Next
	$i__HotKey_Event = $iHotKeyBoxOffset_Enum ; event processed in the Main Loop!
EndFunc   ;==>_ApplySettingsHK

Func _ApplySettings($iSwitch = 0)

	Local $iRes = 0

	If $iSwitch = 10 Then
		$iRes = _Initial_DEVMODE_Reset_To()

	ElseIf $iSwitch > 0 Then

		Local $iWidth = StringLeft(GUICtrlRead($nCombo_Res[$iSwitch]), StringInStr(GUICtrlRead($nCombo_Res[$iSwitch]), " ") - 1)
		Local $iHeight = StringRight(GUICtrlRead($nCombo_Res[$iSwitch]), StringLen(GUICtrlRead($nCombo_Res[$iSwitch])) - StringInStr(GUICtrlRead($nCombo_Res[$iSwitch]), " ", 0, -1))
		Local $iBitsPP = StringLeft(GUICtrlRead($nCombo_Col[$iSwitch]), StringInStr(GUICtrlRead($nCombo_Col[$iSwitch]), " ") - 1)
		Local $iRefreshRate = StringLeft(GUICtrlRead($nCombo_Fre[$iSwitch]), StringInStr(GUICtrlRead($nCombo_Fre[$iSwitch]), " ") - 1)
		$iRes = _ChangeScreenRes($iWidth, $iHeight, $iBitsPP, $iRefreshRate)
		Local $iError = @error
		If $iRes <> 0 Then

			Local Const $DISP_CHANGE_SUCCESSFUL = 0
			Local Const $DISP_CHANGE_FAILED = -1
			Local Const $DISP_CHANGE_BADMODE = -2
			Local Const $DISP_CHANGE_NOTUPDATED = -3
			Local Const $DISP_CHANGE_BADFLAGS = -4
			Local Const $DISP_CHANGE_BADPARAM = -5
			Local Const $DISP_CHANGE_BADDUALVIEW = -6
			Local Const $DISP_CHANGE_RESTART = 1

			Local $sFunctionCall, $sError
			Switch $iRes
				Case 1
					$sFunctionCall = "EnumDisplaySettingsEx"
					Switch $iError
						Case 1
							$sError = "1 - Error calling function"
						Case 2
							$sError = "2 - Function returned 0"
					EndSwitch
				Case Else
					$sFunctionCall = "ChangeDisplaySettingsEx "
					If $iRes = 2 Then
						$sFunctionCall &= "1"
					Else
						$sFunctionCall &= "2"
					EndIf
					Switch $iError
						Case 2
							$sError = "2 - Error calling function"
						Case $DISP_CHANGE_SUCCESSFUL
							$sError = $DISP_CHANGE_SUCCESSFUL & " (DISP_CHANGE_SUCCESSFUL)"
						Case $DISP_CHANGE_FAILED
							$sError = $DISP_CHANGE_FAILED & " (DISP_CHANGE_FAILED)"
						Case $DISP_CHANGE_BADMODE
							$sError = $DISP_CHANGE_BADMODE & " (DISP_CHANGE_BADMODE)"
						Case $DISP_CHANGE_NOTUPDATED
							$sError = $DISP_CHANGE_NOTUPDATED & " (DISP_CHANGE_NOTUPDATED)"
						Case $DISP_CHANGE_BADFLAGS
							$sError = $DISP_CHANGE_BADFLAGS & " (DISP_CHANGE_BADFLAGS)"
						Case $DISP_CHANGE_BADPARAM
							$sError = $DISP_CHANGE_BADPARAM & " (DISP_CHANGE_BADPARAM)"
						Case $DISP_CHANGE_BADDUALVIEW
							$sError = $DISP_CHANGE_BADDUALVIEW & " (DISP_CHANGE_BADDUALVIEW)"
						Case $DISP_CHANGE_RESTART
							$sError = $DISP_CHANGE_RESTART & " (DISP_CHANGE_RESTART)"
					EndSwitch
			EndSwitch

			_MsgBox_English(64 + 262144, "HRC Error", "Unable to change screen resolution" & @CRLF & @CRLF & _
					"Error function call: " & @CRLF & $sFunctionCall & @CRLF & @CRLF & _
					"Error code: " & @CRLF & $sError & @CRLF & @CRLF & _
					"Requested Settings:" & @CRLF & @CRLF & "Width: " & $iWidth & @CRLF & "Height: " & $iHeight & @CRLF & "BitsPP: " & $iBitsPP & @CRLF & "Refresh Rate: " & $iRefreshRate)

		EndIf

	EndIf
	_WinAPI_InvalidateRect($hGUI_HRC_Main)

	If Not $iRes Then Return 1 ; Successful changed res

EndFunc   ;==>_ApplySettings


Func ControlEvents()
	Switch @GUI_CtrlId
		Case $nCombo_Orientation
			IniWrite(@ScriptDir & "\HRC.ini", 'Settings', 'Default_Orientation', GUICtrlRead($nCombo_Orientation))
			Return

		Case $nCombo_Number Or $nButton_Refresh Or $c_checkbox_Rawmode Or $c_checkbox_Rotatedmode ; Or $c_checkbox_Largemode

			IniWrite(@ScriptDir & "\HRC.ini", 'Settings', 'RAWMODE', GUICtrlRead($c_checkbox_Rawmode))
			IniWrite(@ScriptDir & "\HRC.ini", 'Settings', 'ROTATEDMODE', GUICtrlRead($c_checkbox_Rotatedmode))
			;IniWrite(@ScriptDir & "\HRC.ini", 'Settings', 'Largemode', GUICtrlRead($c_checkbox_Largemode))

			If GUICtrlRead($nCombo_Number) <> $nCombo_Number_Save Or @GUI_CtrlId = $nButton_Refresh Or @GUI_CtrlId = $c_checkbox_Rawmode Or @GUI_CtrlId = $c_checkbox_Rotatedmode Then ; Or @GUI_CtrlId = $c_checkbox_Largemode
				If @GUI_CtrlId = $nButton_Refresh Or @GUI_CtrlId = $c_checkbox_Rawmode Or @GUI_CtrlId = $c_checkbox_Rotatedmode Then ; Or @GUI_CtrlId = $c_checkbox_Largemode
					_Enum_Possible_Resolutions()
				EndIf
				GUISetState(@SW_LOCK, $hGUI_HRC_Main)
				Local $hGui_Old = $hGUI_HRC_Main
				For $i = 1 To UBound($nCombo_Res) - 1
					If GUICtrlRead($nCombo_Res[$i]) Then IniWrite(@ScriptDir & "\HRC.ini", 'Settings', 'Res' & $i, GUICtrlRead($nCombo_Res[$i]))
					If GUICtrlRead($nCombo_Col[$i]) Then IniWrite(@ScriptDir & "\HRC.ini", 'Settings', 'Col' & $i, GUICtrlRead($nCombo_Col[$i]))
					If GUICtrlRead($nCombo_Fre[$i]) Then IniWrite(@ScriptDir & "\HRC.ini", 'Settings', 'Fre' & $i, GUICtrlRead($nCombo_Fre[$i]))
				Next
				IniWrite(@ScriptDir & "\HRC.ini", 'Settings', 'NumberOfHotKeyBoxes', GUICtrlRead($nCombo_Number))
				_GUICreate()
				_Save_Combo_States()
				GUIDelete($hGui_Old)
				GUISetState(@SW_SHOW, $hGUI_HRC_Main)
				Return
			EndIf

	EndSwitch

	Local $iSwitch = 0

	For $i = 1 To UBound($nCombo_Res) - 1
		If @GUI_CtrlId = $nCombo_Res[$i] Then
			$iSwitch = $i
			ExitLoop
		EndIf
	Next

	If $iSwitch > 0 Then

		If GUICtrlRead($nCombo_Res[$iSwitch]) <> $nCombo_Res_Save[$iSwitch] Then
			$nCombo_Res_Save[$iSwitch] = GUICtrlRead($nCombo_Res[$iSwitch])

			$sCombo_ColorDepth = ""
			$sCombo_ColorDepth_Default = ""
			For $i = 0 To UBound($aSupportedResolutions) - 1
				If StringInStr($nCombo_Res_Save[$iSwitch], $aSupportedResolutions[$i][0] & " x " & $aSupportedResolutions[$i][1]) And Not StringInStr($sCombo_ColorDepth, $aSupportedResolutions[$i][3]) Then $sCombo_ColorDepth &= "|" & $aSupportedResolutions[$i][3]
				If $aSupportedResolutions[$i][2] = $sCurrent_Setting_ColorDepth Then $sCombo_ColorDepth_Default = $aSupportedResolutions[$i][3]
			Next

			If StringInStr($sCombo_ColorDepth, "|" & GUICtrlRead($nCombo_Col[$iSwitch])) Then
				GUICtrlSetData($nCombo_Col[$iSwitch], $sCombo_ColorDepth, GUICtrlRead($nCombo_Col[$iSwitch]))
			Else
				GUICtrlSetData($nCombo_Col[$iSwitch], $sCombo_ColorDepth, StringMid($sCombo_ColorDepth, 2, StringInStr($sCombo_ColorDepth, "|", 0, 2) - 2))
			EndIf

			$sCombo_MonitorFreq = ""
			For $i = 0 To UBound($aSupportedResolutions) - 1
				If StringInStr($sCombo_ColorDepth, $aSupportedResolutions[$i][3]) Then
					If $nCombo_Res_Save[$iSwitch] = $aSupportedResolutions[$i][0] & " x " & $aSupportedResolutions[$i][1] Then
						If Not StringInStr($sCombo_MonitorFreq, $aSupportedResolutions[$i][4]) Then $sCombo_MonitorFreq &= "|" & $aSupportedResolutions[$i][4] & " Hertz"
					EndIf
				EndIf
			Next

			If StringInStr($sCombo_MonitorFreq, "|" & GUICtrlRead($nCombo_Fre[$iSwitch])) Then
				GUICtrlSetData($nCombo_Fre[$iSwitch], $sCombo_MonitorFreq, GUICtrlRead($nCombo_Fre[$iSwitch]))
			Else
				GUICtrlSetData($nCombo_Fre[$iSwitch], $sCombo_MonitorFreq, StringMid($sCombo_MonitorFreq, 2, StringInStr($sCombo_MonitorFreq, "|", 0, 2) - 2))
			EndIf

			$nCombo_Res[0] = IniRead(@ScriptDir & "\HRC.ini", 'Settings', 'NumberOfHotKeyBoxes', 2) + 1

			_WinAPI_InvalidateRect($hGUI_HRC_Main)

		EndIf
	EndIf

EndFunc   ;==>ControlEvents

Func _ControlEvents_TRAY()
	Local $iSwitch = 0
	For $i = 1 To UBound($a_TrayItem_Activate) - 1
		If @TRAY_ID = $a_TrayItem_Activate[$i] Then
			$iSwitch = $i
			ExitLoop
		EndIf
	Next
	If $iSwitch Then _ApplySettings($iSwitch)
EndFunc   ;==>_ControlEvents_TRAY

Func _HRC_Help()
	Opt('GuiOnEventMode', 0)
	GUISetState(@SW_HIDE, $hGUI_HRC_Main)
	GUISetState(@SW_SHOW, $hGUI_Help)
	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				ExitLoop
			Case $c_Help_Hyperlink_CC
				ShellExecute("http://creativecommons.org/licenses/by-nc-sa/3.0/", "", "", "open")
			Case $c_Help_Hyperlink_Funk
				ShellExecute("http://funk.eu", "", "", "open")
		EndSwitch
	WEnd
	GUISetState(@SW_HIDE, $hGUI_Help)
	Opt('GuiOnEventMode', 1)
	GUISetState(@SW_SHOW, $hGUI_HRC_Main)
EndFunc   ;==>_HRC_Help


Func _GUI_Help_Create()

	$hGUI_Help = GUICreate($mainguititel, 600, 330, Default, Default, $WS_SYSMENU)
	_SetFont_hWnd($i_Font_Adjustment + 8, 400, 0, $s_Global_Font)
	GUISetBkColor(0xEEF1F6)
	WinSetOnTop($hGUI_Help, "", 1)

	$c_Help_Hyperlink_Funk = GUICtrlCreateButton("", 20, 20 + 20, 39, 39, $BS_BITMAP)
	_GUICtrlButton_SetImageList(-1, $hIML_Button_Apl, 4)
	GUICtrlSetCursor(-1, 0)

	GUICtrlCreateLabel($mainguititel, 80 + 10, 10, 380, 20)
	_SetFont_Ctrl(-1, $i_Font_Adjustment + 9, 800, 0, $s_Global_Font)

	GUICtrlCreateLabel('This program is freeware under a Creative Commons License "by-nc-sa 3.0":', 80 + 10, 40 - 10, 380, 20)
	GUICtrlCreateLabel('- Attribution' & @CRLF _
			 & '- Noncommercial' & @CRLF _
			 & '- Share Alike', 80 + 20, 60 - 10, 380, 50)
	_SetFont_Ctrl(-1, $i_Font_Adjustment + 8.5, 800, 0, $s_Global_Font)

	GUICtrlCreateLabel('Visit                                                                               for details.', 80 + 10, 110 - 10, 380, 20)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	$c_Help_Hyperlink_CC = GUICtrlCreateLabel("http://creativecommons.org/licenses/by-nc-sa/3.0/", 80 + 34, 110 - 10, 230, 20)
	GUICtrlSetColor(-1, 0x0000FF)
	GUICtrlSetCursor(-1, 0)

	GUICtrlCreateEdit('I share this program with NO WARRANTIES and NO LIABILITY FOR DAMAGES!' & @CRLF _
			 & @CRLF _
			 & 'The HotKeys "CTRL+ALT+R" and "CTRL+ALT+SHIFT+R" are set automatically. All other HotKeys can be set dynamically.' _
			 & 'HRC is started minimized, add a shortcut to the StartUp Folder to have it at hand with Windows start.' & @CRLF & @CRLF _
			 & 'HRC supports the following commandline parameters:' & @CRLF & @CRLF _
			 & 'r#' & @TAB & @TAB & @TAB & @TAB & 'Change to resolution number #  (r1 - r9)' & @CRLF _
			 & '/exit' & @TAB & @TAB & @TAB & @TAB & 'Exit after change' & @CRLF _
			 & '/hidetrayicon' & @TAB & @TAB & @TAB & 'Hide Tray icon' & @CRLF _
			 & '/cmd_exe "CommandExecute"' & @TAB & 'Execute after successful change' & @CRLF _
			 & '/cmd_param "CommandParameter"' & @TAB & 'Parameter for executable' & @CRLF _
			 & '/cmd_always' & @TAB & @TAB & @TAB & 'Execute /cmd_exe command even if change was not successful' & @CRLF _
			 & '/show' & @TAB & @TAB & @TAB & @TAB & 'Show GUI' & @CRLF & @CRLF _
			 & 'Examples:' & @CRLF & @CRLF _
			 & 'hrc.exe r1' & @CRLF & @CRLF _
			 & 'hrc.exe r2 /exit' & @CRLF & @CRLF _
			 & 'hrc.exe r1 /show' & @CRLF & @CRLF _
			 & 'hrc.exe r1 /cmd_exe "C:\Program Files\Internet Explorer\iexplore.exe" /cmd_param "http://www.yahoo.de"' & @CRLF & @CRLF _
			 & 'hrc.exe r2 /cmd_exe "C:\Program Files\Internet Explorer\iexplore.exe" /cmd_param "http://www.yahoo.de" /cmd_always /exit' & @CRLF & @CRLF _
			 & 'hrc.exe /hidetrayicon' & @CRLF & @CRLF _
			 & 'The /cmd_exe can be used with my program ICU to restore a desktop Icon configuration per resolution, give it a try!' & @CRLF & @CRLF _
			 & 'For commerical usage contact me via my homepage at http://www.funk.eu.' & @CRLF _
			 & '© HRC - HotKey Resolution Changer 2009 - 2012 by Karsten Funk. All rights reserved.' _
			 & '', 10, 140, 575, 140, BitOR($WS_VSCROLL, $ES_READONLY))

EndFunc   ;==>_GUI_Help_Create

;===============================================================================
;
; Function Name:    _ChangeScreenRes()
; Description:      Changes the current screen geometry, colour and refresh rate.
; Version:          2
; Parameter(s):     $i_Width - Width of the desktop screen in pixels. (horizontal resolution)
;                   $i_Height - Height of the desktop screen in pixels. (vertical resolution)
;					$i_BitsPP - Depth of the desktop screen in bits per pixel.
;					$i_RefreshRate - Refresh rate of the desktop screen in hertz.
; Requirement(s):   AutoIt 3.3.6.1
; Return Value(s):  On Success - Screen is adjusted, @ERROR = 0
;                   On Failure - sets @ERROR = 1
; Forum(s):         http://www.autoitscript.com/forum/index.php?showtopic=20121
; Author(s):        Original code - psandu.ro
;                   Modifications - PartyPooper
;
;                   HEAVY Modifications by KaFu
;
;===============================================================================
Func _ChangeScreenRes($i_Width = @DesktopWidth, $i_Height = @DesktopHeight, $i_BitsPP = @DesktopDepth, $i_RefreshRate = @DesktopRefresh)

	Local Const $DM_ORIENTATION = 0x00000001
	Local Const $DM_PAPERSIZE = 0x00000002
	Local Const $DM_PAPERLENGTH = 0x00000004
	Local Const $DM_PAPERWIDTH = 0x00000008
	Local Const $DM_SCALE = 0x00000010
	Local Const $DM_COPIES = 0x00000100
	Local Const $DM_DEFAULTSOURCE = 0x00000200
	Local Const $DM_PRINTQUALITY = 0x00000400
	Local Const $DM_POSITION = 0x00000020
	Local Const $DM_DISPLAYORIENTATION = 0x00000080
	Local Const $DM_DISPLAYFIXEDOUTPUT = 0x20000000
	Local Const $DM_COLOR = 0x00000800
	Local Const $DM_DUPLEX = 0x00001000
	Local Const $DM_YRESOLUTION = 0x00002000
	Local Const $DM_TTOPTION = 0x00004000
	Local Const $DM_COLLATE = 0x00008000
	Local Const $DM_FORMNAME = 0x00010000
	Local Const $DM_LOGPIXELS = 0x00020000
	Local Const $DM_BITSPERPEL = 0x00040000
	Local Const $DM_PELSWIDTH = 0x00080000
	Local Const $DM_PELSHEIGHT = 0x00100000
	Local Const $DM_DISPLAYFLAGS = 0x00200000
	Local Const $DM_NUP = 0x00000040
	Local Const $DM_DISPLAYFREQUENCY = 0x00400000
	Local Const $DM_ICMMETHOD = 0x00800000
	Local Const $DM_ICMINTENT = 0x01000000
	Local Const $DM_MEDIATYPE = 0x02000000
	Local Const $DM_DITHERTYPE = 0x04000000
	Local Const $DM_PANNINGWIDTH = 0x08000000
	Local Const $DM_PANNINGHEIGHT = 0x10000000

	Local Const $DM_DISPLAYQUERYORIENTATION = 0x01000000

	Local Const $CDS_TEST = 0x00000002
	Local Const $CDS_UPDATEREGISTRY = 0x00000001
	Local Const $CDS_RESET = 0x40000000
	Local Const $CDS_SET_PRIMARY = 0x00000010

	Local Const $CDS_VIDEOPARAMETERS = 0x00000020
	Local Const $CDS_ENABLE_UNSAFE_MODES = 0x00000100
	Local Const $CDS_DISABLE_UNSAFE_MODES = 0x00000200

	; error 2 = EnumDisplaySettingsEx for $ENUM_CURRENT_SETTINGS failed
	Local Const $DISP_CHANGE_SUCCESSFUL = 0
	Local Const $DISP_CHANGE_FAILED = -1
	Local Const $DISP_CHANGE_BADMODE = -2
	Local Const $DISP_CHANGE_NOTUPDATED = -3
	Local Const $DISP_CHANGE_BADFLAGS = -4
	Local Const $DISP_CHANGE_BADPARAM = -5
	Local Const $DISP_CHANGE_BADDUALVIEW = -6
	Local Const $DISP_CHANGE_RESTART = 1

	Local Const $HWND_BROADCAST = 0xffff
	Local Const $WM_DISPLAYCHANGE = 0x007E

	If $i_Width = "" Or $i_Width = -1 Then $i_Width = @DesktopWidth ; default to current setting
	If $i_Height = "" Or $i_Height = -1 Then $i_Height = @DesktopHeight ; default to current setting
	If $i_BitsPP = "" Or $i_BitsPP = -1 Then $i_BitsPP = @DesktopDepth ; default to current setting
	If $i_RefreshRate = "" Or $i_RefreshRate = -1 Then $i_RefreshRate = @DesktopRefresh ; default to current setting

	Local $DEVMODE = DllStructCreate($_tag_DEVMODE)
	DllStructSetData($DEVMODE, "dmSize", DllStructGetSize($DEVMODE))

	; Using the dmFields flag of DM_DISPLAYORIENTATION, ChangeDisplaySettingsEx can be used to dynamically rotate the screen orientation. However, the DM_PELSWIDTH and DM_PELSHEIGHT flags cannot be used to change the screen resolution.

	Local $i_DllRet = DllCall($h_DLL_user32, "int", "EnumDisplaySettingsEx", "ptr", 0, "dword", $ENUM_CURRENT_SETTINGS, "ptr", DllStructGetPtr($DEVMODE), "dword", 0)
	If $i_DllRet[0] = 0 Then
		$i_DllRet = DllCall($h_DLL_user32, "int", "EnumDisplaySettingsEx", "ptr", 0, "dword", $ENUM_REGISTRY_SETTINGS, "ptr", DllStructGetPtr($DEVMODE), "dword", 0)
	EndIf

	#cs
		ConsoleWrite("dmDeviceName " & DllStructGetData($DEVMODE, "dmDeviceName") & @CRLF)
		ConsoleWrite("dmSpecVersion " & DllStructGetData($DEVMODE, "dmSpecVersion") & @CRLF)
		ConsoleWrite("dmDriverVersion " & DllStructGetData($DEVMODE, "dmDriverVersion") & @CRLF)
		ConsoleWrite("dmSize " & DllStructGetData($DEVMODE, "dmSize") & @CRLF)
		ConsoleWrite("dmDriverExtra " & DllStructGetData($DEVMODE, "dmDriverExtra") & @CRLF)
		ConsoleWrite("dmFields " & DllStructGetData($DEVMODE, "dmFields") & @CRLF)
		ConsoleWrite("dmPositionx " & DllStructGetData($DEVMODE, "dmPositionx") & @CRLF)
		ConsoleWrite("dmPositiony " & DllStructGetData($DEVMODE, "dmPositiony") & @CRLF)
		ConsoleWrite("- dmDisplayOrientation " & DllStructGetData($DEVMODE, "dmDisplayOrientation") & @CRLF)
		ConsoleWrite("dmDisplayFixedOutput " & DllStructGetData($DEVMODE, "dmDisplayFixedOutput") & @CRLF)
		ConsoleWrite("dmColor " & DllStructGetData($DEVMODE, "dmColor") & @CRLF)
		ConsoleWrite("dmDuplex " & DllStructGetData($DEVMODE, "dmDuplex") & @CRLF)
		ConsoleWrite("dmYResolution " & DllStructGetData($DEVMODE, "dmYResolution") & @CRLF)
		ConsoleWrite("dmTTOption " & DllStructGetData($DEVMODE, "dmTTOption") & @CRLF)
		ConsoleWrite("dmCollate " & DllStructGetData($DEVMODE, "dmCollate") & @CRLF)
		ConsoleWrite("dmFormName " & DllStructGetData($DEVMODE, "dmFormName") & @CRLF)
		ConsoleWrite("dmLogPixels " & DllStructGetData($DEVMODE, "dmLogPixels") & @CRLF)
		ConsoleWrite("dmBitsPerPel " & DllStructGetData($DEVMODE, "dmBitsPerPel") & @CRLF)
		ConsoleWrite("dmPelsWidth " & DllStructGetData($DEVMODE, "dmPelsWidth") & @CRLF)
		ConsoleWrite("dmPelsHeight " & DllStructGetData($DEVMODE, "dmPelsHeight") & @CRLF)
		ConsoleWrite("dmDisplayFlags " & DllStructGetData($DEVMODE, "dmDisplayFlags") & @CRLF)
		ConsoleWrite("dmDisplayFrequency " & DllStructGetData($DEVMODE, "dmDisplayFrequency") & @CRLF & @CRLF)
	#ce

	If @error Then
		$DEVMODE = 0
		SetError(1)
		Return 1
	Else
		$i_DllRet = $i_DllRet[0]
	EndIf

	If $i_DllRet <> 0 Then

		DllStructSetData($DEVMODE, "dmPelsWidth", $i_Width)
		DllStructSetData($DEVMODE, "dmPelsHeight", $i_Height)
		DllStructSetData($DEVMODE, "dmBitsPerPel", $i_BitsPP)
		DllStructSetData($DEVMODE, "dmDisplayFrequency", $i_RefreshRate)

		If $b_Res_Orientation_Rotation_Supported Then
			If $i_Height < $i_Width Then
				If IniRead(@ScriptDir & "\HRC.ini", 'Settings', 'Default_Orientation', "090") = "090" Then
					DllStructSetData($DEVMODE, "dmDisplayOrientation", $DMDO_90)
				Else
					DllStructSetData($DEVMODE, "dmDisplayOrientation", $DMDO_270)
				EndIf
			Else
				DllStructSetData($DEVMODE, "dmFields", BitOR($DM_POSITION, $DM_PELSWIDTH, $DM_PELSHEIGHT, $DM_BITSPERPEL, $DM_DISPLAYFREQUENCY))
			EndIf
		Else
			DllStructSetData($DEVMODE, "dmFields", BitOR($DM_POSITION, $DM_PELSWIDTH, $DM_PELSHEIGHT, $DM_BITSPERPEL, $DM_DISPLAYFREQUENCY))
		EndIf

		$i_DllRet = DllCall($h_DLL_user32, "int", "ChangeDisplaySettingsEx", "ptr", 0, "ptr", DllStructGetPtr($DEVMODE), "hwnd", 0, "int", $CDS_TEST, "ptr", 0)
		If @error Then
			$DEVMODE = 0
			SetError(2)
			Return 2
		Else
			$i_DllRet = $i_DllRet[0]
		EndIf

		Select
			Case $i_DllRet = $DISP_CHANGE_SUCCESSFUL
				$i_DllRet = DllCall($h_DLL_user32, "int", "ChangeDisplaySettingsEx", "ptr", 0, "ptr", DllStructGetPtr($DEVMODE), "hwnd", 0, "int", $CDS_UPDATEREGISTRY, "ptr", 0)
				If @error Then
					$DEVMODE = 0
					SetError(2)
					Return 3
				Else
					$i_DllRet = $i_DllRet[0]
				EndIf

				If $i_DllRet <> $DISP_CHANGE_SUCCESSFUL Then
					$DEVMODE = 0
					SetError($i_DllRet)
					Return 3
				EndIf

				WinMove($hGUI_HRC_Main, "", @DesktopWidth / 2 - (420 / 2), @DesktopHeight / 2 - ((228 + (($iHotKeyBoxOffset - 3) * 80)) / 2))
				_SendMessageTimeout_Ex($HWND_BROADCAST, $WM_DISPLAYCHANGE, $i_BitsPP, $i_Height * 2 ^ 16 + $i_Width)
				Return 0 ; Success !

			Case Else
				$DEVMODE = 0
				SetError($i_DllRet)
				Return 2

		EndSelect
	EndIf
	$DEVMODE = 0
	SetError(2)
	Return 1
EndFunc   ;==>_ChangeScreenRes

Func _SendMessageTimeout_Ex($hWnd, $iMsg, $wParam = 0, $lParam = 0)
	Local $iRet = DllCall($h_DLL_user32, "lresult", "SendMessageTimeout", _
			"hwnd", $hWnd, _
			"uint", $iMsg, _
			"wparam", $wParam, _
			"lParam", $lParam, _
			"uint", $SMTO_ABORTIFHUNG, _
			"uint", $MSG_TIMEOUT, _
			"dword_ptr*", 0)
	Return $iRet[7]
EndFunc   ;==>_SendMessageTimeout_Ex

; http://www.autoitscript.com/forum/index.php?showtopic=63525&view=findpost&p=474072
;===============================================================================
; Function Name:    _ArraySortClib() v4
; Description:         Sort 1D/2D array using qsort() from C runtime library
; Syntax:
; Parameter(s):      $Array - the array to be sorted, ByRef
;                    $iMode - sort mode, can be one of the following:
;                        0 = numerical, using double precision float compare
;                        1 = string sort, case insensitive (default)
;                        2 = string sort, case sensitive
;                        3 = word sort, case insensitive - compatible with AutoIt's native compare
;                    $fDescend - sort direction. True = descending, False = ascending (default)
;                    $iStart - index of starting element (default 0 = $array[0])
;                    $iEnd - index of ending element (default 0 = Ubound($array)-1)
;                    $iColumn - index of column to sort by (default 0 = first column)
;                    $iStrMax - max string length of each array element to compare (default 4095 chars)
; Requirement(s):    msvcrt.dll (shipped with Windows since Win98 at least), 32-bit version of AutoIt
; Return Value(s):    Success = Returns 1
;                    Failure = Returns 0 and sets error:
;                        @error 1 = invalid array
;                        @error 2 = invalid param
;                        @error 3 = dll error
;                        @error 64 = 64-bit AutoIt unsupported
; Author(s):   Siao
; Modification(s): KaFu, added three global _MemVirtualAlloc() calls to top of script to prevent DEP Errors:
;
; Global $pEnumProc_ArraySortClib_Mem1 = _MemVirtualAlloc(0, 64, $MEM_COMMIT, $PAGE_EXECUTE_READWRITE) ; needed for _ArraySortClib()
; Global $pEnumProc_ArraySortClib_Mem2 = _MemVirtualAlloc(0, 64, $MEM_COMMIT, $PAGE_EXECUTE_READWRITE) ; needed for _ArraySortClib()
; Global $pEnumProc_ArraySortClib_Mem3 = _MemVirtualAlloc(0, 36, $MEM_COMMIT, $PAGE_EXECUTE_READWRITE) ; needed for _ArraySortClib()
;
;===============================================================================

Func _ArraySortClib(ByRef $array, $iMode = 1, $fDescend = False, $iStart = 0, $iEnd = 0, $iColumn = 0, $iStrMax = 4095)
	If @AutoItX64 Then Return SetError(64, 0, 0)
	Local $iArrayDims = UBound($array, 0)
	If @error Or $iArrayDims > 2 Then Return SetError(1, 0, 0)
	Local $iArraySize = UBound($array, 1), $iColumnMax = UBound($array, 2)
	If $iArraySize < 2 Then Return SetError(1, 0, 0)
	If $iEnd < 1 Or $iEnd > $iArraySize - 1 Then $iEnd = $iArraySize - 1
	If ($iEnd - $iStart < 2) Then Return SetError(2, 0, 0)
	If $iArrayDims = 2 And ($iColumnMax - $iColumn < 0) Then Return SetError(2, 0, 0)
	If $iStrMax < 1 Then Return SetError(2, 0, 0)
	Local $i, $j, $iCount = $iEnd - $iStart + 1, $fNumeric, $aRet, $sZero = ChrW(0), $sStrCmp, $sBufType = 'byte[', $tSource, $tIndex, $tFloatCmp

	Local $tEnumProc = DllStructCreate('byte[64]', $pEnumProc_ArraySortClib_Mem1)
	Local $tCmpWrap = DllStructCreate('byte[64]', $pEnumProc_ArraySortClib_Mem2)

	If $h_DLL_msvcrt = -1 Then Return SetError(3, 0, 0)

	;; initialize compare proc
	Switch $iMode
		Case 0
			$fNumeric = True
			$tFloatCmp = DllStructCreate('byte[36]', $pEnumProc_ArraySortClib_Mem3)
			DllStructSetData($tFloatCmp, 1, '0x8B4C24048B542408DD01DC1ADFE0F6C440750D80E441740433C048C333C040C333C0C3')
			DllStructSetData($tCmpWrap, 1, '0xBA' & Hex(Binary(DllStructGetPtr($tFloatCmp)), 8) & '8B4424088B4C2404FF30FF31FFD283C408C3')
			DllStructSetData($tEnumProc, 1, '0x8B7424048B7C24088B4C240C8B442410893789470483C60883C708404975F1C21000')
		Case 1, 2
			$sStrCmp = "_strcmpi" ;case insensitive
			If $iMode = 2 Then $sStrCmp = "strcmp" ;case sensitive
			$aRet = DllCall($h_DLL_Kernel32, 'ptr', 'GetModuleHandle', 'str', 'msvcrt.dll')
			$aRet = DllCall($h_DLL_Kernel32, 'ptr', 'GetProcAddress', 'ptr', $aRet[0], 'str', $sStrCmp)
			;If $aRet[0] = 0 Then Return SetError(3, 0, 0 * DllClose($h_DLL_msvcrt))
			If $aRet[0] = 0 Then Return SetError(3, 0, 1)
			DllStructSetData($tCmpWrap, 1, '0xBA' & Hex(Binary($aRet[0]), 8) & '8B4424088B4C2404FF30FF31FFD283C408C3')
			DllStructSetData($tEnumProc, 1, '0x8B7424048B7C24088B4C240C8B542410893789570483C7088A064684C075F9424975EDC21000')
		Case 3
			$sBufType = 'wchar['
			$aRet = DllCall($h_DLL_Kernel32, 'ptr', 'GetModuleHandle', 'str', 'kernel32.dll')
			$aRet = DllCall($h_DLL_Kernel32, 'ptr', 'GetProcAddress', 'ptr', $aRet[0], 'str', 'CompareStringW')
			;If $aRet[0] = 0 Then Return SetError(3, 0, 0 * DllClose($h_DLL_msvcrt))
			If $aRet[0] = 0 Then Return SetError(3, 0, 1)
			DllStructSetData($tCmpWrap, 1, '0xBA' & Hex(Binary($aRet[0]), 8) & '8B4424088B4C24046AFFFF306AFFFF3168000000006800040000FFD283E802C3')
			DllStructSetData($tEnumProc, 1, '0x8B7424048B7C24088B4C240C8B542410893789570483C7080FB70683C60285C075F6424975EAC21000')
		Case Else

			Return SetError(2, 0, 0)
	EndSwitch
	;; write data to memory
	If $fNumeric Then
		$tSource = DllStructCreate('double[' & $iCount & ']')
		If $iArrayDims = 1 Then
			For $i = 1 To $iCount
				DllStructSetData($tSource, 1, $array[$iStart + $i - 1], $i)
			Next
		Else
			For $i = 1 To $iCount
				DllStructSetData($tSource, 1, $array[$iStart + $i - 1][$iColumn], $i)
			Next
		EndIf
	Else
		Local $sMem = ""
		If $iArrayDims = 1 Then
			For $i = $iStart To $iEnd
				$sMem &= StringLeft($array[$i], $iStrMax) & $sZero
			Next
		Else
			For $i = $iStart To $iEnd
				$sMem &= StringLeft($array[$i][$iColumn], $iStrMax) & $sZero
			Next
		EndIf
		$tSource = DllStructCreate($sBufType & StringLen($sMem) + 1 & ']')
		DllStructSetData($tSource, 1, $sMem)
		$sMem = ""
	EndIf
	;; index data
	$tIndex = DllStructCreate('int[' & $iCount * 2 & ']')
	DllCall($h_DLL_user32, 'uint', 'CallWindowProc', 'ptr', DllStructGetPtr($tEnumProc), 'ptr', DllStructGetPtr($tSource), 'ptr', DllStructGetPtr($tIndex), 'int', $iCount, 'int', $iStart)
	;; sort
	DllCall($h_DLL_msvcrt, 'none:cdecl', 'qsort', 'ptr', DllStructGetPtr($tIndex), 'int', $iCount, 'int', 8, 'ptr', DllStructGetPtr($tCmpWrap))
	;DllClose($h_DLL_msvcrt)
	;; rearrange the array by sorted index
	Local $aTmp = $array, $iRef
	If $iArrayDims = 1 Then ; 1D
		If $fDescend Then
			For $i = 0 To $iCount - 1
				$iRef = DllStructGetData($tIndex, 1, $i * 2 + 2)
				$array[$iEnd - $i] = $aTmp[$iRef]
			Next
		Else ; ascending
			For $i = $iStart To $iEnd
				$iRef = DllStructGetData($tIndex, 1, ($i - $iStart) * 2 + 2)
				$array[$i] = $aTmp[$iRef]
			Next
		EndIf
	Else ; 2D
		If $fDescend Then
			For $i = 0 To $iCount - 1
				$iRef = DllStructGetData($tIndex, 1, $i * 2 + 2)
				For $j = 0 To $iColumnMax - 1
					$array[$iEnd - $i][$j] = $aTmp[$iRef][$j]
				Next
			Next
		Else ; ascending
			For $i = $iStart To $iEnd
				$iRef = DllStructGetData($tIndex, 1, ($i - $iStart) * 2 + 2)
				For $j = 0 To $iColumnMax - 1
					$array[$i][$j] = $aTmp[$iRef][$j]
				Next
			Next
		EndIf
	EndIf
	Return 1
EndFunc   ;==>_ArraySortClib

Func _EnforceSingleInstance($GUID_Program)
	If $GUID_Program = "" Then Return SetError(1, '', 1)

	Local $hWnd = WinGetHandle($GUID_Program)

	If IsHWnd($hWnd) Then

		Local $hwnd_Target = HWnd(ControlGetText($hWnd, '', ControlGetHandle($hWnd, '', 'Edit1')))

		WM_COPYDATA_SendData($hwnd_Target, "/exit")

		If Not WinWaitClose($hwnd_Target, "", 5) Then

			$CmdLine_b_Exit_After_Execution = True
			Return WinGetHandle(AutoItWinGetTitle())

		EndIf

	EndIf

	AutoItWinSetTitle($GUID_Program)
	Return WinGetHandle($GUID_Program)

EndFunc   ;==>_EnforceSingleInstance


; Based on File to Base64 String Code Generator
; by UEZ
; http://www.autoitscript.com/forum/topic/134350-file-to-base64-string-code-generator-v103-build-2011-11-21/

;======================================================================================
; Function Name:        Load_BMP_From_Mem
; Description:          Loads an image which is saved as a binary string and converts it to a bitmap or hbitmap
;
; Parameters:           $bImage:    the binary string which contains any valid image which is supported by GDI+
; Optional:             $hHBITMAP:  if false a bitmap will be created, if true a hbitmap will be created
;
; Remark:               hbitmap format is used generally for GUI internal images, $bitmap is more a GDI+ image format
;                       Don't forget _GDIPlus_Startup() and _GDIPlus_Shutdown()
;
; Requirement(s):       GDIPlus.au3, Memory.au3 and _GDIPlus_BitmapCreateDIBFromBitmap() from WinAPIEx.au3
; Return Value(s):      Success: handle to bitmap (GDI+ bitmap format) or hbitmap (WinAPI bitmap format),
;                       Error: 0
; Error codes:          1: $bImage is not a binary string
;                       2: unable to create stream on HGlobal
;                       3: unable to create bitmap from stream
;
; Author(s):            UEZ
; Additional Code:      thanks to progandy for the MemGlobalAlloc and tVARIANT lines and
;                       Yashied for _GDIPlus_BitmapCreateDIBFromBitmap() from WinAPIEx.au3
; Version:              v0.97 Build 2012-01-04 Beta
;=======================================================================================
Func _Load_BMP_From_Mem($bImage, $hHBITMAP = False)
	If Not IsBinary($bImage) Then Return SetError(1, 0, 0)
	Local $aResult
	Local Const $memBitmap = Binary($bImage) ;load image  saved in variable (memory) and convert it to binary
	Local Const $len = BinaryLen($memBitmap) ;get length of image
	Local Const $hData = _MemGlobalAlloc($len, $GMEM_MOVEABLE) ;allocates movable memory  ($GMEM_MOVEABLE = 0x0002)
	Local Const $pData = _MemGlobalLock($hData) ;translate the handle into a pointer
	Local $tMem = DllStructCreate("byte[" & $len & "]", $pData) ;create struct
	DllStructSetData($tMem, 1, $memBitmap) ;fill struct with image data
	_MemGlobalUnlock($hData) ;decrements the lock count  associated with a memory object that was allocated with GMEM_MOVEABLE
	$aResult = DllCall("ole32.dll", "int", "CreateStreamOnHGlobal", "handle", $pData, "int", True, "ptr*", 0) ;Creates a stream object that uses an HGLOBAL memory handle to store the stream contents
	If @error Then SetError(2, 0, 0)
	Local Const $hStream = $aResult[3]
	$aResult = DllCall($ghGDIPDll, "uint", "GdipCreateBitmapFromStream", "ptr", $hStream, "int*", 0) ;Creates a Bitmap object based on an IStream COM interface
	If @error Then SetError(3, 0, 0)
	Local Const $hBitmap = $aResult[2]
	Local $tVARIANT = DllStructCreate("word vt;word r1;word r2;word r3;ptr data; ptr")
	DllCall("oleaut32.dll", "long", "DispCallFunc", "ptr", $hStream, "dword", 8 + 8 * @AutoItX64, _
			"dword", 4, "dword", 23, "dword", 0, "ptr", 0, "ptr", 0, "ptr", DllStructGetPtr($tVARIANT)) ;release memory from $hStream to avoid memory leak
	$tMem = 0
	$tVARIANT = 0
	If $hHBITMAP Then
		Local Const $hHBmp = _GDIPlus_BitmapCreateDIBFromBitmap($hBitmap)
		_GDIPlus_BitmapDispose($hBitmap)
		Return $hHBmp
	EndIf
	Return $hBitmap
EndFunc   ;==>_Load_BMP_From_Mem

Func _GDIPlus_BitmapCreateDIBFromBitmap($hBitmap)
	Local $tBIHDR, $Ret, $tData, $pBits, $hResult = 0
	$Ret = DllCall($ghGDIPDll, 'uint', 'GdipGetImageDimension', 'ptr', $hBitmap, 'float*', 0, 'float*', 0)
	If (@error) Or ($Ret[0]) Then Return 0
	$tData = _GDIPlus_BitmapLockBits($hBitmap, 0, 0, $Ret[2], $Ret[3], $GDIP_ILMREAD, $GDIP_PXF32ARGB)
	$pBits = DllStructGetData($tData, 'Scan0')
	If Not $pBits Then Return 0
	$tBIHDR = DllStructCreate('dword;long;long;ushort;ushort;dword;dword;long;long;dword;dword')
	DllStructSetData($tBIHDR, 1, DllStructGetSize($tBIHDR))
	DllStructSetData($tBIHDR, 2, $Ret[2])
	DllStructSetData($tBIHDR, 3, $Ret[3])
	DllStructSetData($tBIHDR, 4, 1)
	DllStructSetData($tBIHDR, 5, 32)
	DllStructSetData($tBIHDR, 6, 0)
	$hResult = DllCall('gdi32.dll', 'ptr', 'CreateDIBSection', 'hwnd', 0, 'ptr', DllStructGetPtr($tBIHDR), 'uint', 0, 'ptr*', 0, 'ptr', 0, 'dword', 0)
	If (Not @error) And ($hResult[0]) Then
		DllCall('gdi32.dll', 'dword', 'SetBitmapBits', 'ptr', $hResult[0], 'dword', $Ret[2] * $Ret[3] * 4, 'ptr', DllStructGetData($tData, 'Scan0'))
		$hResult = $hResult[0]
	Else
		$hResult = 0
	EndIf
	_GDIPlus_BitmapUnlockBits($hBitmap, $tData)
	Return $hResult
EndFunc   ;==>_GDIPlus_BitmapCreateDIBFromBitmap

Func _Decompress_Binary_String_to_Bitmap($Base64String)
	$Base64String = Binary($Base64String)
	Local $iSize_Source = BinaryLen($Base64String)
	Local $pBuffer_Source = _WinAPI_CreateBuffer($iSize_Source)
	DllStructSetData(DllStructCreate('byte[' & $iSize_Source & ']', $pBuffer_Source), 1, $Base64String)
	Local $pBuffer_Decompress = _WinAPI_CreateBuffer(8388608)
	Local $Size_Decompressed = _WinAPI_DecompressBuffer($pBuffer_Decompress, 8388608, $pBuffer_Source, $iSize_Source)
	Local $b_Result = Binary(DllStructGetData(DllStructCreate('byte[' & $Size_Decompressed & ']', $pBuffer_Decompress), 1))
	_WinAPI_FreeMemory($pBuffer_Source)
	_WinAPI_FreeMemory($pBuffer_Decompress)
	Return $b_Result
EndFunc   ;==>_Decompress_Binary_String_to_Bitmap

Func _Base64String_Icon_Close()
	Local $Base64String
	$Base64String &= 'R7JIAAABABAQEAFwIAAAaAQAABYAAHwAKAAYAJAAiAO4AQBAgwBsHAAGb29vlgAGGv8UBpYBRhR2A3FxAHGWmZmZ/8zMHswSAwEbASMRQ3R0dACWmpqa/7e6zAD/JT7A/xEtwYcKAwETARubm5v/ASuFADIJBTt3d3eWgQsAub3O/ylDw/84FTPEkgGBDYERnp4Mnv+BGYEhe3t7lgCfn5//vMDR/wAtScf/XnXZ/+MBAIEDGTnIggGJCYERIYEVoqKi/4Edf38Af//V1dX/MVBgzP8dQM2CEwUAYRx63IIBCQCBETdUzAOCGYEdg4OD/9fXINf/IkjRggFESH63ihcJAIENhROBGYEdhwCHh//b29v/J/xR1sYA0RDBBMkIwQzBDgCLi4v/3d3d/4grWdzGAGuL584PD8EEyQjBDMEOj4+P/0Dg4OD/MGHDAG98kenWL8EGxQnBDMEOkwCTk/zi4uL/T8B74/80aOXOLM0yI8EIwQrj4+PBDv+WAJaWk7S0tP/VwNrl/1F/58YLwQEYOG7pwgDJBFOA5+D/1tvm/8EMwA7BgAIAwKWTt7e3/9cA3Of/VYXq/xXAGqX/PHTsygDBBABXhur/2N3o/w/BCsAMwg4FAJycnJMAuLi4/9ne6v+AV4nt/z5478oAAFmK7f/a3+r/8Lm5uf/ACsoOBQDAoQCTurq6/+rq6hD/6+vrzgC8vLwO/8AI0g4FAKGhoZM1YAD8YAD/cABuB/APAAAA4AcAAMAD8AAAgAH+g2IEYQVhBgFhBw=='
	$Base64String = _Base64Decode($Base64String)
	Return _Decompress_Binary_String_to_Bitmap($Base64String)
EndFunc   ;==>_Base64String_Icon_Close

Func _Base64String_Icon_Minimize()
	Local $Base64String
	$Base64String &= 'XrJIAAABABAQEAFwIAAAaAQAABYAAHwAKAAYAJAAiAO4AQBAAwBsNQAweTXJK3EEMMQxdj2LRNFVAJ5c/1CYVv8sCHQyzwkbqXFRqQDDjmj/wItm/wC+iGT/u4Vh/wC5g1//tH5c/wCwfVr/WZlU/wBjrGv/iMmQ/wCCxor/UppY/wBAdTf/pHFQqyEBP8iSbP8VAITFAIv/V6th/2q0AHP/kM6X/4rLAJH/arBw/zuEQEL/Unc9/4EfyhSUbogY/oAB/f/+Cv6BAfyGAVSrXv8AltKf/5HPmf8AU59b/9Tm1v+IqnNTgh/Ml2+EHQb8hB2FG/v//f36AYIBW7Rl/53WpgD/mdOi/0ueUxGCFqx1VIIf0ZxzM4M8iDf9/YEdhR/4/wBgvGz/XLZn/4BXsGH/UqhcgheIsHpYgh/UnnXGDwPDDMUB+f/8/Pj/CPv598AA9f/7+AD0//v38v/79SLywguyfFrCD9WgtnbCA8cN+sANwA77yQ0C88IN+vPv//jyGuzCC7XAZ8EP2KJ5B8QPwQ3AAPv5//v6FvbADcAO98AO9vH/APj07v/38uv/gPfw6v/27OjCC8i3gV7CD9mjww/BDSz8+8QrwA36wCr59QDw//fz7f/27wDq//Xr5//z6iDk//Ln3sILuoViYMIP26R61n8ZAL2Eh2PCD9yne//xAAPBq8EP3ayF/ei5hJL/7QDBkG/9xL8ga92xjfTCFaZ6PP/awDPBVMFlwXbSnQBz/8+acv/OmQBw/8uWb//JlMBs/8SaevTBDXfz5QcA/6Bx/4eChH8AbAAC/yAg'
	$Base64String = _Base64Decode($Base64String)
	Return _Decompress_Binary_String_to_Bitmap($Base64String)
EndFunc   ;==>_Base64String_Icon_Minimize

Func _Base64String_Icon_Help()
	Local $Base64String
	$Base64String &= 'N7NIAAABABAQEAFwIAAAaAQAABYAAHwAKAAYAJAAiAO4AQBAAwBsXQCtdEQjrHIAQX2qcD/bqG0APPOnazrzpWkAN9ukaDV9o2YEMyMZO7V+UVOzAHxO5te7o//pQNrK/+zg0QID6ADYyP/TtZz/p4BsOuamajhTETsAvYlfU7uHW/QA59XE/+XSv/8AyaaF/7iOZ/8Atopl/8WhgP8A4My6/+PQvv+Aq3BA9KluPYohAMaVbSLDkmrlAOrYyf/jzbr/AMCUa/+6jGL/CM+wlIIBt4lf/wCyh2H/2sCq/wDk0cD/rnVG5RCtc0MihR/MnngAfuTMuf/q1sUA/8eZcf+/kGYBggH38ez/9vDqA4IfgQG1iWP/4s4Au//Zvab/snsETX6FH9OnhNvvAOHT/9m1lf/HAJhs/8OVaf/BBJNnhiO7i2P/uQCKY/+4imL/ywCnhv/q3Mz/uAiDV9uFH9mwj/YA8uTZ/9Glev8AxZlr/8SXav8AxJZp//r28v8A8+rh/8KVbf+Ivo9lwABk/8DAAgDv49X/v4xh9gHFD+C5mfby5doA/9Gmfv/MnXEA/8eabP/FmGsA/+LMtv/48+4Q//bu6MAsof/CAJRo/8Wbcf/wQOLW/8WVbMYP5gDBo9vz5dn/3wC7nv/PoHX/zQCecv/16+P/5ADLtP/n07//+1D49v/lwAHEwBTWgLSR/+7g0v/ATAHGL+vJrX7049QA/+/czf/VqH4Q/9Cgd8AM9f/8A8QAwQLRqIH/z6QAe//q1cP/6tQgwv/Sp4PGT/HQALUi786z5fbpAN3/7NjG/9esAIH/3Lua//bsAOP/9ezi/+TIAq7AC3v/5s66/wDx4tX/27OR5RjZsI7GbwEA9NS7AFPy0rj09+rfAP/u3tD/48GnEP/YronAEob/3QC7nP/r1sf/8wDm2f/jvp/04QS7nNKg9ti/U/UA1r3m+enc//Yw6N3/88BUwQD15wDc//Xk1v/ryGCs5unGqdIOBQD5ANvEI/jawn33ANjA2/bXvvP0ANW88/PTudvxwNG3ffDPtNrPHwCBDwD//wAA8A9gQAAHAADAAwAAgD4BewBhBGEFYQZhBw=='
	$Base64String = _Base64Decode($Base64String)
	Return _Decompress_Binary_String_to_Bitmap($Base64String)
EndFunc   ;==>_Base64String_Icon_Help

Func _Base64String_BMP_Display()
	Local $Base64String
	$Base64String &= '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'
	$Base64String &= 'JsWxAJXa1uHVwp66AJApuI4vtIguAKh3J5xqI5NgAB+OWh6FUht/AE8bdkUYdUIWAHA8FHRBGHY/AhgQB285Fmk0FABlMhNoNBRqMkAOcGNb1td/B+4MWCl7B/FZ2nxwYgCuhSuxmnS2rQCqtZ5wtY4tuQCRNb2WOLyRNwC1iTOxgzGtfgAxonMsmWkpjABbJIFOHXhFGEB+SRiGThtwLn4QSBp7Q7E8dT4YAGoxDnBiWtfXEtl/B0gbfGHO1tcA2XpuYaiANLEAijiuhzWpfywAqYEusIgxu5UAOcKcQL6WPrgAjDutfDSebi4AkmEoilomi1sAJ4pXJYFKHXkAQhZ5Qhd7QxkAeT8Zcz0XbjcgFWQtDG9wB9jaA38H/B3Ozc3V1dgAe29jvpxPqY8AYI5zSqmNXLkAlUa6kkO+lkgAu5JGtYpBp3cANZpoLYpaJ4gAWCeHWCmJWSoAjFoulmQzkFsALoVMH4BGGH4ARxp+Rht9RBsAdTkQcWNb2NkRfwfuzb56B83NzBDU1NZ6cAeeVt8A1tHf3Obg1sgAxaNWwZxSvpUATrGGQ6Z3OacAdjunej+kdD4AqXlDqX1Eq4AAR66CSbGDTLIAgU6vf0mibjoAjVIhgkgZf0gIG3c9cAda2NnbiX8HgEp6B8zMzOBUAHtwZMapX9rNAL7g2N/e0LrLAKxgyqpjxqRhAL6YV7ePULSNAE+0jVK1jFO1AItUto1WtYxWALOIVbKGVLCEAFOwgVOzg1arAHpNkFotf0UZOHU6DfAOADJ/B3NqAXsHy8rS0tR5bgBjxKdhy7N5zwC5gtG6fc6zbwDLr27DpWa5mQBcs45TrYRMqwCASqyCTK6ETwCvhFCuhFGthABSroRUrIJTqwCAU6yBU7CEWACugVehcUh8Q3AXbmBYgHV/B/wdygDJydHR0nxzbQB7cGV9cmd+c1EhAH90aSUAaiEAc7hpf3OCAOQALwBrIwCAem5mfnVv2v8OBQAdzn2dzs3O19ZG11BLIwDc3N6Qcd0hIJXe4N/gYIzk4wDk5eTl5+bn6QDn6Oro6uzq6wDt6+3u7e/w7wDw8vDy8/Hz9UDz9fb09viwAOhg6eve3t+Ak38HyQbJ/Q4wAsbFxcjHUscjAMnIIADIIQDJjyAABwCQAiMAy8rKJgAIzMvLIQApsADMy83MzMzLy5DKycnIAADHxwAwiPbx7gkQ8e7/DEQfYwj/d/87vwDaHQ=='
	$Base64String = _Base64Decode($Base64String)
	Return _Decompress_Binary_String_to_Bitmap($Base64String)
EndFunc   ;==>_Base64String_BMP_Display

Func _BinaryString_Picture_License()
	Local $Base64String
	$Base64String &= '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'
	$Base64String &= '8V/Gq1pR/wCpemu/+UAkQ01o64+C+VJ8w93dhPjs1Prom+zHdmImMv479NnkMo/LzsVJgJ85bLQZ2Bk+GP3dpAey7YH4MZMTQxTHRUlZnrHRaaCa7kOyHtWY5V7jJWpA40SuAdRWZLFuVCZVa9ejUcK2YmWxEeuXWygGBaIhYJ8jkixddfqADpBLr9sq2QkP1L01l/kAjxVhklGlBfFneYcnpYvyhZMAuGfs8GtimIT7f7kdkIgg0IyV0gF+NP5xCwIPrrS7q0AmB8MX6kWi8kDitl7GQdqkcr/MPWdQcknGkwuSROzU6wEVu2UcmBLNhXlwk01TDksUOgJkPj4IvowWAP8AXBdVdq+WtFtzPSaoDQ/5AvsrR9eq1b9EvzswO7AUdsMgVxBQWZnUOWS/0vmsBmjOOTkyw9GYeKh/sJLZkP8AU9dfMB//2Q=='
	Return Binary(_Base64Decode($Base64String))
EndFunc   ;==>_BinaryString_Picture_License

Func _BinaryString_Picture_Donate()
	Local $Base64String
	$Base64String &= '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'
	$Base64String &= 'BiQ59DpqaiDMpwyyGil/y8jUtzKbs/XrPX6NlzA0Fq9foqA7EYddkKhhvXqW68nIhK5YUDZtCRlS7vKubCww2f7X/TgI1DZypAvt745Zrq74ep06A04y+0pt1F1bySLEccF+jURppamw3nU66shA/CMyjYfkMcs11d8cs11d8cs11d8cs11d8cs11d8cs11d8cs11d8cs11d8Ba0JFk2ATj/xAAhEAEBAAIBBAMBAQAAAAAAAAABEQAhMUFRwfAQYYEwof/aAAgBAQABPyEjt9Sm/s/3N+Tk+N6dyqu8mReAF6bkuL1MpnVzvVlo7AqyBemOUCl5I/rA1zcI+CNmEtSUVQ1UcJJoLXlVWoB1XFfjR6R6E0baz3zxnvnjPfPGe+eMZyioRfoyh7AlLRBxx0Y9fYp5BYPjlNbM3zC89jUAzgcl1jFNRJVIbnTaCMoSXOMHNplE/ebvkZqiniGi6pQMOwXSyBsltvCZrjmxfqQOYTU5cYHHXXboKYjzWwqMDtY+1CcxjDHwUapL28PdaZMZtBUj17bWB0rfAr2lMK3QJ0+BKVrGNKgsovGWlRShRN77Bo7H8SSSSSSSSeQQ0SVeq98//9oADAMBAAIAAwAAABDAku1tuYBXOASefb//AP8A/wD/xAAgEQEAAgMAAwADAQAAAAAAAAABABEhMWFBUXEggZHw/9oACAEDAQE/EGaGz+EoW4bwH5dpAusuwJ3zn7UA+J7ZrEQo1yxVPj7v5UQk7q2U5HNV8jtsKNsr8FeJZQMC8efM4E4E4E4EI0eIgKKKGhaLLwZ1DgZkDAivLnOaxCzhob76iivWv5Eprxv0m2u9VXuz3AL4FFaV0XWcueREhdpuA4aY158foJSxO4Ha0owa/LR8gwUTgRkERKf9cXDHW1x6ys4E4E4E4E4E4E4E4EQtn//EACARAQACAwADAQADAAAAAAAAAAEAESExYUFRcYEgkaH/2gAIAQIBAT8QPi4D+2pbmlshfyj3f7F2yqlDzxRfpZ7Caye28cr7BwNXQHLTqvtwltur1YaTA39xAAVmmGvNvO9NagBpyaz4vH+Tozozozoxjb5gKuCEWhdEMqG0fyFpfDtZXwYaKvMpBd/BcG2/eVmbKuz7Ji/6v0D6j2ZQEWDbV4wYfcKUmEFZGGxm8efcGwjSTZgBvCmefy2fYsts6MvwiWONn5AyUu9Bn3gLZ0Z0Z0Z0Z0Z0Z0Z0YBRP/8QAHxABAQEBAAEEAwAAAAAAAAAAAREAIUEQMVFhIDCB/9oACAEBAAE/EA7IDlu0yqo+V+Tmt+pO4G+dFuUcCWCR+2mANAWCYKrl4BIJSsFTgNojpCgkkEl9M/VLL492YIQQnADPN1OCQCmEfnpz/mV+Bz8a1atWW6/IRWA7A79ZqmiliF92jvmTJYuvyADJaRCNKNQSxgjJSMKADB6m3aWsmWIMbGxEELhbhBEuNQ5gAwW0qo35faywmYAHZlpg/JwoBjx9RwQCmMeLBHdYu/DRlHPCo+zcdS3zApEBFyyKnpPfN/JUlwjiSD7mGoKUCQYWJYHsHpILSTWoQ4JUJaI9y6S1Rh6CGiKI8P0SSSSSSSSTAMD5k7LX53//2Q=='
	Return Binary(_Base64Decode($Base64String))
EndFunc   ;==>_BinaryString_Picture_Donate

Func _Base64Decode($input_string)
	Local $struct = DllStructCreate("int")
	Local $a_Call = DllCall("Crypt32.dll", "int", "CryptStringToBinary", "str", $input_string, "int", 0, "int", 1, "ptr", 0, "ptr", DllStructGetPtr($struct, 1), "ptr", 0, "ptr", 0)
	If @error Or Not $a_Call[0] Then Return SetError(1, 0, "")
	Local $a = DllStructCreate("byte[" & DllStructGetData($struct, 1) & "]")
	$a_Call = DllCall("Crypt32.dll", "int", "CryptStringToBinary", "str", $input_string, "int", 0, "int", 1, "ptr", DllStructGetPtr($a), "ptr", DllStructGetPtr($struct, 1), "ptr", 0, "ptr", 0)
	If @error Or Not $a_Call[0] Then Return SetError(2, 0, "")
	Return DllStructGetData($a, 1)
EndFunc   ;==>_Base64Decode




Func _SetFont_Ctrl($icontrolID = -1, $iSize = 8.5, $iweight = 400, $iattribute = 0, $sfontname = Default, $iquality = 2)
	If IsKeyword($sfontname) Then
		Local $a_SetFont_GetDefault = _SetFont_GetDefault()
		$sfontname = $a_SetFont_GetDefault[3]
	EndIf
	If Not IsDeclared("__i_SetFont_DPI_Ratio") Then
		Global $__i_SetFont_DPI_Ratio = _SetFont_GetDPI()
		$__i_SetFont_DPI_Ratio = $__i_SetFont_DPI_Ratio[2]
	EndIf
	GUICtrlSetFont($icontrolID, $iSize / $__i_SetFont_DPI_Ratio, $iweight, $iattribute, $sfontname, $iquality)
EndFunc   ;==>_SetFont_Ctrl

Func _SetFont_hWnd($iSize = 8.5, $iweight = 400, $iattribute = 0, $sfontname = Default, $hWnd = Default, $iquality = 2)
	If Not IsHWnd($hWnd) Then $hWnd = GUISwitch(0)
	If IsKeyword($sfontname) Then
		Local $a_SetFont_GetDefault = _SetFont_GetDefault()
		$sfontname = $a_SetFont_GetDefault[3]
	EndIf
	If Not IsDeclared("__i_SetFont_DPI_Ratio") Then
		Global $__i_SetFont_DPI_Ratio = _SetFont_GetDPI()
		$__i_SetFont_DPI_Ratio = $__i_SetFont_DPI_Ratio[2]
	EndIf
	GUISetFont($iSize / $__i_SetFont_DPI_Ratio, $iweight, $iattribute, $sfontname, $hWnd, $iquality)
EndFunc   ;==>_SetFont_hWnd

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: _SetFont_GetDefault
; Description ...: Determines Windows default MsgBox font size and name
; Syntax.........: _SetFont_GetDefault()
; Return values .: Success - Array holding determined font data
;                : Failure - Array holding default values
;                  Array elements - [0] = Size, [1] = Weight, [2] = Style, [3] = Name, [4] = Quality
; Author ........: KaFu
; ===============================================================================================================================
Func _SetFont_GetDefault()

	; Fill array with standard default data
	Local $aDefFontData[5] = [8.5, 400, 0, "Tahoma", 2]

	; Get AutoIt GUI handle
	Local $hWnd = WinGetHandle(AutoItWinGetTitle())
	; Open Theme DLL
	Local $hThemeDLL = DllOpen("uxtheme.dll")
	; Get default theme handle
	Local $hTheme = DllCall($hThemeDLL, 'ptr', 'OpenThemeData', 'hwnd', $hWnd, 'wstr', "Static")
	If @error Then Return $aDefFontData
	$hTheme = $hTheme[0]
	; Create LOGFONT structure => http://msdn.microsoft.com/en-us/library/dd145037(VS.85).aspx
	Local $tFont = DllStructCreate("long;long;long;long;long;byte;byte;byte;byte;byte;byte;byte;byte;wchar[32]")
	Local $pFont = DllStructGetPtr($tFont)
	; Get MsgBox font from theme
	DllCall($hThemeDLL, 'long', 'GetThemeSysFont', 'HANDLE', $hTheme, 'int', 805, 'ptr', $pFont) ; TMT_MSGBOXFONT
	If @error Then Return $aDefFontData
	; Get default DC
	Local $hDC = DllCall("user32.dll", "handle", "GetDC", "hwnd", $hWnd)
	If @error Then Return $aDefFontData
	$hDC = $hDC[0]
	; Get font vertical size
	Local $iPixel_Y = DllCall("gdi32.dll", "int", "GetDeviceCaps", "handle", $hDC, "int", 90) ; LOGPIXELSY
	If Not @error Then
		$iPixel_Y = $iPixel_Y[0]
		$aDefFontData[0] = Int(2 * (.25 - DllStructGetData($tFont, 1) * 72 / $iPixel_Y)) / 2
	EndIf
	; Close DC
	DllCall("user32.dll", "int", "ReleaseDC", "hwnd", $hWnd, "handle", $hDC)
	; Extract font data from LOGFONT structure
	$aDefFontData[3] = DllStructGetData($tFont, 14)
	$aDefFontData[1] = DllStructGetData($tFont, 5)
	$aDefFontData[4] = DllStructGetData($tFont, 12)

	If DllStructGetData($tFont, 6) Then $aDefFontData[2] += 2
	If DllStructGetData($tFont, 7) Then $aDefFontData[2] += 4
	If DllStructGetData($tFont, 8) Then $aDefFontData[2] += 8

	Return $aDefFontData

EndFunc   ;==>_SetFont_GetDefault

;; GetDPI.au3
;;
;; Get the current DPI (dots per inch) setting, and the ratio
;; between it and approximately 96 DPI.
;;
;; Author: Phillip123Adams
;; Posted: August, 17, 2005, originally developed 10/17/2004,
;; AutoIT 3.1.1.67 (but earlier v3.1.1 versions with DLLCall should work).
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;~   ;; Example
;~  #include<guiconstants.au3>
;~   ;;
;~   ;; Get the current DPI.
;~  $a1 = _SetFont_GetDPI()
;~  $iDPI = $a1[1]
;~  $iDPIRat = $a1[2]
;~   ;;
;~   ;; Design the GUI to show how to apply the DPI adjustment.
;~  GUICreate("Applying DPI to GUI's", 250 * $iDPIRat, 120 * $iDPIRat)
;~  $lbl = GUICtrlCreateLabel("The current DPI value is " & $iDPI &@lf& "Ratio to 96 is " & $iDPIRat &@lf&@lf& "Call function _SetFont_GetDPI.  Then multiply all GUI dimensions by the returned value divided by approximately 96.0.", 10 * $iDPIRat, 5 * $iDPIRat, 220 * $iDPIRat, 80 * $iDPIRat)
;~  $btnClose = GUICtrlCreateButton("Close", 105 * $iDPIRat, 90 * $iDPIRat, 40 * $iDPIRat, 20 * $iDPIRat)
;~  GUISetState()
;~   ;;
;~  while 1
;~   $iMsg = GUIGetMsg()
;~   If $iMsg = $GUI_EVENT_CLOSE or $iMsg = $btnClose then ExitLoop
;~  WEnd
;~  Exit
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Func _SetFont_GetDPI()
	;; Get the current DPI (dots per inch) setting, and the ratio between it and
	;; approximately 96 DPI.
	;;
	;; Retrun a 1D array of dimension 3.  Indices zero is the dimension of the array
	;; minus one.  Indices 1 = the current DPI (an integer).  Indices 2 is the ratio
	;; should be applied to all GUI dimensions to make the GUI automatically adjust
	;; to suit the various DPI settings.
	;;
	;; Author: Phillip123Adams
	;; Posted: August, 17, 2005, originally developed 6/04/2004,
	;; AutoIT 3.1.1.67 (but earlier v3.1.1 versions with DLLCall should work).
	;;
	;; Note: The dll calls are based upon code from the AutoIt3 forum from a post
	;; by this-is-me on Nov 23 2004, 10:29 AM under topic "@Larry, Help!"  Thanks
	;; to this-is-me and Larry.  Prior to that, I was obtaining the current DPI
	;; from the Registry:
	;;    $iDPI = RegRead("HKCU\Control Panel\Desktop\WindowMetrics", "AppliedDPI")
	;;

	Local $a1[3]
	Local $iDPI, $iDPIRat, $Logpixelsy = 90, $hWnd = 0
	Local $hDC = DllCall($h_DLL_user32, "long", "GetDC", "long", $hWnd)
	Local $aRet = DllCall($h_DLL_GDI32, "long", "GetDeviceCaps", "long", $hDC[0], "long", $Logpixelsy)
	Local $hDC = DllCall($h_DLL_user32, "long", "ReleaseDC", "long", $hWnd, "long", $hDC)
	$iDPI = $aRet[0]
	;; Set a ratio for the GUI dimensions based upon the current DPI value.
	Select
		Case $iDPI = 0
			$iDPI = 96
			$iDPIRat = 94
		Case $iDPI < 84
			$iDPIRat = $iDPI / 105
		Case $iDPI < 121
			$iDPIRat = $iDPI / 96
		Case $iDPI < 145
			$iDPIRat = $iDPI / 95
		Case Else
			$iDPIRat = $iDPI / 94
	EndSelect
	$a1[0] = 2
	$a1[1] = $iDPI
	$a1[2] = $iDPIRat
	;; Return the array
	Return $a1
EndFunc   ;==>_SetFont_GetDPI

Func WM_COPYDATA($hWnd, $MsgID, $wParam, $lParam)
	Local $tCOPYDATA = DllStructCreate("ulong_ptr;dword;ptr", $lParam)
	Local $tMsg = DllStructCreate("char[" & DllStructGetData($tCOPYDATA, 2) & "]", DllStructGetData($tCOPYDATA, 3))

	If DllStructGetData($tMsg, 1) = "/exit" Then _HRC_Exit()

	Return 0
EndFunc   ;==>WM_COPYDATA

Func WM_COPYDATA_SendData($hWnd, $sData)
	If Not IsHWnd($hWnd) Then Return 0
	If $sData = "" Then $sData = " "
	Local $tCOPYDATA, $tMsg
	$tMsg = DllStructCreate("char[" & StringLen($sData) + 1 & "]")
	DllStructSetData($tMsg, 1, $sData)
	$tCOPYDATA = DllStructCreate("ulong_ptr;dword;ptr")
	DllStructSetData($tCOPYDATA, 2, StringLen($sData) + 1)
	DllStructSetData($tCOPYDATA, 3, DllStructGetPtr($tMsg))
	$Ret = DllCall("user32.dll", "lparam", "SendMessage", "hwnd", $hWnd, "int", $WM_COPYDATA, "wparam", 0, "lparam", DllStructGetPtr($tCOPYDATA))
	If (@error) Or ($Ret[0] = -1) Then Return 0
	Return 1
EndFunc   ;==>WM_COPYDATA_SendData

#region English Button text for MsgBox!!
Func _MsgBox_English($flag, $title, $text, $timeout = 0, $hWnd = 0)
	Local $hProcMsgBox = DllCallbackRegister("_CbtHookProc_MsgBox", "int", "int;int;int")
	Local $TIDMsgBox = _WinAPI_GetCurrentThreadId()
	$h_HookMsgBox = _WinAPI_SetWindowsHookEx($WH_CBT, DllCallbackGetPtr($hProcMsgBox), 0, $TIDMsgBox)
	Local $iRet = MsgBox($flag, $title, $text, $timeout, $hWnd)
	_WinAPI_UnhookWindowsHookEx($h_HookMsgBox)
	DllCallbackFree($hProcMsgBox)
	Return $iRet
EndFunc   ;==>_MsgBox_English
Func _CbtHookProc_MsgBox($nCode, $wParam, $lParam, $h_HookMsgBox)
	Local $Ret = 0, $hBitmap = 0, $xWnd = 0
	Local $sButtonText
	If $nCode < 0 Then
		$Ret = _WinAPI_CallNextHookEx($h_HookMsgBox, $nCode, $wParam, $lParam)
		Return $Ret
	EndIf
	Switch $nCode
		Case 5 ;5=HCBT_ACTIVATE
			_WinAPI_SetDlgItemText($wParam, 1, "OK")
			_WinAPI_SetDlgItemText($wParam, 2, "Cancel")
			_WinAPI_SetDlgItemText($wParam, 3, "&Abort")
			_WinAPI_SetDlgItemText($wParam, 4, "&Retry")
			_WinAPI_SetDlgItemText($wParam, 5, "&Ignore")
			_WinAPI_SetDlgItemText($wParam, 6, "&Yes")
			_WinAPI_SetDlgItemText($wParam, 7, "&No")
			_WinAPI_SetDlgItemText($wParam, 8, "Help")
			_WinAPI_SetDlgItemText($wParam, 10, "&Try Again")
			_WinAPI_SetDlgItemText($wParam, 11, "&Continue")
	EndSwitch
	Return
EndFunc   ;==>_CbtHookProc_MsgBox
Func _WinAPI_SetDlgItemText($hDlg, $nIDDlgItem, $lpString)
	Local $aRet = DllCall('user32.dll', "int", "SetDlgItemText", _
			"hwnd", $hDlg, _
			"int", $nIDDlgItem, _
			"str", $lpString)
	Return $aRet[0]
EndFunc   ;==>_WinAPI_SetDlgItemText
;##########################################################
#endregion English Button text for MsgBox!!