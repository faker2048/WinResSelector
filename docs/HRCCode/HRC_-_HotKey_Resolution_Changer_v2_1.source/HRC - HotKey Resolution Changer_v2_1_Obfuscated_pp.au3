#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
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
#Obfuscator_Parameters=/sf /sv /om /cs=0 /cn=0
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#Obfuscator_Ignore_Funcs=_ApplySettingsHK,_HRC_Recover

#region DllOpen_PostProcessor START
Global $0 = DllOpen("msvcrt.dll")
Global $1 = DllOpen("kernel32.dll")
Global $2 = DllOpen("user32.dll")
Global $3 = DllOpen("gdi32.dll")
Global $4 = DllOpen("comctl32.dll")
Global $5 = DllOpen("ole32.dll")
Global $6 = DllOpen("oleaut32.dll")
Global $7 = DllOpen("Crypt32.dll")
Global $8 = DllOpen("ntdll.dll")
#region DllOpen_PostProcessor END
Global $9 = "v2.1 (2012-May-16)"
Global $a
Global Const $b = 1
Global Const $c = 3
Global Const $d = 0x0002
Global Const $e = 250
Global $f = False
Global $g, $h
Global $i, $j = 0
If FileExists(@WindowsDir & '\Fonts\ARIAL.ttf') Then
$i = "Arial"
ElseIf FileExists(@WindowsDir & '\Fonts\TAHOMA.ttf') Then
$i = "Tahoma"
$j = -0.1
ElseIf FileExists(@WindowsDir & '\Fonts\Verdana.ttf') Then
$i = "Verdana"
$j = -1
Else
$i = "Arial"
EndIf
Global Const $k = 0
Global Const $l = 0x0080
Global Const $m = 0x1600
Global Const $n =($m + 0x0002)
Global Const $o = 0x40
Global Const $p = 0x2
Global Const $q = 0x3
Global Const $r = 0x161
Global Const $s = 0x00200000
Global Const $t = BitOR($p, $o, $s)
Global Const $u = -3
Global Const $v = 'GUI_RUNDEFMSG'
Global Const $w = 64
Global Const $x = 128
Global Const $y = 256
Global Const $0z = -2
Global Const $10 = 0x00100000
Global Const $11 = 0x0100
Global Const $12 = 0x00020000
Global Const $13 = 0x00080000
Global Const $14 = 0x00200000
Global Const $15 = 0x00800000
Global Const $16 = 0x00C00000
Global Const $17 = 0x80000000
Global Const $18 = 0x00000001
Global Const $19 = 0x00000080
Global Const $1a = 0x00000008
Global Const $1b = 0x004A
Global Const $1c = 0x007E
Global Const $1d = 0x0100
Global Const $1e = 0x0101
Global Const $1f = 0x0104
Global Const $1g = 0x0105
Global Const $1h = 0x0111
Global Const $1i = BitOR($12, $16, $17, $13)
Global Const $1j = 90
Global Const $1k = "struct;long X;long Y;endstruct"
Global Const $1l = "struct;long Left;long Top;long Right;long Bottom;endstruct"
Global Const $1m = "uint Width;uint Height;int Stride;int Format;ptr Scan0;uint_ptr Reserved"
Global Const $1n = "uint Version;ptr Callback;bool NoThread;bool NoCodecs"
Global Const $1o = "ulong Data1;ushort Data2;ushort Data3;byte Data4[8]"
Global Const $1p = "dword vkCode;dword scanCode;dword flags;dword time;ulong_ptr dwExtraInfo"
Func _4($1q = @error, $1r = @extended)
Local $1s = dllcall($1, "dword", "GetLastError")
Return SetError($1q, $1r, $1s[0])
EndFunc
Global Const $1t = 64
Global Const $1u = 128
Global Const $1v = 2048
Global Const $1w = 4096
Global Const $1x = 0x00200000
Global Const $1y = 0x00100000
Global Const $1z = BitOR($1w, $1x, $1y, $1t, $1u)
Func _5($20, $21, $22 = 0, $23 = 0, $24 = 0, $25 = "wparam", $26 = "lparam", $27 = "lresult")
Local $1s = dllcall($2, $27, "SendMessageW", "hwnd", $20, "uint", $21, $25, $22, $26, $23)
If @error Then Return SetError(@error, @extended, "")
If $24 >= 0 And $24 <= 4 Then Return $1s[$24]
Return $1s
EndFunc
Global Const $28 = Ptr(-1)
Global Const $29 = Ptr(-1)
Global Const $2a = 5
Global Const $2b = 13
Global Const $2c = 0x0100
Global Const $2d = 0x2000
Global Const $2e = 0x8000
Global Const $2f = BitShift($2c, 8)
Global Const $2g = BitShift($2d, 8)
Global Const $2h = BitShift($2e, 8)
Func _6($2i, $2j, $22, $23)
Local $1s = dllcall($2, "lresult", "CallNextHookEx", "handle", $2i, "int", $2j, "wparam", $22, "lparam", $23)
If @error Then Return SetError(@error, @extended, -1)
Return $1s[0]
EndFunc
Func _7($2k)
Local $1s = dllcall($3, "bool", "DeleteObject", "handle", $2k)
If @error Then Return SetError(@error, @extended, False)
Return $1s[0]
EndFunc
Func _8($20, $2l = True)
Local $1s = dllcall($2, "bool", "EnableWindow", "hwnd", $20, "bool", $2l)
If @error Then Return SetError(@error, @extended, False)
Return $1s[0]
EndFunc
Func _9($20)
If Not IsHWnd($20) Then $20 = GUICtrlGetHandle($20)
Local $1s = dllcall($2, "int", "GetClassNameW", "hwnd", $20, "wstr", "", "int", 4096)
If @error Then Return SetError(@error, @extended, False)
Return SetExtended($1s[0], $1s[2])
EndFunc
Func _a()
Local $1s = dllcall($1, "dword", "GetCurrentThreadId")
If @error Then Return SetError(@error, @extended, 0)
Return $1s[0]
EndFunc
Func _b()
Local $1s = dllcall($2, "hwnd", "GetFocus")
If @error Then Return SetError(@error, @extended, 0)
Return $1s[0]
EndFunc
Func _c($2m)
Local $2n = "wstr"
If $2m = "" Then
$2m = 0
$2n = "ptr"
EndIf
Local $1s = dllcall($1, "handle", "GetModuleHandleW", $2n, $2m)
If @error Then Return SetError(@error, @extended, 0)
Return $1s[0]
EndFunc
Func _d($20, $2o)
Local $2p = Opt("GUIDataSeparatorChar")
Local $2q = StringSplit($2o, $2p)
If Not IsHWnd($20) Then $20 = GUICtrlGetHandle($20)
Local $2r = _9($20)
For $2s = 1 To UBound($2q) - 1
If StringUpper(StringMid($2r, 1, StringLen($2q[$2s]))) = StringUpper($2q[$2s]) Then Return True
Next
Return False
EndFunc
Func _e($20, $2t = 0, $2u = True)
Local $1s = dllcall($2, "bool", "InvalidateRect", "hwnd", $20, "struct*", $2t, "bool", $2u)
If @error Then Return SetError(@error, @extended, False)
Return $1s[0]
EndFunc
Func _f($2v, $2w, $2x)
BlockInput(0)
MsgBox($2v, $2w, $2x & "      ")
EndFunc
Func _g($2y)
Local $1s = dllcall($2, "uint", "RegisterWindowMessageW", "wstr", $2y)
If @error Then Return SetError(@error, @extended, 0)
Return $1s[0]
EndFunc
Func _h($2z, $30, $31, $32 = 0)
Local $1s = dllcall($2, "handle", "SetWindowsHookEx", "int", $2z, "ptr", $30, "handle", $31, "dword", $32)
If @error Then Return SetError(@error, @extended, 0)
Return $1s[0]
EndFunc
Func _i($2i)
Local $1s = dllcall($2, "bool", "UnhookWindowsHookEx", "handle", $2i)
If @error Then Return SetError(@error, @extended, False)
Return $1s[0]
EndFunc
Global Const $33 = 0x0001
Global Const $34 = 0x00022009
Global Const $35 = 0x0026200A
Global $36 = 0
Global $37 = 0
Global $38 = 0
Func _j($39)
Local $1s = DllCall($36, "int", "GdipDisposeImage", "handle", $39)
If @error Then Return SetError(@error, @extended, False)
Return $1s[0] = 0
EndFunc
Func _k($39, $3a, $3b, $3c, $3d, $2v = $33, $3e = $34)
Local $3f = DllStructCreate($1m)
Local $2t = DllStructCreate($1l)
DllStructSetData($2t, "Left", $3a)
DllStructSetData($2t, "Top", $3b)
DllStructSetData($2t, "Right", $3c)
DllStructSetData($2t, "Bottom", $3d)
Local $1s = DllCall($36, "int", "GdipBitmapLockBits", "handle", $39, "struct*", $2t, "uint", $2v, "int", $3e, "struct*", $3f)
If @error Then Return SetError(@error, @extended, 0)
Return SetExtended($1s[0], $3f)
EndFunc
Func _l($39, $3g)
Local $1s = DllCall($36, "int", "GdipBitmapUnlockBits", "handle", $39, "struct*", $3g)
If @error Then Return SetError(@error, @extended, False)
Return $1s[0] = 0
EndFunc
Func _m()
If $36 = 0 Then Return SetError(-1, -1, False)
$37 -= 1
If $37 = 0 Then
DllCall($36, "none", "GdiplusShutdown", "ptr", $38)
DllClose($36)
$36 = 0
EndIf
Return True
EndFunc
Func _n()
$37 += 1
If $37 > 1 Then Return True
$36 = DllOpen("GDIPlus.dll")
If $36 = -1 Then
$37 = 0
Return SetError(1, 2, False)
EndIf
Local $3h = DllStructCreate($1n)
Local $3i = DllStructCreate("ulong_ptr Data")
DllStructSetData($3h, "Version", 1)
Local $1s = DllCall($36, "int", "GdiplusStartup", "struct*", $3i, "struct*", $3h, "ptr", 0)
If @error Then Return SetError(@error, @extended, False)
$38 = DllStructGetData($3i, "Data")
Return $1s[0] = 0
EndFunc
Func _o($2x, $3j = @ScriptLineNumber, $3k = @error, $3l = @extended)
ConsoleWrite( _
"!===========================================================" & @CRLF & _
"+======================================================" & @CRLF & _
"-->Line(" & StringFormat("%04d", $3j) & "):" & @TAB & $2x & @CRLF & _
"+======================================================" & @CRLF)
Return SetError($3k, $3l, 1)
EndFunc
Func _p($20, $3m)
_o("This is for debugging only, set the debug variable to false before submitting")
If _d($20, $3m) Then Return True
Local $2p = Opt("GUIDataSeparatorChar")
$3m = StringReplace($3m, $2p, ",")
_o("Invalid Class Type(s):" & @LF & @TAB & "Expecting Type(s): " & $3m & @LF & @TAB & "Received Type : " & _9($20))
Exit
EndFunc
Global $3n = False
Global Const $3o = "ComboBox"
Global Const $3p = 0x000B
Func _q($20)
If $3n Then _p($20, $3o)
If Not IsHWnd($20) Then $20 = GUICtrlGetHandle($20)
Return _5($20, $3p) = 0
EndFunc
Func _r($20)
If $3n Then _p($20, $3o)
If Not IsHWnd($20) Then $20 = GUICtrlGetHandle($20)
Return _5($20, $3p, 1) = 0
EndFunc
Func _s($20, $3q, $3r)
If $3n Then _p($20, $3o)
If Not IsHWnd($20) Then $20 = GUICtrlGetHandle($20)
Return _5($20, $r, $3q, $3r)
EndFunc
Global Const $3s = 0x00000001
Global Const $3t = 0x00000000
Global Const $3u = 0x000000FE
Global Const $3v = 0x00000004
Global Const $3w = 0x00000008
Global Const $3x = 0x00000010
Global Const $3y = 0x00000018
Global Const $3z = 0x00000020
Global Const $40 = 0x00002000
Global Const $41 = 0x00008000
Func _t($20, $42, $43 = 0)
Local $1s = dllcall($4, "int", "ImageList_Add", "handle", $20, "handle", $42, "handle", $43)
If @error Then Return SetError(@error, @extended, -1)
Return $1s[0]
EndFunc
Func _u($44 = 16, $45 = 16, $46 = 4, $47 = 0, $48 = 4, $49 = 4)
Local Const $4a[7] = [$3t, $3v, $3w, $3x, $3y, $3z, $3u]
Local $2v = 0
If BitAND($47, 1) <> 0 Then $2v = BitOR($2v, $3s)
If BitAND($47, 2) <> 0 Then $2v = BitOR($2v, $40)
If BitAND($47, 4) <> 0 Then $2v = BitOR($2v, $41)
$2v = BitOR($2v, $4a[$46])
Local $1s = dllcall($4, "handle", "ImageList_Create", "int", $44, "int", $45, "uint", $2v, "int", $48, "int", $49)
If @error Then Return SetError(@error, @extended, 0)
Return $1s[0]
EndFunc
Func _v($20)
Local $1s = dllcall($4, "bool", "ImageList_Destroy", "handle", $20)
If @error Then Return SetError(@error, @extended, False)
Return $1s[0] <> 0
EndFunc
Global $4b = False
Global Const $4c = "ptr ImageList;" & $1l & ";uint Align"
Global Const $4d = "Button"
Func _w($20, $2l = True)
If $4b Then _p($20, $4d)
If Not IsHWnd($20) Then $20 = GUICtrlGetHandle($20)
If _d($20, $4d) Then Return _8($20, $2l) = $2l
EndFunc
Func _x($20, $42, $4e = 0, $3a = 1, $3b = 1, $4f = 1, $4g = 1)
If $4b Then _p($20, $4d)
If Not IsHWnd($20) Then $20 = GUICtrlGetHandle($20)
If $4e < 0 Or $4e > 4 Then $4e = 0
Local $4h = DllStructCreate($4c)
DllStructSetData($4h, "ImageList", $42)
DllStructSetData($4h, "Left", $3a)
DllStructSetData($4h, "Top", $3b)
DllStructSetData($4h, "Right", $4f)
DllStructSetData($4h, "Bottom", $4g)
DllStructSetData($4h, "Align", $4e)
Local $4i = _w($20, False)
Local $4j = _5($20, $n, 0, $4h, 0, "wparam", "struct*") <> 0
_w($20)
If Not $4i Then _w($20, False)
Return $4j
EndFunc
Global $4k = 0
Global Const $4l = 0x0001
Global Const $4m = 0x0002
Global Const $4n = 0x0004
Global Const $4o = 0x0008
Global Const $4p = 0x0010
Global Const $4q = 0x0040
Global Const $4r = 0x0080
Global Const $4s = BitOR($4n, $4o)
Global Const $4t = 0x0006
Global Const $4u = _g('{509ADA08-BDC8-45BC-8082-1FFA4CB8D1C8}')
Global $4v[1][12] = [[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, GUICreate('')]]
GUIRegisterMsg($4t, '_19')
GUIRegisterMsg($4u, '_1a')
OnAutoItExitRegister('_1b')
Func _y($4w, $4x = 0, $2v = -1, $2w = 0)
Local $4y = 0, $4z = False, $50 = False
If $2v < 0 Then
$2v = $4s
EndIf
If(BitAND($2v, $4p) = 0) And($4v[0][6] > 0) Then
Return SetError(1,-1, 0)
EndIf
If(Not IsString($4x)) And($4x = 0) Then
$4x = ''
EndIf
$4x = StringStripWS($4x, 3)
$4w = BitAND($4w, 0x0FFF)
If BitAND($4w, 0x00FF) = 0 Then
Return SetError(1, 0, 0)
EndIf
For $51 = 1 To $4v[0][0]
If $4v[$51][0] = $4w Then
$4y = $51
ExitLoop
EndIf
Next
If Not $4x Then
If $4y = 0 Then
Return SetError(0, 0, 1)
EndIf
If(BitAND($2v, $4m) = 0) And($4v[0][5]) And($4v[0][0] = 1) Then
If Not _i($4v[0][5]) Then
Return SetError(1, 0, 0)
EndIf
DllCallbackFree($4v[0][4])
$4v[0][5] = 0
_17()
EndIf
$4v[0][8] = 1
For $51 = $4y To $4v[0][0] - 1
For $52 = 0 To UBound($4v, 2) - 1
$4v[$51][$52] = $4v[$51 + 1][$52]
Next
Next
ReDim $4v[$4v[0][0]][UBound($4v, 2)]
$4v[0][0] -= 1
If $4w = $4v[0][2] Then
_17()
EndIf
$4v[0][8] = 0
Else
If $4y = 0 Then
If($4v[0][5] = 0) And($4v[0][3] = 0) Then
$4v[0][4] = DllCallbackRegister('_15', 'long', 'int;wparam;lparam')
$4v[0][5] = _h($2b, DllCallbackGetPtr($4v[0][4]), _c(0), 0)
If(@error) Or($4v[0][5] = 0) Then
Return SetError(1, 0, 0)
EndIf
EndIf
$4y = $4v[0][0] + 1
ReDim $4v[$4y + 1][UBound($4v, 2)]
$4z = 1
EndIf
$4v[$4y][0] = $4w
$4v[$4y][1] = $4x
$4v[$4y][2] = $2w
$4v[$4y][3] =(BitAND($2v, $4l) = $4l)
$4v[$4y][4] =(BitAND($2v, $4n) = $4n)
$4v[$4y][5] =(BitAND($2v, $4o) = $4o)
$4v[$4y][6] =(BitAND($2v, $4q) = $4q)
$4v[$4y][7] =(BitAND($2v, $4r) = $4r)
$4v[$4y][8] = 0
For $51 = 9 To 11
$4v[$4y][$51] = 0
Next
If $4z Then
$4v[0][0] += 1
EndIf
EndIf
Return 1
EndFunc
Func _0z()
If $4v[0][6] > 0 Then
Return SetError(1,-1, 0)
EndIf
If($4v[0][5] = 0) And($4v[0][0] > 0) Then
$4v[0][4] = DllCallbackRegister('_15', 'long', 'int;wparam;lparam')
$4v[0][5] = _h($2b, DllCallbackGetPtr($4v[0][4]), _c(0), 0)
If(@error) Or($4v[0][5] = 0) Then
Return SetError(1, 0, 0)
EndIf
EndIf
$4v[0][3] = 0
Return 1
EndFunc
Func _10($2v = -1)
If $2v < 0 Then
$2v = 0
EndIf
If(BitAND($2v, $4p) = 0) And($4v[0][6] > 0) Then
Return SetError(1,-1, 0)
EndIf
If(BitAND($2v, $4m) = 0) And($4v[0][5]) Then
If Not _i($4v[0][5]) Then
Return SetError(1, 0, 0)
EndIf
DllCallbackFree($4v[0][4])
$4v[0][5] = 0
EndIf
$4v[0][3] = 1
_17()
Return 1
EndFunc
Func _11($2v = -1)
If $2v < 0 Then
$2v = 0
EndIf
If(BitAND($2v, $4p) = 0) And($4v[0][6] > 0) Then
Return SetError(1,-1, 0)
EndIf
If(BitAND($2v, $4m) = 0) And($4v[0][5]) Then
If Not _i($4v[0][5]) Then
Return SetError(1, 0, 0)
EndIf
DllCallbackFree($4v[0][4])
$4v[0][5] = 0
_17()
EndIf
$4v[0][0] = 0
ReDim $4v[1][UBound($4v, 2)]
Return 1
EndFunc
Func _12($20)
If(IsInt($20)) And($20 = 0) Then
Return 1
Else
If WinActive($20) Then
Return 1
EndIf
EndIf
Return 0
EndFunc
Func _13($53)
If($4v[$53][4] = 0) Or($4v[$53][8] = 0) Then
If $4v[$53][7] = 0 Then
dllcall($2, 'int', 'PostMessage', 'hwnd', $4v[0][10], 'uint', $4u, 'int', $53, 'int', 0xAFAF)
Else
dllcall($2, 'int', 'SendMessage', 'hwnd', $4v[0][10], 'uint', $4u, 'int', $53, 'int', 0xAFAF)
EndIf
EndIf
EndFunc
Func _14($54)
Local $55 = dllcall($2, 'short', 'GetAsyncKeyState', 'int', $54)
If(@error) Or((Not $55[0]) And(_4())) Then
Return SetError(1, 0, 0)
EndIf
Return BitAND($55[0], 0x8000)
EndFunc
Func _15($2j, $22, $23)
If($2j > -1) And($4v[0][1] = 0) And($4v[0][3] = 0) Then
Local $54 = DllStructGetData(DllStructCreate($1p, $23), 'vkCode')
Local $56 = False
Switch $22
Case $1d, $1f
If $4v[0][8] = 1 Then
Return -1
EndIf
Switch $54
Case 0xA0 To 0xA5, 0x5B, 0x5C
Switch $54
Case 0xA0, 0xA1
$4v[0][9] = BitOR($4v[0][9], 0x01)
Case 0xA2, 0xA3
$4v[0][9] = BitOR($4v[0][9], 0x02)
Case 0xA4, 0xA5
$4v[0][9] = BitOR($4v[0][9], 0x04)
Case 0x5B, 0x5C
$4v[0][9] = BitOR($4v[0][9], 0x08)
EndSwitch
If $4v[0][2] > 0 Then
$4v[0][2] = 0
EndIf
Case Else
If $4v[0][9] Then
_18()
EndIf
Local $57 = BitOR(BitShift($4v[0][9], -8), $54)
Local $58 = False
If($4v[0][2] = 0) Or($4v[0][2] = $57) Then
For $51 = 1 To $4v[0][0]
If(_12($4v[$51][2])) And($4v[$51][0] = $57) Then
If $4v[0][2] = $4v[$51][0] Then
If $4v[$51][5] = 0 Then
$58 = 1
EndIf
Else
$4v[0][2] = $4v[$51][0]
$4v[0][7] = $4v[$51][3]
$58 = 1
EndIf
If $4v[$51][3] = 0 Then
$56 = 1
EndIf
If $58 Then
_13($51)
EndIf
ExitLoop
EndIf
Next
Else
$56 = 1
EndIf
EndSwitch
If $56 Then
Return -1
EndIf
Case $1e, $1g
Switch $54
Case 0xA0 To 0xA5, 0x5B, 0x5C
Switch $54
Case 0xA0, 0xA1
$4v[0][9] = BitAND($4v[0][9], 0xFE)
Case 0xA2, 0xA3
$4v[0][9] = BitAND($4v[0][9], 0xFD)
Case 0xA4, 0xA5
$4v[0][9] = BitAND($4v[0][9], 0xFB)
Case 0x5B, 0x5C
$4v[0][9] = BitAND($4v[0][9], 0xF7)
EndSwitch
If($4v[0][2] > 0) And($4v[0][7] = 0) And($4v[0][9] = 0) Then
$4v[0][1] = 1
_16($54)
$4v[0][1] = 0
Return -1
EndIf
Case BitAND($4v[0][2], 0x00FF)
$4v[0][2] = 0
Case Else
EndSwitch
EndSwitch
EndIf
Return _6(0, $2j, $22, $23)
EndFunc
Func _16($54)
dllcall($2, 'int', 'keybd_event', 'int', 0x88, 'int', 0, 'int', 0, 'ptr', 0)
dllcall($2, 'int', 'keybd_event', 'int', $54, 'int', 0, 'int', 2, 'ptr', 0)
dllcall($2, 'int', 'keybd_event', 'int', 0x88, 'int', 0, 'int', 2, 'ptr', 0)
EndFunc
Func _17()
$4v[0][2] = 0
$4v[0][7] = 0
$4v[0][9] = 0
EndFunc
Func _18()
Local $57 = 0
If _14(0x10) Then
If Not @error Then
$57 = BitOR($57, 0x01)
Else
Return
EndIf
EndIf
If _14(0x11) Then
If Not @error Then
$57 = BitOR($57, 0x02)
Else
Return
EndIf
EndIf
If _14(0x12) Then
If Not @error Then
$57 = BitOR($57, 0x04)
Else
Return
EndIf
EndIf
If _14(0x5B) Or _14(0x5C) Then
If Not @error Then
$57 = BitOR($57, 0x08)
Else
Return
EndIf
EndIf
$4v[0][9] = $57
EndFunc
Func _19($20, $21, $22, $23)
Return 'GUI_RUNDEFMSG'
EndFunc
Func _1a($20, $21, $22, $23)
Switch $20
Case $4v[0][10]
Switch $23
Case 0xAFAF
$4v[0][6] += 1
$4v[$22][8] += 1
If $4v[$22][6] = 1 Then
Call($4v[$22][1], $4v[$22][0])
Else
Call($4v[$22][1])
EndIf
$4v[$22][8] -= 1
$4v[0][6] -= 1
EndSwitch
EndSwitch
EndFunc
Func _1b()
If $4v[0][5] Then
_i($4v[0][5])
DllCallbackFree($4v[0][4])
EndIf
EndFunc
Global $59 = StringSplit('None||||||||Backspace|Tab|||Clear|Enter||||||Pause|CapsLosk|||||||Esc|||||Spacebar|PgUp|PgDown|End|Home|Left|Up|Right|Down|Select|Print|Execute|PrtScr|Ins|Del|Help|0|1|2|3|4|5|6|7|8|9||||||||A|B|C|D|E|F|G|H|I|J|K|L|M|N|O|P|Q|R|S|T|U|V|W|X|Y|Z|Win|Win|0x5D||Sleep|Num 0|Num 1|Num 2|Num 3|Num 4|Num 5|Num 6|Num 7|Num 8|Num 9|Num *|Num +|0x6C|Num -|Num .|Num /|F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12|F13|F14|F15|F16|F17|F18|F19|F20|F21|F22|F23|F24|||||||||NumLock|ScrollLock|||||||||||||||Shift|Shift|Ctrl|Ctrl|Alt|Alt|BrowserBack|BrowserForward|BrowserRefresh|BrowserStop|BrowserSearch|BrowserFavorites|BrowserStart|VolumeMute|VolumeDown|VolumeUp|NextTrack|PreviousTrack|StopMedia|Play|Mail|Media|0xB6|0xB7|||;|+|,|-|.|/|~|||||||||||||||||||||||||||[|\|]|"|0xDF|||0xE2|||0xE5||0xE7|||||0xEC||||||||||0xF6|0xF7|0xF8|0xF9|0xFA|0xFB|0xFC|0xFD|0xFE|', '|', 2)
Global $5a[1][10] = [[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]]
Global $5b[1] = [0]
If _1p() >= 0x0600 Then
$5a[0][9] = _1n(0x0020, 0x0020, DllCallbackGetPtr(DllCallbackRegister('_1i', 'none', 'ptr;dword;hwnd;long;long;dword;dword')))
If @error Then
EndIf
EndIf
OnAutoItExitRegister('_1q')
Func _1c($4w, $3a, $3b, $3c = -1, $3d = -1, $5c = -1, $5d = -1, $2p = '-')
Local $5e, $5f[2]
$4w = BitAND($4w, 0x0FFF)
If BitAND($4w, 0x00FF) = 0 Then
$4w = 0
EndIf
If $5c < 0 Then
$5c = 0x0080
EndIf
If($5a[0][0] = 0) And($5a[0][5] = 0) Then
$5a[0][4] = DllCallbackRegister('_1l', 'long', 'int;wparam;lparam')
$5a[0][5] = _h($2b, DllCallbackGetPtr($5a[0][4]), _c(0), 0)
If(@error) Or($5a[0][5] = 0) Then
Return 0
EndIf
EndIf
$5e = GUICtrlCreateInput('', $3a, $3b, $3c, $3d, BitOR($5c, 0x0800), $5d)
If $5e = 0 Then
If $5a[0][0] = 0 Then
If _i($5a[0][5]) Then
DllCallbackFree($5a[0][4])
$5a[0][5] = 0
EndIf
EndIf
Return 0
EndIf
GUICtrlSetData($5e, _1g($4w, $2p))
ReDim $5a[$5a[0][0] + 2][UBound($5a, 2)]
$5a[$5a[0][0] + 1][0] = $5e
$5a[$5a[0][0] + 1][1] = GUICtrlGetHandle($5e)
$5a[$5a[0][0] + 1][2] = $4w
$5a[$5a[0][0] + 1][3] = $2p
For $51 = 4 To 9
$5a[$5a[0][0] + 1][$51] = 0
Next
$5a[0][0] += 1
Return $5e
EndFunc
Func _1d($5g)
Local $4y = _1j(_b())
For $51 = 1 To $5a[0][0]
If $5g = $5a[$51][0] Then
$5a[0][1] = 1
If Not GUICtrlDelete($5a[$51][0]) Then
EndIf
For $52 = $51 To $5a[0][0] - 1
For $5h = 0 To UBound($5a, 2) - 1
$5a[$52][$5h] = $5a[$52 + 1][$5h]
Next
Next
$5a[0][0] -= 1
ReDim $5a[$5a[0][0] + 1][UBound($5a, 2)]
If $5a[0][0] = 0 Then
If _i($5a[0][5]) Then
DllCallbackFree($5a[0][4])
$5a[0][2] = 0
$5a[0][3] = 0
$5a[0][5] = 0
$5a[0][6] = 0
$5a[0][7] = 0
$5a[0][8] = 0
EndIf
EndIf
If $51 = $5a[0][6] Then
$5a[0][6] = 0
EndIf
If $51 = $4y Then
$5a[0][2] = 0
$5a[0][7] = 0
$5a[0][8] = 0
EndIf
$5a[0][1] = 0
Return 1
EndIf
Next
Return 0
EndFunc
Func _1e($5g)
Local $55 = 0
For $51 = 1 To $5a[0][0]
If $5g = $5a[$51][0] Then
Return $5a[$51][2]
EndIf
Next
Return 0
EndFunc
Func _1f($4w)
$4w = BitAND($4w, 0x0FFF)
For $51 = 1 To $5b[0]
If $5b[$51] = $4w Then
Return
EndIf
Next
ReDim $5b[$5b[0] + 2]
$5b[$5b[0] + 1] = $4w
$5b[0] += 1
EndFunc
Func _1g($4w, $2p = '-')
Local $55 = '', $5i = StringLen($2p)
If BitAND($4w, 0x0200) = 0x0200 Then
$55 &= $59[0xA2] & $2p
EndIf
If BitAND($4w, 0x0100) = 0x0100 Then
$55 &= $59[0xA0] & $2p
EndIf
If BitAND($4w, 0x0400) = 0x0400 Then
$55 &= $59[0xA4] & $2p
EndIf
If BitAND($4w, 0x0800) = 0x0800 Then
$55 &= $59[0x5B] & $2p
EndIf
If BitAND($4w, 0x00FF) > 0 Then
$55 &= $59[BitAND($4w, 0x00FF)]
Else
If StringRight($55, $5i) = $2p Then
$55 = StringTrimRight($55, $5i)
EndIf
EndIf
If $55 = '' Then
$55 = $59[0x00]
EndIf
Return $55
EndFunc
Func _1h($5e)
If($5a[0][6] > 0) And($5e <> $5a[0][6]) Then
If($5a[0][3] > 0) And($5a[$5a[0][6]][2] = 0) Then
GUICtrlSetData($5a[$5a[0][6]][0], $59[0x00])
EndIf
$5a[0][2] = 0
$5a[0][7] = 0
$5a[0][8] = 0
EndIf
$5a[0][6] = $5e
EndFunc
Func _1i($5j, $5k, $20, $5l, $5m, $5n, $5o)
If $5a[0][0] Then
_1h(0)
If _1k() Then
$5a[0][3] = 0
EndIf
EndIf
EndFunc
Func _1j($5p)
For $51 = 1 To $5a[0][0]
If $5p = $5a[$51][1] Then
Return $51
EndIf
Next
Return 0
EndFunc
Func _1k()
Local $55 = dllcall($2, 'short', 'GetAsyncKeyState', 'int', 0)
If @error Then
Return SetError(1, 0, 0)
Else
If(Not $55[0]) And(_4()) Then
Return 1
Else
Return 0
EndIf
EndIf
EndFunc
Func _1l($2j, $22, $23)
If($2j < 0) Or($5a[0][1] = 1) Then
Switch $22
Case $1d, $1f
If $2j < 0 Then
ContinueCase
EndIf
Return -1
Case Else
Return _6($5a[0][5], $2j, $22, $23)
EndSwitch
EndIf
Local $54 = DllStructGetData(DllStructCreate($1p, $23), 'vkCode')
Local $4y = _1j(_b())
Local $57, $56 = True
_1h($4y)
Switch $22
Case $1d, $1f
Switch $54
Case 0xA0, 0xA1
$5a[0][3] = BitOR($5a[0][3], 0x01)
Case 0xA2, 0xA3
$5a[0][3] = BitOR($5a[0][3], 0x02)
Case 0xA4, 0xA5
$5a[0][3] = BitOR($5a[0][3], 0x04)
Case 0x5B, 0x5C
$5a[0][3] = BitOR($5a[0][3], 0x08)
EndSwitch
If $4y > 0 Then
If $54 = $5a[0][2] Then
Return -1
EndIf
$5a[0][2] = $54
Switch $54
Case 0xA0 To 0xA5, 0x5B, 0x5C
If $5a[0][7] = 1 Then
Return -1
EndIf
GUICtrlSetData($5a[$4y][0], _1g(BitShift($5a[0][3], -8), $5a[$4y][3]))
$5a[$4y][2] = 0
Case Else
If $5a[0][7] = 1 Then
Return -1
EndIf
Switch $54
Case 0x08, 0x1B
If $5a[0][3] = 0 Then
If $5a[$4y][2] > 0 Then
GUICtrlSetData($5a[$4y][0], $59[0x00])
$5a[$4y][2] = 0
EndIf
Return -1
EndIf
EndSwitch
If $59[$54] > '' Then
$57 = BitOR(BitShift($5a[0][3], -8), $54)
If Not _1m($57) Then
GUICtrlSetData($5a[$4y][0], _1g($57, $5a[$4y][3]))
$5a[$4y][2] = $57
$5a[0][7] = 1
$5a[0][8] = 1
Else
$56 = 0
EndIf
EndIf
EndSwitch
If $56 Then
Return -1
EndIf
EndIf
Case $1e, $1g
Switch $54
Case 0xA0, 0xA1
$5a[0][3] = BitAND($5a[0][3], 0xFE)
Case 0xA2, 0xA3
$5a[0][3] = BitAND($5a[0][3], 0xFD)
Case 0xA4, 0xA5
$5a[0][3] = BitAND($5a[0][3], 0xFB)
Case 0x5B, 0x5C
$5a[0][3] = BitAND($5a[0][3], 0xF7)
EndSwitch
If $4y > 0 Then
If $5a[$4y][2] = 0 Then
Switch $54
Case 0xA0 To 0xA5, 0x5B, 0x5C
GUICtrlSetData($5a[$4y][0], _1g(BitShift($5a[0][3], -8), $5a[$4y][3]))
EndSwitch
EndIf
EndIf
$5a[0][2] = 0
If $54 = BitAND($5a[$4y][2], 0x00FF) Then
$5a[0][8] = 0
EndIf
If $5a[0][3] = 0 Then
If $5a[0][8] = 0 Then
$5a[0][7] = 0
EndIf
EndIf
EndSwitch
Return _6(0, $2j, $22, $23)
EndFunc
Func _1m($4w)
For $51 = 1 To $5b[0]
If $4w = $5b[$51] Then
Return 1
EndIf
Next
Return 0
EndFunc
Func _1n($5q, $5r, $5s, $5t = 0, $5n = 0, $2v = 0)
Local $55 = dllcall($2, 'ptr', 'SetWinEventHook', 'uint', $5q, 'uint', $5r, 'ptr', 0, 'ptr', $5s, 'dword', $5t, 'dword', $5n, 'uint', $2v)
If(@error) Or(Not $55[0]) Then
Return SetError(1, 0, 0)
EndIf
Return $55[0]
EndFunc
Func _1o($5j)
Local $55 = dllcall($2, 'int', 'UnhookWinEvent', 'ptr', $5j)
If(@error) Or(Not $55[0]) Then
Return SetError(1, 0, 0)
EndIf
Return 1
EndFunc
Func _1p()
$5u = DllStructCreate('dword Size;dword MajorVersion;dword MinorVersion;dword BuildNumber;dword PlatformId;wchar CSDVersion[128]')
DllStructSetData($5u, 'Size', DllStructGetSize($5u))
$55 = dllcall($1, 'int', 'GetVersionExW', 'ptr', DllStructGetPtr($5u))
If(@error) Or(Not $55[0]) Then
Return SetError(1, 0, 0)
EndIf
Return BitOR(BitShift(DllStructGetData($5u, 'MajorVersion'), -8), DllStructGetData($5u, 'MinorVersion'))
EndFunc
Func _1q()
If $5a[0][5] Then
_i($5a[0][5])
Endif
If $5a[0][9] Then
_1o($5a[0][9])
EndIf
EndFunc
Global Const $5v = _22()
Global Const $5w = 'dword Size;hwnd hWnd;uint ID;uint Flags;uint CallbackMessage;ptr hIcon;wchar Tip[128];dword State;dword StateMask;wchar Info[256];uint Version;wchar InfoTitle[64];dword InfoFlags;'
Global Const $5x = 'align 2;dword_ptr Size;hwnd hOwner;ptr hDevMode;ptr hDevNames;hwnd hDC;dword Flags;ushort FromPage;ushort ToPage;ushort MinPage;ushort MaxPage;' & _21(@AutoItX64, 'uint', 'ushort') & ' Copies;ptr hInstance;lparam lParam;ptr PrintHook;ptr SetupHook;ptr PrintTemplateName;ptr SetupTemplateName;ptr hPrintTemplate;ptr hSetupTemplate;'
Global $5y, $5z, $60 = 0, $61 = 0, $62, $63 = 0, $64 = 0, $65, $66 = 16385, $67 = 8388608, $68 = 1
Func _1r($69, $6a = 0, $6b = 1)
$6a = _1y($6a, $69, 0, $6b)
If @error Then
Return SetError(@error, 0, 0)
EndIf
Return $6a
EndFunc
Func _1s($6c, $6d, $6e, $6f, $3e = 0x0002)
Local $55 = dllcall($8, 'uint', 'RtlDecompressBuffer', 'ushort', $3e, 'ptr', $6c, 'ulong', $6d, 'ptr', $6e, 'ulong', $6f, 'ulong*', 0)
If @error Then
Return SetError(1, 0, 0)
Else
If $55[0] Then
ConsoleWrite(Hex($55[0]) & @CR)
Return SetError(1, $55[0], 0)
EndIf
EndIf
Return $55[6]
EndFunc
Func _1t($2j)
dllcall($1, 'none', 'FatalExit', 'int', $2j)
EndFunc
Func _1u($6g)
If Not _1x($6g, 1) Then
Return SetError(@error, @extended, 0)
EndIf
Return 1
EndFunc
Func _1v($2j, $2x = '')
If $2x Then
_f(0x00040010, 'AutoIt', $2x)
EndIf
_1t($2j)
EndFunc
Func _1w($6h, $6b = 0)
Local $55
If Not $63 Then
$55 = dllcall($1, 'ptr', 'HeapCreate', 'dword', 0, 'ulong_ptr', 0, 'ulong_ptr', 0)
If(@error) Or(Not $55[0]) Then
_1v(1, 'Error allocating memory.')
EndIf
$63 = $55[0]
EndIf
$55 = dllcall($1, 'ptr', 'HeapAlloc', 'ptr', $63, 'dword', 0x00000008, 'ulong_ptr', $6h)
If(@error) Or(Not $55[0]) Then
If $6b Then
_1v(1, 'Error allocating memory.')
EndIf
Return SetError(9, 0, 0)
EndIf
Return $55[0]
EndFunc
Func _1x(ByRef $6g, $6i = 0)
If($6i) And(Not _20($6g)) Then
Return SetError(1, 0, 0)
EndIf
Local $55 = dllcall($1, 'int', 'HeapFree', 'ptr', $63, 'dword', 0, 'ptr', $6g)
If(@error) Or(Not $55[0]) Then
Return SetError(2, 0, 0)
EndIf
$6g = 0
Return 1
EndFunc
Func _1y($6g, $6h, $6j = 0, $6b = 0)
Local $55
If _20($6g) Then
If($6j) And(_1z($6g) >= $6h) Then
Return SetError(0, 1, Ptr($6g))
EndIf
$55 = dllcall($1, 'ptr', 'HeapReAlloc', 'ptr', $63, 'dword', 0x00000008, 'ptr', $6g, 'ulong_ptr', $6h)
If(@error) Or(Not $55[0]) Then
If $6b Then
_1v(1, 'Error allocating memory.')
EndIf
Return SetError(9, 0, Ptr($6g))
EndIf
$55 = $55[0]
Else
$55 = _1w($6h, $6b)
If @error Then
Return SetError(9, 0, 0)
EndIf
EndIf
Return $55
EndFunc
Func _1z($6g, $6i = 0)
If($6i) And(Not _20($6g)) Then
Return SetError(1, 0, 0)
EndIf
Local $55 = dllcall($1, 'ulong_ptr', 'HeapSize', 'ptr', $63, 'dword', 0, 'ptr', $6g)
If(@error) Or($55[0] = Ptr(-1)) Then
Return SetError(2, 0, 0)
EndIf
Return $55[0]
EndFunc
Func _20($6g)
If(Not $63) Or(Not Ptr($6g)) Then
Return SetError(1, 0, 0)
EndIf
Local $55 = dllcall($1, 'int', 'HeapValidate', 'ptr', $63, 'dword', 0, 'ptr', $6g)
If @error Then
Return SetError(2, 0, 0)
EndIf
Return $55[0]
EndFunc
Func _21($6k, $6l, $6m)
If $6k Then
Return $6l
Else
Return $6m
EndIf
EndFunc
Func _22()
Local $5u = DllStructCreate('dword;dword;dword;dword;dword;wchar[128]')
DllStructSetData($5u, 1, DllStructGetSize($5u))
Local $55 = dllcall($1, 'int', 'GetVersionExW', 'ptr', DllStructGetPtr($5u))
If(@error) Or(Not $55[0]) Then
Return SetError(1, 0, 0)
EndIf
Return BitOR(BitShift(DllStructGetData($5u, 2), -8), DllStructGetData($5u, 3))
EndFunc
_1f(0x062E)
_1f(0x0652)
_1f(0x0752)
Global $6n[1]
Global $6o[1]
Global $6p = "f2190b02-b21b-4402-93b0-4bc6a04859e3"
Global $6q = "HRC - HotKey Resolution Changer, " & $9
Global $6r
Global Const $6s = 0x0172
Global $6t = Random(1, 9999, 1)
IniWrite(@ScriptDir & "\HRC.ini", 'Settings', 'HRC_IniWriteTest', $6t)
If IniRead(@ScriptDir & "\HRC.ini", 'Settings', 'HRC_IniWriteTest', "") <> $6t Then
_38(16 + 262144, "HRC Error", "HRC can not write to the ini file" & @CRLF & @CRLF & @ScriptDir & "\HRC.ini" & @CRLF & @CRLF & "Settings will not be saved. Check directory permissions or change HRC.exe location.")
EndIf
Global $CmdLine_i_TriggerID
Global $CmdLine_b_TrayIcon_Hide = False
Global $CmdLine_b_Exit_After_Execution = False
Global $CmdLine_s_Execute_CommandLine
Global $CmdLine_s_Execute_Parameter
Global $CmdLine_b_Show_GUI = False
Global $CmdLine_b_Execute_Always = False
For $51 = 1 To $CmdLine[0]
If StringLen($CmdLine[$51]) = 2 And StringLeft($CmdLine[$51], 1) = "R" Then
$CmdLine_i_TriggerID = $CmdLine[$51]
$CmdLine_i_TriggerID = Int(StringRight($CmdLine_i_TriggerID, 1))
If $CmdLine_i_TriggerID > 0 And $CmdLine_i_TriggerID < 10 Then
If Not IniRead(@ScriptDir & "\HRC.ini", 'Settings', 'Res' & $CmdLine_i_TriggerID, "") Or Not IniRead(@ScriptDir & "\HRC.ini", 'Settings', 'Col' & $CmdLine_i_TriggerID, "") Or Not IniRead(@ScriptDir & "\HRC.ini", 'Settings', 'Fre' & $CmdLine_i_TriggerID, "") Then
$CmdLine_i_TriggerID = ""
Else
$CmdLine_i_TriggerID =($CmdLine_i_TriggerID * 2) + 1
EndIf
Else
$CmdLine_i_TriggerID = ""
EndIf
EndIf
Switch StringLower($CmdLine[$51])
Case "/exit"
$CmdLine_b_Exit_After_Execution = True
Case "/hidetrayicon"
$CmdLine_b_TrayIcon_Hide = True
Case "/cmd_exe"
If $CmdLine[0] >= $51 + 1 Then $CmdLine_s_Execute_CommandLine = $CmdLine[$51 + 1]
Case "/cmd_param"
If $CmdLine[0] >= $51 + 1 Then $CmdLine_s_Execute_Parameter = $CmdLine[$51 + 1]
Case "/cmd_always"
$CmdLine_b_Execute_Always = True
Case "/show"
$CmdLine_b_Show_GUI = True
EndSwitch
Next
Global $6u = _2r($6p)
If IniRead(@ScriptDir & "\HRC.ini", 'Settings', 'HRC_Version', "") <> $9 Then
IniWrite(@ScriptDir & "\HRC.ini", 'Settings', 'HRC_Version', $9)
_38(48 + 262144, "HRC - First StartUp", @CRLF & "If you are stuck with a disabled display, remember to use the forced HotKey" & @CRLF & @CRLF & """CTRL-ALT-SHIFT-R""" & @CRLF & @CRLF & "which will reset the display to the initial resolution and acts as an emergency fallback." & @CRLF & @CRLF & "If that does not work, restart the computer in safe-mode and reset the resolution manually." & @CRLF & @CRLF & "I share this program with NO WARRANTIES and NO LIABILITY FOR DAMAGES!" & @CRLF & @CRLF & "Take a look at the help-screen (?) for details on available command line parameters.")
EndIf
Opt('GuiOnEventMode', 1)
Global Const $6v = -1
Global Const $6w = -2
Global $6x[1][6]
Global $6y, $6z, $70, $71
Global $72, $73, $74, $75
Global $76
Global $77, $78, $79
Global $7a, $7b, $7c
Global $7d[10], $7e[10], $7f[10], $7g[10], $7h[10], $7i[10]
Global $7j, $7k
Global $7l, $7m
Global $7n
Global Const $7o = 0x0002
Global Const $7p = 0x00001000
Global Const $7q = 0x00000040
Global Const $7r = 0x00004000
Func _23($3r, $2v = 0)
Local $1s = dllcall($1, "handle", "GlobalAlloc", "uint", $2v, "ulong_ptr", $3r)
If @error Then Return SetError(@error, @extended, 0)
Return $1s[0]
EndFunc
Func _24($7s)
Local $1s = dllcall($1, "ptr", "GlobalLock", "handle", $7s)
If @error Then Return SetError(@error, @extended, 0)
Return $1s[0]
EndFunc
Func _25($7s)
Local $1s = dllcall($1, "bool", "GlobalUnlock", "handle", $7s)
If @error Then Return SetError(@error, @extended, 0)
Return $1s[0]
EndFunc
Func _26($7t, $6h, $7u, $7v)
Local $1s = dllcall($1, "ptr", "VirtualAlloc", "ptr", $7t, "ulong_ptr", $6h, "dword", $7u, "dword", $7v)
If @error Then Return SetError(@error, @extended, 0)
Return $1s[0]
EndFunc
Func _27($7t, $6h, $7w)
Local $1s = dllcall($1, "bool", "VirtualFree", "ptr", $7t, "ulong_ptr", $6h, "dword", $7w)
If @error Then Return SetError(@error, @extended, False)
Return $1s[0]
EndFunc
Global $7x = _26(0, 64, $7p, $7q)
Global $7y = _26(0, 64, $7p, $7q)
Global $7z = _26(0, 36, $7p, $7q)
Global Const $80 = "long x;long y"
Global Const $81 = "char dmDeviceName[32];ushort dmSpecVersion;ushort dmDriverVersion;short dmSize;" & "ushort dmDriverExtra;dword dmFields;" & $80 & ";dword dmDisplayOrientation;dword dmDisplayFixedOutput;" & "short dmColor;short dmDuplex;short dmYResolution;short dmTTOption;short dmCollate;" & "byte dmFormName[32];ushort LogPixels;dword dmBitsPerPel;int dmPelsWidth;dword dmPelsHeight;" & "dword dmDisplayFlags;dword dmDisplayFrequency"
Global $82
If Not _29() Then
_38(16 + 262144, "HRC - StartUp ERROR", "HRC can not aquire the initial display setting. This is needed as an emergency fallback. HRC will exit now.")
Exit
EndIf
_2b(1)
_2b()
_n()
Global $83, $84, $85
Global $86 = _u(39, 39, 5, 3, 1)
$39 = _2s(_2y(), True)
_t($86, $39)
_7($39)
TraySetClick(8)
Opt("TrayOnEventMode", 1)
Opt("TrayMenuMode", 3)
Opt("TrayAutoPause", 0)
TraySetOnEvent(-7, "_HRC_Recover")
$87 = TrayCreateItem("Restore")
TrayItemSetOnEvent(-1, "_HRC_Recover")
$88 = TrayCreateItem("Exit")
TrayItemSetOnEvent(-1, "_2h")
TrayCreateItem("")
Global $89[1]
TraySetToolTip('HRC - HotKey Resolution Changer')
_2n()
Global $8a
_2c()
GUIRegisterMsg($1h, "_2e")
If Not $CmdLine_b_TrayIcon_Hide And Not $CmdLine_b_Exit_After_Execution Then TraySetState()
Global $8b
If $CmdLine_i_TriggerID Then $8b = _2j(($CmdLine_i_TriggerID - 1) / 2)
If($8b Or $CmdLine_b_Execute_Always) And $CmdLine_s_Execute_CommandLine Then ShellExecute($CmdLine_s_Execute_CommandLine, $CmdLine_s_Execute_Parameter)
If $CmdLine_b_Exit_After_Execution Then _2h()
GUIRegisterMsg($1b, "_36")
If $CmdLine_b_Show_GUI Then _HRC_Recover()
AdlibRegister("_28", 3 * 60 * 1000)
While 1
Sleep(10)
If $4k Then
_2j($4k)
$4k = 0
EndIf
WEnd
Exit
Func _28()
_10()
_0z()
EndFunc
Func _29()
$82 = DllStructCreate($81)
DllStructSetData($82, "dmSize", DllStructGetSize($82))
Local $8c = DllCall($2, "int", "EnumDisplaySettingsEx", "ptr", 0, "dword", $6v, "ptr", DllStructGetPtr($82), "dword", 0)
If $8c[0] = 0 Then Return 0
Return 1
EndFunc
Func _2a()
Local Const $8d = 0xffff
Local Const $1c = 0x007E
Local Const $8e = 0x00000001
Local Const $8f = 0x00000002
Local $8c = DllCall($2, "int", "ChangeDisplaySettingsEx", "ptr", 0, "ptr", DllStructGetPtr($82), "hwnd", 0, "int", $8f, "ptr", 0)
$8c = DllCall($2, "int", "ChangeDisplaySettingsEx", "ptr", 0, "ptr", DllStructGetPtr($82), "hwnd", 0, "int", $8e, "ptr", 0)
_2p($8d, $1c, DllStructGetData($82, "dmBitsPerPel"), DllStructGetData($82, "dmPelsHeight") * 2 ^ 16 + DllStructGetData($82, "dmPelsWidth"))
EndFunc
Func _2b($8g = 0)
Local $8h = DllStructCreate($81)
DllStructSetData($8h, "dmSize", DllStructGetSize($8h))
Local $2v = 0
Local Const $8i = 0x00000002
Local Const $8j = 0x00000004
If Not $8g Then
If IniRead(@ScriptDir & "\HRC.ini", 'Settings', 'RAWMODE', 4) = 1 Then $2v = BitOR($2v, $8i)
If IniRead(@ScriptDir & "\HRC.ini", 'Settings', 'ROTATEDMODE', 4) = 1 Then $2v = BitOR($2v, $8j)
EndIf
$8k = DllCall($2, "int", "EnumDisplaySettingsEx", "ptr", 0, "dword", $6v, "ptr", DllStructGetPtr($8h), "dword", 0)
If $8k[0] = 0 Then
ConsoleWrite(@CRLF & "From reg" & @CRLF)
$8k = DllCall($2, "int", "EnumDisplaySettingsEx", "ptr", 0, "dword", $6w, "ptr", DllStructGetPtr($8h), "dword", 0)
EndIf
$6y = DllStructGetData($8h, "dmBitsPerPel")
$6z = DllStructGetData($8h, "dmPelsWidth")
$70 = DllStructGetData($8h, "dmPelsHeight")
$71 = DllStructGetData($8h, "dmDisplayFrequency")
If Not $g Then $g = $6z
If Not $h Then $h = $70
$8l = 0
$51 = 0
ReDim $6x[1000][6]
Local $8m, $8n
Do
$8k = DllCall($2, "int", "EnumDisplaySettingsEx", "ptr", 0, "dword", $8l, "ptr", DllStructGetPtr($8h), "dword", $2v)
$8k = $8k[0]
$8m = DllStructGetData($8h, "dmPelsWidth")
$8n = DllStructGetData($8h, "dmPelsHeight")
If $8g Then
If Not $f Then
If DllStructGetData($8h, "dmDisplayOrientation") Then $f = True
EndIf
EndIf
If Not BitAND($2v, $8j) Then
If $8n > $8m Then
$8l += 1
ContinueLoop
EndIf
EndIf
$6x[$51][0] = $8m
$6x[$51][1] = $8n
$6x[$51][2] = DllStructGetData($8h, "dmBitsPerPel")
$6x[$51][4] = DllStructGetData($8h, "dmDisplayFrequency")
Switch $6x[$51][2]
Case 1
$6x[$51][3] = "1 Bit - 2 colors"
Case 2
$6x[$51][3] = "2 Bit - 4 colors"
Case 3
$6x[$51][3] = "3 Bit - 8 colors"
Case 4
$6x[$51][3] = "4 Bit - 16 colors"
Case 5
$6x[$51][3] = "5 Bit - 32 colors"
Case 6
$6x[$51][3] = "6 Bit - 64 colors"
Case 8
$6x[$51][3] = "8 Bit - 256 colors"
Case 12
$6x[$51][3] = "12 Bit - 4.096 colors"
Case 16
$6x[$51][3] = "16 Bit - 65k colors"
Case 32
$6x[$51][3] = "32 Bit - 4 billion colors"
EndSwitch
$6x[$51][5] = StringFormat("%04i", $6x[$51][0]) & StringFormat("%04i", $6x[$51][1]) & StringFormat("%02i", $6x[$51][2]) & StringFormat("%03i", $6x[$51][4])
If $8k <> 0 Then
$8l += 1
$51 += 1
If Not Mod(1000, $51) Then ReDim $6x[UBound($6x) + 1000][6]
EndIf
Until $8k = 0
ReDim $6x[$51 + 1][6]
$8h = 0
_2q($6x, 0, True, 0, 0, 5)
$72 = ""
For $51 = 0 To UBound($6x) - 1
If Not StringInStr($72, $6x[$51][0] & " x " & $6x[$51][1]) Then $72 &= "|" & $6x[$51][0] & " x " & $6x[$51][1]
Next
$73 = ""
$74 = ""
For $51 = 0 To UBound($6x) - 1
If StringInStr($6z & " x " & $70, $6x[$51][0] & " x " & $6x[$51][1]) And Not StringInStr($73, $6x[$51][3]) Then $73 &= "|" & $6x[$51][3]
If $6x[$51][2] = $6y Then $74 = $6x[$51][3]
Next
$75 = ""
For $51 = 0 To UBound($6x) - 1
If $6z & " x " & $70 = $6x[$51][0] & " x " & $6x[$51][1] Then
If Not StringInStr($75, $6x[$51][4]) Then $75 &= "|" & $6x[$51][4] & " Hertz"
EndIf
Next
$7d[0] = IniRead(@ScriptDir & "\HRC.ini", 'Settings', 'NumberOfHotKeyBoxes', 2) + 1
EndFunc
Func _2c()
$8a = IniRead(@ScriptDir & "\HRC.ini", 'Settings', 'NumberOfHotKeyBoxes', 2) + 1
If IsHWnd($76) Then
For $51 = 1 To UBound($6n) - 1
_1d($6n[$51])
Next
EndIf
$76 = GUICreate($6q & " " & $6p, 420, 30 + 228 +(($8a - 3) * 80), Default, Default, BitOR($17, $15), BitOR($18, $1a, $19))
WinSetOnTop($76, '', 1)
GUISetOnEvent($u, "_2i")
_33($j + 8, 400, 0, $i)
ControlSetText($6u, '', ControlGetHandle($6u, '', 'Edit1'), $76)
GUICtrlCreateLabel("", 0, 0, 360, 24, 0, $10)
GUICtrlSetBkColor(-1, 0xEEF1F6)
GUICtrlCreateLabel("", 0, 21, 421, 1)
GUICtrlSetBkColor(-1, 0x434343)
$6r = GUICtrlCreateLabel($6q, 25, 3, 320, 20, 0, $10)
GUICtrlSetBkColor(-1, $0z)
_32(-1, $j + 9, 800, 0, $i)
GUICtrlCreateIcon(@ScriptName, -1, 3, 3, 16, 16)
$8o = GUICtrlCreatePic("", 360, 3, 16, 16)
GUICtrlSetCursor(-1, 0)
GUICtrlSetTip(-1, "Help")
GUICtrlSetOnEvent(-1, "_2m")
$39 = _2s(_2x(), True)
_7(GUICtrlSendMsg($8o, $6s, $k, $39))
_7($39)
$8p = GUICtrlCreatePic("", 380, 3, 16, 16)
GUICtrlSetCursor(-1, 0)
GUICtrlSetTip(-1, "Minimize to tray")
GUICtrlSetOnEvent(-1, "_2i")
$39 = _2s(_2w(), True)
_7(GUICtrlSendMsg($8p, $6s, $k, $39))
_7($39)
$8q = GUICtrlCreatePic("", 400, 3, 16, 16)
GUICtrlSetCursor(-1, 0)
GUICtrlSetTip(-1, "Exit HCR")
GUICtrlSetOnEvent(-1, "_2h")
$39 = _2s(_2v(), True)
_7(GUICtrlSendMsg($8q, $6s, $k, $39))
_7($39)
GUICtrlCreateLabel("", 0, 22, 420, 40 + 210 - 22 +(($8a - 3) * 80) + 20)
GUICtrlSetState(-1, $x)
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUICtrlCreateLabel("Number of HotKeys", 7, 187 +(($8a - 3) * 80), 90, 17)
GUICtrlSetColor(-1, 0xA7A6AA)
GUICtrlSetBkColor(-1, $0z)
_32(-1, $j + 8, 400, 0, $i)
GUICtrlSetTip(-1, "Select the number of resolution hotkey combos to customize")
GUICtrlSetCursor(-1, 0)
$7a = GUICtrlCreateCombo("", 105, 184 +(($8a - 3) * 80), 45, 20, BitOR($q, $14))
GUICtrlSetOnEvent(-1, '_2k')
_32(-1, $j + 8, 800, 0, $i)
GUICtrlSetData(-1, "2|3|4|5|6|7|8|9", $8a - 1)
GUICtrlCreateLabel("CTRL-ALT-R", 210 - 40 - 4, 1 + 182 +(($8a - 3) * 80), 210, 17)
_32(-1, $j + 6.8, 400, 0, $i)
GUICtrlSetBkColor(-1, $0z)
GUICtrlSetColor(-1, 0xA7A6AA)
GUICtrlCreateLabel("- recover from tray", 210 - 40 - 4 + 85, 1 + 182 +(($8a - 3) * 80), 210, 17)
_32(-1, $j + 6.8, 400, 0, $i)
GUICtrlSetBkColor(-1, $0z)
GUICtrlSetColor(-1, 0xA7A6AA)
GUICtrlCreateLabel("CTRL-ALT-SHIFT-R", 210 - 40 - 4, 1 + 12 + 182 +(($8a - 3) * 80), 270, 17)
_32(-1, $j + 6.8, 400, 0, $i)
GUICtrlSetBkColor(-1, $0z)
GUICtrlSetColor(-1, 0xA7A6AA)
GUICtrlCreateLabel("- initial resolution", 210 - 40 - 4 + 85, 1 + 12 + 182 +(($8a - 3) * 80), 270, 17)
_32(-1, $j + 6.8, 400, 0, $i)
GUICtrlSetBkColor(-1, $0z)
GUICtrlSetColor(-1, 0xA7A6AA)
GUICtrlCreateLabel("Default Orientation", 7, 2 +(($8a - 3) * 80) + 210, 90, 14)
_32(-1, $j + 8, 400, 0, $i)
GUICtrlSetBkColor(-1, $0z)
GUICtrlSetColor(-1, 0xA7A6AA)
If Not $f Then
GUICtrlSetState(-1, $x)
GUICtrlSetTip(-1, "Portrait format resolutions does not seem to be supported by your monitor")
Else
GUICtrlSetCursor(-1, 0)
GUICtrlSetTip(-1, "Set the default rotation to use for portrait format resolutions")
EndIf
$7n = GUICtrlCreateCombo("", 105, 2 +(($8a - 3) * 80) + 210 - 4, 45, 20, BitOR($q, $14))
_32(-1, $j + 8, 800, 0, $i)
GUICtrlSetOnEvent(-1, '_2k')
GUICtrlSetData(-1, "090|270", IniRead(@ScriptDir & "\HRC.ini", 'Settings', 'Default_Orientation', "090"))
If Not $f Then
GUICtrlSetState(-1, $x)
GUICtrlSetTip(-1, "Portrait format resolutions does not seem to be supported by your monitor")
Else
GUICtrlSetTip(-1, "Set the default rotation to use for portrait format resolutions")
EndIf
Local $8r = "If set, HRC will return all graphics modes reported by the adapter driver, regardless of monitor capabilities." & @CRLF & "Otherwise, HRC will only return modes that are compatible with current monitors."
$7j = GUICtrlCreateCheckbox("", 210 - 40 - 4, 2 +(($8a - 3) * 80) + 210, 14, 14)
GUICtrlSetCursor(-1, 0)
GUICtrlSetTip(-1, $8r)
GUICtrlSetOnEvent(-1, '_2k')
GUICtrlSetState($7j, IniRead(@ScriptDir & "\HRC.ini", 'Settings', 'RAWMODE', 4))
$7k = GUICtrlCreateLabel(" Rawmode", 224 - 40 - 4, 2 +(($8a - 3) * 80) + 210, 52, 14)
_32(-1, $j + 8, 400, 0, $i)
GUICtrlSetBkColor(-1, $0z)
GUICtrlSetColor(-1, 0xA7A6AA)
GUICtrlSetCursor(-1, 0)
GUICtrlSetTip(-1, $8r)
$8r = "If set, HRC will return graphics modes in all orientations." & @CRLF & "Otherwise, HRC will only return modes that have the same orientation as the one currently set for the requested display."
$7l = GUICtrlCreateCheckbox("", 310 - 63, 2 +(($8a - 3) * 80) + 210, 14, 14)
If Not $f Then
GUICtrlSetState(-1, $x)
GUICtrlSetTip(-1, "Portrait format resolutions does not seem to be supported by your monitor")
Else
GUICtrlSetOnEvent(-1, '_2k')
GUICtrlSetState($7l, IniRead(@ScriptDir & "\HRC.ini", 'Settings', 'ROTATEDMODE', 4))
GUICtrlSetCursor(-1, 0)
GUICtrlSetTip(-1, $8r)
EndIf
$7m = GUICtrlCreateLabel(" Rotatedmode", 324 - 63, 2 +(($8a - 3) * 80) + 210, 68, 14)
_32(-1, $j + 8, 400, 0, $i)
GUICtrlSetBkColor(-1, $0z)
GUICtrlSetColor(-1, 0xA7A6AA)
If Not $f Then
GUICtrlSetState(-1, $x)
GUICtrlSetTip(-1, "Portrait format resolutions does not seem to be supported by your monitor")
Else
GUICtrlSetTip(-1, $8r)
GUICtrlSetCursor(-1, 0)
EndIf
$78 = GUICtrlCreatePic("", 10, 2 + 234 +(($8a - 3) * 80), 80, 15, $11)
GUICtrlSetCursor($78, 0)
GUICtrlSetBkColor(-1, 0x00ff00)
GUICtrlCreateLabel("For support visit ", 140 - 7, 5 + 234 +(($8a - 3) * 80), 74, 17)
_32(-1, $j + 7, 400, 0, $i)
GUICtrlSetBkColor(-1, $0z)
GUICtrlSetColor(-1, 0xA7A6AA)
$77 = GUICtrlCreateLabel('http://www.funk.eu', 213 - 7, 5 + 234 +(($8a - 3) * 80), 78, 17)
_32(-1, $j + 7, 400, 0, $i)
GUICtrlSetBkColor(-1, $0z)
GUICtrlSetColor(-1, 0x1111CC)
GUICtrlSetCursor(-1, 0)
$79 = GUICtrlCreatePic("", 310, 233 +(($8a - 3) * 80), 100, 20, $11)
GUICtrlSetCursor($79, 0)
GUICtrlSetBkColor(-1, 0x00ff00)
Local $8s = _2s(_2z(), True)
_7(GUICtrlSendMsg($78, $6s, $k, $8s))
_7($8s)
Local $8t = _2s(_30(), True)
_7(GUICtrlSendMsg($79, $6s, $k, $8t))
_7($8t)
ReDim $6n[$8a]
ReDim $6o[$8a]
Local $8u
For $8v = 1 To GUICtrlRead($7a)
GUICtrlCreateLabel("", 6, 28 +(($8v - 1) * 80), 408, 71)
GUICtrlSetState(-1, $x)
GUICtrlSetBkColor(-1, 0xababab)
GUICtrlCreateLabel("", 7, 29 +(($8v - 1) * 80), 406, 69)
GUICtrlSetState(-1, $x)
GUICtrlSetBkColor(-1, 0xEEF1F6)
If $8v = 1 Then
$7c = GUICtrlCreateButton("Refresh supported resolutions", 247, 32, 160, 15)
_32(-1, $j + 7, 400, 0, $i)
GUICtrlSetOnEvent(-1, '_2k')
EndIf
GUICtrlCreateLabel("Hotkey", 16, 32 +(($8v - 1) * 80) + 2, 35, 15)
_32(-1, $j + 7, 800, 0, $i)
$6n[$8v] = _1c(IniRead(@ScriptDir & "\HRC.ini", 'Settings', 'HotkeyInput' & $8v, "0x0000"), 16 + 35, 32 +(($8v - 1) * 80), 60, 15)
GUICtrlSetBkColor(-1, 0xFFFED8)
_32(-1, $j + 7, 800, 0, $i)
GUICtrlSetState(-1, $x)
$6o[$8v] = GUICtrlCreateButton("Change", 115, 32 +(($8v - 1) * 80), 50, 15)
_32(-1, $j + 7, 800, 0, $i)
$7d[$8v] = GUICtrlCreateCombo("", 15, 50 +(($8v - 1) * 80), 210, 25, BitOR($q, $14))
GUICtrlSetOnEvent(-1, '_2k')
_32(-1, $j + 22, 800, 0, $i)
_s($7d[$8v], 50, 500)
$7h[$8v] = GUICtrlCreateCombo("", 230, 50 +(($8v - 1) * 80), 127, 20, BitOR($q, $14))
_32(-1, $j + 7, 400, 0, $i)
$7g[$8v] = GUICtrlCreateCombo("", 230, 71 +(($8v - 1) * 80), 127, 20, BitOR($q, $14))
_32(-1, $j + 7, 400, 0, $i)
$7i[$8v] = GUICtrlCreateButton("", 367, 50 +(($8v - 1) * 80), 39, 39, $l)
_x($7i[$8v], $86, 4)
GUICtrlSetCursor(-1, 0)
$8u = IniRead(@ScriptDir & "\HRC.ini", 'Settings', 'Res' & $8v, "")
_q($7d[$8v])
If StringInStr($72, $8u) Then
GUICtrlSetData($7d[$8v], $72, $8u)
Else
GUICtrlSetData($7d[$8v], $72, $6z & " x " & $70)
EndIf
_r($7d[$8v])
$7e[$8v] = GUICtrlRead($7d[$8v])
$73 = ""
$74 = ""
For $51 = 0 To UBound($6x) - 1
If StringInStr($7e[$8v], $6x[$51][0] & " x " & $6x[$51][1]) And Not StringInStr($73, $6x[$51][3]) Then $73 &= "|" & $6x[$51][3]
If $6x[$51][2] = $6y Then $74 = $6x[$51][3]
Next
$75 = ""
For $51 = 0 To UBound($6x) - 1
If StringInStr($73, $6x[$51][3]) And StringInStr($7e[$8v], $6x[$51][0] & " x " & $6x[$51][1]) And Not StringInStr($75, $6x[$51][4]) Then $75 &= "|" & $6x[$51][4] & " Hertz"
Next
$8u = IniRead(@ScriptDir & "\HRC.ini", 'Settings', 'Col' & $8v, "")
If StringInStr($73, $8u) Then
GUICtrlSetData($7h[$8v], $73, $8u)
Else
GUICtrlSetData($7h[$8v], $73, $74)
EndIf
$8u = IniRead(@ScriptDir & "\HRC.ini", 'Settings', 'Fre' & $8v, "")
If StringInStr($75, $8u) Then
GUICtrlSetData($7g[$8v], $75, $8u)
Else
GUICtrlSetData($7g[$8v], $75, $71 & " Hertz")
EndIf
$7e[$8v] = GUICtrlRead($7d[$8v])
Next
$7b = GUICtrlRead($7a)
_11()
For $8v = 1 To GUICtrlRead($7a)
_2f($6n[$8v])
Next
_2d()
EndFunc
Func _2d()
For $51 = 1 To UBound($89) - 1
TrayItemDelete($89[$51])
Next
$8a = IniRead(@ScriptDir & "\HRC.ini", 'Settings', 'NumberOfHotKeyBoxes', 2) + 1
ReDim $89[$8a]
For $8v = 1 To GUICtrlRead($7a)
$89[$8v] = TrayCreateItem($8v & ": " & GUICtrlRead($7d[$8v]) & " @ " & StringReplace(GUICtrlRead($7g[$8v]), "Hertz", "Hz"))
TrayItemSetOnEvent(-1, "_2l")
Next
EndFunc
Func _2e($20, $8w, $22, $23)
$8x = BitShift($22, 16)
$8y = BitAND($22, 0x0000FFFF)
$8z = $23
Switch $8y
Case $7k
ControlClick($76, "", $7j)
Return $v
Case $7m
If $f Then ControlClick($76, "", $7l)
Return $v
Case $77
ShellExecute('http://www.funk.eu')
Return $v
Case $79
ShellExecute("https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=donate%40funk%2eeu&item_name=Thank%20you%20for%20your%20donation%20to%20HRC...&no_shipping=0&no_note=1&tax=0&currency_code=EUR&lc=US&bn=PP%2dDonationsBF&charset=UTF%2d8")
Return $v
Case $78
ShellExecute("http://creativecommons.org/licenses/by-nc-nd/3.0/us/")
Return $v
EndSwitch
For $8v = 1 To UBound($6n) - 1
Switch $8y
Case $7d[$8v], $7h[$8v], $7g[$8v]
If $8x = 1 Then
_2g()
_2d()
EndIf
If $8x = 8 Then _e(ControlGetHandle($76, "", $8y))
Return $v
Case $6n[$8v]
Switch $8x
Case 256
_11()
Return $v
Case 512
ControlClick($76, '', $6o[$8v])
Return $v
EndSwitch
Return $v
Case $6o[$8v]
Switch GUICtrlRead($6o[$8v])
Case "Change"
GUICtrlSetData($6o[$8v], "Set")
GUICtrlSetState($6n[$8v], $w)
GUICtrlSetState($6n[$8v], $y)
Return $v
Case "Set"
GUICtrlSetData($6o[$8v], "Change")
GUICtrlSetState($6n[$8v], $x)
GUICtrlSetState($6r, $y)
_2f($6n[$8v])
Return $v
EndSwitch
Return $v
Case $7i[$8v]
_2j($8v)
Return $v
EndSwitch
Next
Return $v
EndFunc
Func _2f($8y)
Local $90 = ""
For $8v = 1 To UBound($6n) - 1
If $8y = $6n[$8v] Then ContinueLoop
$90 &= '0x' & StringRight(Hex(_1e($6n[$8v])), 4) & ", "
Next
If StringInStr($90, '0x' & StringRight(Hex(_1e($8y)), 4)) Then GUICtrlSetData($8y, "None")
For $8v = 1 To UBound($6n) - 1
_y('0x' & StringRight(Hex(_1e($6n[$8v])), 4), '_ApplySettingsHK', BitOR($4s, $4q))
IniWrite(@ScriptDir & "\HRC.ini", 'Settings', 'HotkeyInput' & $8v, '0x' & StringRight(Hex(_1e($6n[$8v])), 4))
Next
_y(0x0652, '_HRC_Recover')
_y(0x0752, '_Initial_DEVMODE_HotKey')
EndFunc
Func _2g()
For $51 = 1 To UBound($7d) - 1
If GUICtrlRead($7d[$51]) Then IniWrite(@ScriptDir & "\HRC.ini", 'Settings', 'Res' & $51, GUICtrlRead($7d[$51]))
If GUICtrlRead($7h[$51]) Then IniWrite(@ScriptDir & "\HRC.ini", 'Settings', 'Col' & $51, GUICtrlRead($7h[$51]))
If GUICtrlRead($7g[$51]) Then IniWrite(@ScriptDir & "\HRC.ini", 'Settings', 'Fre' & $51, GUICtrlRead($7g[$51]))
Next
EndFunc
Func _2h()
AdlibUnRegister("_28")
IniWrite(@ScriptDir & "\HRC.ini", 'Settings', 'NumberOfHotKeyBoxes', GUICtrlRead($7a))
IniWrite(@ScriptDir & "\HRC.ini", 'Settings', 'Default_Orientation', GUICtrlRead($7n))
_2g()
_27($7x, 64, $7r)
_27($7y, 64, $7r)
_27($7z, 36, $7r)
_m()
_v($86)
DllClose($0)
DllClose($1)
DllClose($2)
DllClose($3)
DllClose($4)
DllClose($5)
DllClose($6)
DllClose($7)
DllClose($8)
Exit
EndFunc
Func _2i()
GUISetState(@SW_HIDE, $76)
EndFunc
Func _HRC_Recover()
If BitAND(WinGetState($76, ''), 2) Then
GUISetState(@SW_HIDE, $76)
Else
GUISetState(@SW_SHOW, $76)
EndIf
EndFunc
Func _ApplySettingsHK($4w = 0)
If $4k Then Return
For $8v = 1 To GUICtrlRead($7a)
If '0x' & StringRight(Hex(_1e($6n[$8v])), 4) = '0x' & Hex($4w, 4) Then ExitLoop
Next
$4k = $8v
EndFunc
Func _2j($91 = 0)
Local $92 = 0
If $91 = 10 Then
$92 = _2a()
ElseIf $91 > 0 Then
Local $3c = StringLeft(GUICtrlRead($7d[$91]), StringInStr(GUICtrlRead($7d[$91]), " ") - 1)
Local $3d = StringRight(GUICtrlRead($7d[$91]), StringLen(GUICtrlRead($7d[$91])) - StringInStr(GUICtrlRead($7d[$91]), " ", 0, -1))
Local $93 = StringLeft(GUICtrlRead($7h[$91]), StringInStr(GUICtrlRead($7h[$91]), " ") - 1)
Local $94 = StringLeft(GUICtrlRead($7g[$91]), StringInStr(GUICtrlRead($7g[$91]), " ") - 1)
$92 = _2o($3c, $3d, $93, $94)
Local $95 = @error
If $92 <> 0 Then
Local Const $96 = 0
Local Const $97 = -1
Local Const $98 = -2
Local Const $99 = -3
Local Const $9a = -4
Local Const $9b = -5
Local Const $9c = -6
Local Const $9d = 1
Local $9e, $9f
Switch $92
Case 1
$9e = "EnumDisplaySettingsEx"
Switch $95
Case 1
$9f = "1 - Error calling function"
Case 2
$9f = "2 - Function returned 0"
EndSwitch
Case Else
$9e = "ChangeDisplaySettingsEx "
If $92 = 2 Then
$9e &= "1"
Else
$9e &= "2"
EndIf
Switch $95
Case 2
$9f = "2 - Error calling function"
Case $96
$9f = $96 & " (DISP_CHANGE_SUCCESSFUL)"
Case $97
$9f = $97 & " (DISP_CHANGE_FAILED)"
Case $98
$9f = $98 & " (DISP_CHANGE_BADMODE)"
Case $99
$9f = $99 & " (DISP_CHANGE_NOTUPDATED)"
Case $9a
$9f = $9a & " (DISP_CHANGE_BADFLAGS)"
Case $9b
$9f = $9b & " (DISP_CHANGE_BADPARAM)"
Case $9c
$9f = $9c & " (DISP_CHANGE_BADDUALVIEW)"
Case $9d
$9f = $9d & " (DISP_CHANGE_RESTART)"
EndSwitch
EndSwitch
_38(64 + 262144, "HRC Error", "Unable to change screen resolution" & @CRLF & @CRLF & _
"Error function call: " & @CRLF & $9e & @CRLF & @CRLF & _
"Error code: " & @CRLF & $9f & @CRLF & @CRLF & _
"Requested Settings:" & @CRLF & @CRLF & "Width: " & $3c & @CRLF & "Height: " & $3d & @CRLF & "BitsPP: " & $93 & @CRLF & "Refresh Rate: " & $94)
EndIf
EndIf
_e($76)
If Not $92 Then Return 1
EndFunc
Func _2k()
Switch @GUI_CtrlId
Case $7n
IniWrite(@ScriptDir & "\HRC.ini", 'Settings', 'Default_Orientation', GUICtrlRead($7n))
Return
Case $7a Or $7c Or $7j Or $7l
IniWrite(@ScriptDir & "\HRC.ini", 'Settings', 'RAWMODE', GUICtrlRead($7j))
IniWrite(@ScriptDir & "\HRC.ini", 'Settings', 'ROTATEDMODE', GUICtrlRead($7l))
If GUICtrlRead($7a) <> $7b Or @GUI_CtrlId = $7c Or @GUI_CtrlId = $7j Or @GUI_CtrlId = $7l Then
If @GUI_CtrlId = $7c Or @GUI_CtrlId = $7j Or @GUI_CtrlId = $7l Then
_2b()
EndIf
GUISetState(@SW_LOCK, $76)
Local $9g = $76
For $51 = 1 To UBound($7d) - 1
If GUICtrlRead($7d[$51]) Then IniWrite(@ScriptDir & "\HRC.ini", 'Settings', 'Res' & $51, GUICtrlRead($7d[$51]))
If GUICtrlRead($7h[$51]) Then IniWrite(@ScriptDir & "\HRC.ini", 'Settings', 'Col' & $51, GUICtrlRead($7h[$51]))
If GUICtrlRead($7g[$51]) Then IniWrite(@ScriptDir & "\HRC.ini", 'Settings', 'Fre' & $51, GUICtrlRead($7g[$51]))
Next
IniWrite(@ScriptDir & "\HRC.ini", 'Settings', 'NumberOfHotKeyBoxes', GUICtrlRead($7a))
_2c()
_2g()
GUIDelete($9g)
GUISetState(@SW_SHOW, $76)
Return
EndIf
EndSwitch
Local $91 = 0
For $51 = 1 To UBound($7d) - 1
If @GUI_CtrlId = $7d[$51] Then
$91 = $51
ExitLoop
EndIf
Next
If $91 > 0 Then
If GUICtrlRead($7d[$91]) <> $7e[$91] Then
$7e[$91] = GUICtrlRead($7d[$91])
$73 = ""
$74 = ""
For $51 = 0 To UBound($6x) - 1
If StringInStr($7e[$91], $6x[$51][0] & " x " & $6x[$51][1]) And Not StringInStr($73, $6x[$51][3]) Then $73 &= "|" & $6x[$51][3]
If $6x[$51][2] = $6y Then $74 = $6x[$51][3]
Next
If StringInStr($73, "|" & GUICtrlRead($7h[$91])) Then
GUICtrlSetData($7h[$91], $73, GUICtrlRead($7h[$91]))
Else
GUICtrlSetData($7h[$91], $73, StringMid($73, 2, StringInStr($73, "|", 0, 2) - 2))
EndIf
$75 = ""
For $51 = 0 To UBound($6x) - 1
If StringInStr($73, $6x[$51][3]) Then
If $7e[$91] = $6x[$51][0] & " x " & $6x[$51][1] Then
If Not StringInStr($75, $6x[$51][4]) Then $75 &= "|" & $6x[$51][4] & " Hertz"
EndIf
EndIf
Next
If StringInStr($75, "|" & GUICtrlRead($7g[$91])) Then
GUICtrlSetData($7g[$91], $75, GUICtrlRead($7g[$91]))
Else
GUICtrlSetData($7g[$91], $75, StringMid($75, 2, StringInStr($75, "|", 0, 2) - 2))
EndIf
$7d[0] = IniRead(@ScriptDir & "\HRC.ini", 'Settings', 'NumberOfHotKeyBoxes', 2) + 1
_e($76)
EndIf
EndIf
EndFunc
Func _2l()
Local $91 = 0
For $51 = 1 To UBound($89) - 1
If @TRAY_ID = $89[$51] Then
$91 = $51
ExitLoop
EndIf
Next
If $91 Then _2j($91)
EndFunc
Func _2m()
Opt('GuiOnEventMode', 0)
GUISetState(@SW_HIDE, $76)
GUISetState(@SW_SHOW, $83)
While 1
Switch GUIGetMsg()
Case $u
ExitLoop
Case $84
ShellExecute("http://creativecommons.org/licenses/by-nc-sa/3.0/", "", "", "open")
Case $85
ShellExecute("http://funk.eu", "", "", "open")
EndSwitch
WEnd
GUISetState(@SW_HIDE, $83)
Opt('GuiOnEventMode', 1)
GUISetState(@SW_SHOW, $76)
EndFunc
Func _2n()
$83 = GUICreate($6q, 600, 330, Default, Default, $13)
_33($j + 8, 400, 0, $i)
GUISetBkColor(0xEEF1F6)
WinSetOnTop($83, "", 1)
$85 = GUICtrlCreateButton("", 20, 20 + 20, 39, 39, $l)
_x(-1, $86, 4)
GUICtrlSetCursor(-1, 0)
GUICtrlCreateLabel($6q, 80 + 10, 10, 380, 20)
_32(-1, $j + 9, 800, 0, $i)
GUICtrlCreateLabel('This program is freeware under a Creative Commons License "by-nc-sa 3.0":', 80 + 10, 40 - 10, 380, 20)
GUICtrlCreateLabel('- Attribution' & @CRLF _
& '- Noncommercial' & @CRLF _
& '- Share Alike', 80 + 20, 60 - 10, 380, 50)
_32(-1, $j + 8.5, 800, 0, $i)
GUICtrlCreateLabel('Visit                                                                               for details.', 80 + 10, 110 - 10, 380, 20)
GUICtrlSetBkColor(-1, $0z)
$84 = GUICtrlCreateLabel("http://creativecommons.org/licenses/by-nc-sa/3.0/", 80 + 34, 110 - 10, 230, 20)
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
& '', 10, 140, 575, 140, BitOR($14, $1v))
EndFunc
Func _2o($9h = @DesktopWidth, $9i = @DesktopHeight, $9j = @DesktopDepth, $9k = @DesktopRefresh)
Local Const $9l = 0x00000001
Local Const $9m = 0x00000002
Local Const $9n = 0x00000004
Local Const $9o = 0x00000008
Local Const $9p = 0x00000010
Local Const $9q = 0x00000100
Local Const $9r = 0x00000200
Local Const $9s = 0x00000400
Local Const $9t = 0x00000020
Local Const $9u = 0x00000080
Local Const $9v = 0x20000000
Local Const $9w = 0x00000800
Local Const $9x = 0x00001000
Local Const $9y = 0x00002000
Local Const $9z = 0x00004000
Local Const $a0 = 0x00008000
Local Const $a1 = 0x00010000
Local Const $a2 = 0x00020000
Local Const $a3 = 0x00040000
Local Const $a4 = 0x00080000
Local Const $a5 = 0x00100000
Local Const $a6 = 0x00200000
Local Const $a7 = 0x00000040
Local Const $a8 = 0x00400000
Local Const $a9 = 0x00800000
Local Const $aa = 0x01000000
Local Const $ab = 0x02000000
Local Const $ac = 0x04000000
Local Const $ad = 0x08000000
Local Const $ae = 0x10000000
Local Const $af = 0x01000000
Local Const $8f = 0x00000002
Local Const $8e = 0x00000001
Local Const $ag = 0x40000000
Local Const $ah = 0x00000010
Local Const $ai = 0x00000020
Local Const $aj = 0x00000100
Local Const $ak = 0x00000200
Local Const $96 = 0
Local Const $97 = -1
Local Const $98 = -2
Local Const $99 = -3
Local Const $9a = -4
Local Const $9b = -5
Local Const $9c = -6
Local Const $9d = 1
Local Const $8d = 0xffff
Local Const $1c = 0x007E
If $9h = "" Or $9h = -1 Then $9h = @DesktopWidth
If $9i = "" Or $9i = -1 Then $9i = @DesktopHeight
If $9j = "" Or $9j = -1 Then $9j = @DesktopDepth
If $9k = "" Or $9k = -1 Then $9k = @DesktopRefresh
Local $8h = DllStructCreate($81)
DllStructSetData($8h, "dmSize", DllStructGetSize($8h))
Local $8c = DllCall($2, "int", "EnumDisplaySettingsEx", "ptr", 0, "dword", $6v, "ptr", DllStructGetPtr($8h), "dword", 0)
If $8c[0] = 0 Then
$8c = DllCall($2, "int", "EnumDisplaySettingsEx", "ptr", 0, "dword", $6w, "ptr", DllStructGetPtr($8h), "dword", 0)
EndIf
If @error Then
$8h = 0
SetError(1)
Return 1
Else
$8c = $8c[0]
EndIf
If $8c <> 0 Then
DllStructSetData($8h, "dmPelsWidth", $9h)
DllStructSetData($8h, "dmPelsHeight", $9i)
DllStructSetData($8h, "dmBitsPerPel", $9j)
DllStructSetData($8h, "dmDisplayFrequency", $9k)
If $f Then
If $9i < $9h Then
If IniRead(@ScriptDir & "\HRC.ini", 'Settings', 'Default_Orientation', "090") = "090" Then
DllStructSetData($8h, "dmDisplayOrientation", $b)
Else
DllStructSetData($8h, "dmDisplayOrientation", $c)
EndIf
Else
DllStructSetData($8h, "dmFields", BitOR($9t, $a4, $a5, $a3, $a8))
EndIf
Else
DllStructSetData($8h, "dmFields", BitOR($9t, $a4, $a5, $a3, $a8))
EndIf
$8c = DllCall($2, "int", "ChangeDisplaySettingsEx", "ptr", 0, "ptr", DllStructGetPtr($8h), "hwnd", 0, "int", $8f, "ptr", 0)
If @error Then
$8h = 0
SetError(2)
Return 2
Else
$8c = $8c[0]
EndIf
Select
Case $8c = $96
$8c = DllCall($2, "int", "ChangeDisplaySettingsEx", "ptr", 0, "ptr", DllStructGetPtr($8h), "hwnd", 0, "int", $8e, "ptr", 0)
If @error Then
$8h = 0
SetError(2)
Return 3
Else
$8c = $8c[0]
EndIf
If $8c <> $96 Then
$8h = 0
SetError($8c)
Return 3
EndIf
WinMove($76, "", @DesktopWidth / 2 -(420 / 2), @DesktopHeight / 2 -((228 +(($8a - 3) * 80)) / 2))
_2p($8d, $1c, $9j, $9i * 2 ^ 16 + $9h)
Return 0
Case Else
$8h = 0
SetError($8c)
Return 2
EndSelect
EndIf
$8h = 0
SetError(2)
Return 1
EndFunc
Func _2p($20, $21, $22 = 0, $23 = 0)
Local $4j = DllCall($2, "lresult", "SendMessageTimeout", _
"hwnd", $20, _
"uint", $21, _
"wparam", $22, _
"lParam", $23, _
"uint", $d, _
"uint", $e, _
"dword_ptr*", 0)
Return $4j[7]
EndFunc
Func _2q(ByRef $al, $am = 1, $an = False, $ao = 0, $ap = 0, $aq = 0, $ar = 4095)
If @AutoItX64 Then Return SetError(64, 0, 0)
Local $as = UBound($al, 0)
If @error Or $as > 2 Then Return SetError(1, 0, 0)
Local $at = UBound($al, 1), $au = UBound($al, 2)
If $at < 2 Then Return SetError(1, 0, 0)
If $ap < 1 Or $ap > $at - 1 Then $ap = $at - 1
If($ap - $ao < 2) Then Return SetError(2, 0, 0)
If $as = 2 And($au - $aq < 0) Then Return SetError(2, 0, 0)
If $ar < 1 Then Return SetError(2, 0, 0)
Local $51, $52, $av = $ap - $ao + 1, $aw, $ax, $ay = ChrW(0), $az, $b0 = 'byte[', $b1, $b2, $b3
Local $b4 = DllStructCreate('byte[64]', $7x)
Local $b5 = DllStructCreate('byte[64]', $7y)
If $0 = -1 Then Return SetError(3, 0, 0)
Switch $am
Case 0
$aw = True
$b3 = DllStructCreate('byte[36]', $7z)
DllStructSetData($b3, 1, '0x8B4C24048B542408DD01DC1ADFE0F6C440750D80E441740433C048C333C040C333C0C3')
DllStructSetData($b5, 1, '0xBA' & Hex(Binary(DllStructGetPtr($b3)), 8) & '8B4424088B4C2404FF30FF31FFD283C408C3')
DllStructSetData($b4, 1, '0x8B7424048B7C24088B4C240C8B442410893789470483C60883C708404975F1C21000')
Case 1, 2
$az = "_strcmpi"
If $am = 2 Then $az = "strcmp"
$ax = DllCall($1, 'ptr', 'GetModuleHandle', 'str', 'msvcrt.dll')
$ax = DllCall($1, 'ptr', 'GetProcAddress', 'ptr', $ax[0], 'str', $az)
If $ax[0] = 0 Then Return SetError(3, 0, 1)
DllStructSetData($b5, 1, '0xBA' & Hex(Binary($ax[0]), 8) & '8B4424088B4C2404FF30FF31FFD283C408C3')
DllStructSetData($b4, 1, '0x8B7424048B7C24088B4C240C8B542410893789570483C7088A064684C075F9424975EDC21000')
Case 3
$b0 = 'wchar['
$ax = DllCall($1, 'ptr', 'GetModuleHandle', 'str', 'kernel32.dll')
$ax = DllCall($1, 'ptr', 'GetProcAddress', 'ptr', $ax[0], 'str', 'CompareStringW')
If $ax[0] = 0 Then Return SetError(3, 0, 1)
DllStructSetData($b5, 1, '0xBA' & Hex(Binary($ax[0]), 8) & '8B4424088B4C24046AFFFF306AFFFF3168000000006800040000FFD283E802C3')
DllStructSetData($b4, 1, '0x8B7424048B7C24088B4C240C8B542410893789570483C7080FB70683C60285C075F6424975EAC21000')
Case Else
Return SetError(2, 0, 0)
EndSwitch
If $aw Then
$b1 = DllStructCreate('double[' & $av & ']')
If $as = 1 Then
For $51 = 1 To $av
DllStructSetData($b1, 1, $al[$ao + $51 - 1], $51)
Next
Else
For $51 = 1 To $av
DllStructSetData($b1, 1, $al[$ao + $51 - 1][$aq], $51)
Next
EndIf
Else
Local $b6 = ""
If $as = 1 Then
For $51 = $ao To $ap
$b6 &= StringLeft($al[$51], $ar) & $ay
Next
Else
For $51 = $ao To $ap
$b6 &= StringLeft($al[$51][$aq], $ar) & $ay
Next
EndIf
$b1 = DllStructCreate($b0 & StringLen($b6) + 1 & ']')
DllStructSetData($b1, 1, $b6)
$b6 = ""
EndIf
$b2 = DllStructCreate('int[' & $av * 2 & ']')
DllCall($2, 'uint', 'CallWindowProc', 'ptr', DllStructGetPtr($b4), 'ptr', DllStructGetPtr($b1), 'ptr', DllStructGetPtr($b2), 'int', $av, 'int', $ao)
DllCall($0, 'none:cdecl', 'qsort', 'ptr', DllStructGetPtr($b2), 'int', $av, 'int', 8, 'ptr', DllStructGetPtr($b5))
Local $b7 = $al, $b8
If $as = 1 Then
If $an Then
For $51 = 0 To $av - 1
$b8 = DllStructGetData($b2, 1, $51 * 2 + 2)
$al[$ap - $51] = $b7[$b8]
Next
Else
For $51 = $ao To $ap
$b8 = DllStructGetData($b2, 1,($51 - $ao) * 2 + 2)
$al[$51] = $b7[$b8]
Next
EndIf
Else
If $an Then
For $51 = 0 To $av - 1
$b8 = DllStructGetData($b2, 1, $51 * 2 + 2)
For $52 = 0 To $au - 1
$al[$ap - $51][$52] = $b7[$b8][$52]
Next
Next
Else
For $51 = $ao To $ap
$b8 = DllStructGetData($b2, 1,($51 - $ao) * 2 + 2)
For $52 = 0 To $au - 1
$al[$51][$52] = $b7[$b8][$52]
Next
Next
EndIf
EndIf
Return 1
EndFunc
Func _2r($b9)
If $b9 = "" Then Return SetError(1, '', 1)
Local $20 = WinGetHandle($b9)
If IsHWnd($20) Then
Local $ba = HWnd(ControlGetText($20, '', ControlGetHandle($20, '', 'Edit1')))
_37($ba, "/exit")
If Not WinWaitClose($ba, "", 5) Then
$CmdLine_b_Exit_After_Execution = True
Return WinGetHandle(AutoItWinGetTitle())
EndIf
EndIf
AutoItWinSetTitle($b9)
Return WinGetHandle($b9)
EndFunc
Func _2s($bb, $bc = False)
If Not IsBinary($bb) Then Return SetError(1, 0, 0)
Local $1s
Local Const $bd = Binary($bb)
Local Const $be = BinaryLen($bd)
Local Const $bf = _23($be, $7o)
Local Const $bg = _24($bf)
Local $bh = DllStructCreate("byte[" & $be & "]", $bg)
DllStructSetData($bh, 1, $bd)
_25($bf)
$1s = dllcall($5, "int", "CreateStreamOnHGlobal", "handle", $bg, "int", True, "ptr*", 0)
If @error Then SetError(2, 0, 0)
Local Const $bi = $1s[3]
$1s = DllCall($36, "uint", "GdipCreateBitmapFromStream", "ptr", $bi, "int*", 0)
If @error Then SetError(3, 0, 0)
Local Const $39 = $1s[2]
Local $bj = DllStructCreate("word vt;word r1;word r2;word r3;ptr data; ptr")
dllcall($6, "long", "DispCallFunc", "ptr", $bi, "dword", 8 + 8 * @AutoItX64, _
"dword", 4, "dword", 23, "dword", 0, "ptr", 0, "ptr", 0, "ptr", DllStructGetPtr($bj))
$bh = 0
$bj = 0
If $bc Then
Local Const $bk = _2t($39)
_j($39)
Return $bk
EndIf
Return $39
EndFunc
Func _2t($39)
Local $bl, $55, $3f, $bm, $bn = 0
$55 = DllCall($36, 'uint', 'GdipGetImageDimension', 'ptr', $39, 'float*', 0, 'float*', 0)
If(@error) Or($55[0]) Then Return 0
$3f = _k($39, 0, 0, $55[2], $55[3], $33, $35)
$bm = DllStructGetData($3f, 'Scan0')
If Not $bm Then Return 0
$bl = DllStructCreate('dword;long;long;ushort;ushort;dword;dword;long;long;dword;dword')
DllStructSetData($bl, 1, DllStructGetSize($bl))
DllStructSetData($bl, 2, $55[2])
DllStructSetData($bl, 3, $55[3])
DllStructSetData($bl, 4, 1)
DllStructSetData($bl, 5, 32)
DllStructSetData($bl, 6, 0)
$bn = dllcall($3, 'ptr', 'CreateDIBSection', 'hwnd', 0, 'ptr', DllStructGetPtr($bl), 'uint', 0, 'ptr*', 0, 'ptr', 0, 'dword', 0)
If(Not @error) And($bn[0]) Then
dllcall($3, 'dword', 'SetBitmapBits', 'ptr', $bn[0], 'dword', $55[2] * $55[3] * 4, 'ptr', DllStructGetData($3f, 'Scan0'))
$bn = $bn[0]
Else
$bn = 0
EndIf
_l($39, $3f)
Return $bn
EndFunc
Func _2u($bo)
$bo = Binary($bo)
Local $bp = BinaryLen($bo)
Local $bq = _1r($bp)
DllStructSetData(DllStructCreate('byte[' & $bp & ']', $bq), 1, $bo)
Local $br = _1r(8388608)
Local $bs = _1s($br, 8388608, $bq, $bp)
Local $bt = Binary(DllStructGetData(DllStructCreate('byte[' & $bs & ']', $br), 1))
_1u($bq)
_1u($br)
Return $bt
EndFunc
Func _2v()
Local $bo
$bo &= 'R7JIAAABABAQEAFwIAAAaAQAABYAAHwAKAAYAJAAiAO4AQBAgwBsHAAGb29vlgAGGv8UBpYBRhR2A3FxAHGWmZmZ/8zMHswSAwEbASMRQ3R0dACWmpqa/7e6zAD/JT7A/xEtwYcKAwETARubm5v/ASuFADIJBTt3d3eWgQsAub3O/ylDw/84FTPEkgGBDYERnp4Mnv+BGYEhe3t7lgCfn5//vMDR/wAtScf/XnXZ/+MBAIEDGTnIggGJCYERIYEVoqKi/4Edf38Af//V1dX/MVBgzP8dQM2CEwUAYRx63IIBCQCBETdUzAOCGYEdg4OD/9fXINf/IkjRggFESH63ihcJAIENhROBGYEdhwCHh//b29v/J/xR1sYA0RDBBMkIwQzBDgCLi4v/3d3d/4grWdzGAGuL584PD8EEyQjBDMEOj4+P/0Dg4OD/MGHDAG98kenWL8EGxQnBDMEOkwCTk/zi4uL/T8B74/80aOXOLM0yI8EIwQrj4+PBDv+WAJaWk7S0tP/VwNrl/1F/58YLwQEYOG7pwgDJBFOA5+D/1tvm/8EMwA7BgAIAwKWTt7e3/9cA3Of/VYXq/xXAGqX/PHTsygDBBABXhur/2N3o/w/BCsAMwg4FAJycnJMAuLi4/9ne6v+AV4nt/z5478oAAFmK7f/a3+r/8Lm5uf/ACsoOBQDAoQCTurq6/+rq6hD/6+vrzgC8vLwO/8AI0g4FAKGhoZM1YAD8YAD/cABuB/APAAAA4AcAAMAD8AAAgAH+g2IEYQVhBgFhBw=='
$bo = _31($bo)
Return _2u($bo)
EndFunc
Func _2w()
Local $bo
$bo &= 'XrJIAAABABAQEAFwIAAAaAQAABYAAHwAKAAYAJAAiAO4AQBAAwBsNQAweTXJK3EEMMQxdj2LRNFVAJ5c/1CYVv8sCHQyzwkbqXFRqQDDjmj/wItm/wC+iGT/u4Vh/wC5g1//tH5c/wCwfVr/WZlU/wBjrGv/iMmQ/wCCxor/UppY/wBAdTf/pHFQqyEBP8iSbP8VAITFAIv/V6th/2q0AHP/kM6X/4rLAJH/arBw/zuEQEL/Unc9/4EfyhSUbogY/oAB/f/+Cv6BAfyGAVSrXv8AltKf/5HPmf8AU59b/9Tm1v+IqnNTgh/Ml2+EHQb8hB2FG/v//f36AYIBW7Rl/53WpgD/mdOi/0ueUxGCFqx1VIIf0ZxzM4M8iDf9/YEdhR/4/wBgvGz/XLZn/4BXsGH/UqhcgheIsHpYgh/UnnXGDwPDDMUB+f/8/Pj/CPv598AA9f/7+AD0//v38v/79SLywguyfFrCD9WgtnbCA8cN+sANwA77yQ0C88IN+vPv//jyGuzCC7XAZ8EP2KJ5B8QPwQ3AAPv5//v6FvbADcAO98AO9vH/APj07v/38uv/gPfw6v/27OjCC8i3gV7CD9mjww/BDSz8+8QrwA36wCr59QDw//fz7f/27wDq//Xr5//z6iDk//Ln3sILuoViYMIP26R61n8ZAL2Eh2PCD9yne//xAAPBq8EP3ayF/ei5hJL/7QDBkG/9xL8ga92xjfTCFaZ6PP/awDPBVMFlwXbSnQBz/8+acv/OmQBw/8uWb//JlMBs/8SaevTBDXfz5QcA/6Bx/4eChH8AbAAC/yAg'
$bo = _31($bo)
Return _2u($bo)
EndFunc
Func _2x()
Local $bo
$bo &= 'N7NIAAABABAQEAFwIAAAaAQAABYAAHwAKAAYAJAAiAO4AQBAAwBsXQCtdEQjrHIAQX2qcD/bqG0APPOnazrzpWkAN9ukaDV9o2YEMyMZO7V+UVOzAHxO5te7o//pQNrK/+zg0QID6ADYyP/TtZz/p4BsOuamajhTETsAvYlfU7uHW/QA59XE/+XSv/8AyaaF/7iOZ/8Atopl/8WhgP8A4My6/+PQvv+Aq3BA9KluPYohAMaVbSLDkmrlAOrYyf/jzbr/AMCUa/+6jGL/CM+wlIIBt4lf/wCyh2H/2sCq/wDk0cD/rnVG5RCtc0MihR/MnngAfuTMuf/q1sUA/8eZcf+/kGYBggH38ez/9vDqA4IfgQG1iWP/4s4Au//Zvab/snsETX6FH9OnhNvvAOHT/9m1lf/HAJhs/8OVaf/BBJNnhiO7i2P/uQCKY/+4imL/ywCnhv/q3Mz/uAiDV9uFH9mwj/YA8uTZ/9Glev8AxZlr/8SXav8AxJZp//r28v8A8+rh/8KVbf+Ivo9lwABk/8DAAgDv49X/v4xh9gHFD+C5mfby5doA/9Gmfv/MnXEA/8eabP/FmGsA/+LMtv/48+4Q//bu6MAsof/CAJRo/8Wbcf/wQOLW/8WVbMYP5gDBo9vz5dn/3wC7nv/PoHX/zQCecv/16+P/5ADLtP/n07//+1D49v/lwAHEwBTWgLSR/+7g0v/ATAHGL+vJrX7049QA/+/czf/VqH4Q/9Cgd8AM9f/8A8QAwQLRqIH/z6QAe//q1cP/6tQgwv/Sp4PGT/HQALUi786z5fbpAN3/7NjG/9esAIH/3Lua//bsAOP/9ezi/+TIAq7AC3v/5s66/wDx4tX/27OR5RjZsI7GbwEA9NS7AFPy0rj09+rfAP/u3tD/48GnEP/YronAEob/3QC7nP/r1sf/8wDm2f/jvp/04QS7nNKg9ti/U/UA1r3m+enc//Yw6N3/88BUwQD15wDc//Xk1v/ryGCs5unGqdIOBQD5ANvEI/jawn33ANjA2/bXvvP0ANW88/PTudvxwNG3ffDPtNrPHwCBDwD//wAA8A9gQAAHAADAAwAAgD4BewBhBGEFYQZhBw=='
$bo = _31($bo)
Return _2u($bo)
EndFunc
Func _2y()
Local $bo
$bo &= 'SrmgQk1+EgACADYAMIooADAnBBgBABgDwBkAAMQOAwwFAPbx7pFvCPHu/+p3BgbzO4TBweUd0NDQtxQAOLa2tkAH/1lPHLOzArMAF9vb29TT0wDS0tLd3dvc3AOBAAAC1dXV2traALu7u7y8vM7OEs7kHdbX3x2ysrEAsLCvv769wsEQwNvX14Ae1tbWAQAd29va19fW2gDa1+Dg38/OzYi2tbSAPsfHx+EdBOHi3B2Uk5PHxBDDwcC/gBWPj48Aa2trPj09OzsAOzg3ODc3Nz4APj1ERER/f38Ak5OSwMC/29qQ2cbFw+EdrpTfOwifn53gDq+urmcAZ2dgYGA5OTkR4A48OzwAADo6OQA6OjpcXFxwcABvy8rJubm4oYShoP8O8e7S0/8OAcwfPT09Li4uMAECAC0uLkhHR5ocmpl/B/9KXAAvLy8wBgYGCAIAAAFDQyZDvwZOAE8c6g7HxqTGwg8AwcFJALgiZ7FGALq5uQwErAfDQgAZ7A5NHuoOAGHW1tcA4+Pi6+vq6ukC6aAA7u7t8O/uQPDw7u/v7cAB5QDk49/f3d/e3RDe3dzdQGnb2tsA2tjh4N7i4eAI5OPhAAHe3dvZANnX1tXTz87MAMXEwru6uLy7ErnvDisS6g7Pz88A19fY4eHi4uKq40AA4UMA4UAA4l8ABUUA4EEA4eDg4d/BQADf4MLCwO8O7DsA0tHR2dnahXoAc8uqj82vk84AsJTQspXQs5YBRAC0ltC1l9K3SJbSuEEA0bjAAZYAzrKVzLCVyq4AlMisk8erk8gArJLIrZLHq5EAxqqQxKaMe3CQac/P0e8Ot6nrDgDS0trb3XxtZAClb0KmcUWocwBFqXRGqXVHqgFAAHZHq3ZIq3cBRACseUiue0mvAHxJrnxJrXpJAcABq3dHqXZGqQB2R6VzRKNxRACfbkOYZz5uYZBa0dLT7w5EGeoOANPT09vc3nttAGN/QRF/QhGDAEYTiU0aik8cIIpOG4lNQAAchwBLGoNKGYRKGgCJTxuPVR2SWQAeklgdjVQchABLGntEF3Y/FgBsNxNpNBJgLgARWywQVCIFbSBgWdLT1H8HQRoBfQfc3d96bGNyADgOnXRYnnBPAIpQI4VMHIVMAB2HTh2JTx6HAE0dgkkbgEcaAIJJHIZLHYhNAB6HTB2FSxyAAEYbeEAZcDkWAGczFF8vEVorgBFYKg9RIQdwBxjT09V/B/wd1dXUAN3e4HlrYmgwAAnd0cz////PAKmKg0kZhU0cCUAHiVBxB4FJG3oARhl6Qxl+RRoAgkgbhEgchEkAHIJFHH1DGnYAPRhvNxZnMhQAYC0TWysSUiAUB2xwB9R/B+7b3QV8B9VyB2NpLwLNAbAf///i0buFTAAZiVAdiE8eihBQHotSUAAfg0oAHIBIG4VLHYoQUB2NUiAAH45RACCLTh6GSh2AAEUcdj0ZbTcWAGYzFFklCG5giFrU1X8H7nMmewcG1PEOcBZ0OgfAowCN/fv53s7DgwBMGYNMGoFKGgiAShkgAH1HGnoARBlyPhdyPhaAfEUag0wbiCAYAEwciUwdg0gbAHtCGnI5F2gzgBVhMBNXJAdwB0jV1dZ/B0EYfyXeAHlrYX9JE4FKABOASxaMWCaEQFAbgk0agtEHGwB/SBl9SRl4RQFABxVvPBZ6RRiAiE4bilEdjKAQAfAOSR18QRpyOgAXaTMVZDETWE3wDmF/ByEA19l7B9IA0tvb3XpsYYkAUBGnfVXEqZAApXpNk10blF4AHpRdHpVdH5MAWx+OVx+LVB0AgEwZdkQadUGIGHxIoRCGTByAHgSBRvAOGXA4FmMALxNbLBFSIgYZ8Q7W138Hf0PZ2twAe25hm2QUy7UAoPLx+9G7na0AeyCxgSutfCkAqHMmn2ojlV8AHopVG35LGHEAPxVpOhJxPhagd0MYgkrgHhxALgB8QhpzPBdoNBFxFlonCfAO1tbYGX8HgS56ByCN2NjbAH5xY7aL'
$bo &= 'JsWxAJXa1uHVwp66AJApuI4vtIguAKh3J5xqI5NgAB+OWh6FUht/AE8bdkUYdUIWAHA8FHRBGHY/AhgQB285Fmk0FABlMhNoNBRqMkAOcGNb1td/B+4MWCl7B/FZ2nxwYgCuhSuxmnS2rQCqtZ5wtY4tuQCRNb2WOLyRNwC1iTOxgzGtfgAxonMsmWkpjABbJIFOHXhFGEB+SRiGThtwLn4QSBp7Q7E8dT4YAGoxDnBiWtfXEtl/B0gbfGHO1tcA2XpuYaiANLEAijiuhzWpfywAqYEusIgxu5UAOcKcQL6WPrgAjDutfDSebi4AkmEoilomi1sAJ4pXJYFKHXkAQhZ5Qhd7QxkAeT8Zcz0XbjcgFWQtDG9wB9jaA38H/B3Ozc3V1dgAe29jvpxPqY8AYI5zSqmNXLkAlUa6kkO+lkgAu5JGtYpBp3cANZpoLYpaJ4gAWCeHWCmJWSoAjFoulmQzkFsALoVMH4BGGH4ARxp+Rht9RBsAdTkQcWNb2NkRfwfuzb56B83NzBDU1NZ6cAeeVt8A1tHf3Obg1sgAxaNWwZxSvpUATrGGQ6Z3OacAdjunej+kdD4AqXlDqX1Eq4AAR66CSbGDTLIAgU6vf0mibjoAjVIhgkgZf0gIG3c9cAda2NnbiX8HgEp6B8zMzOBUAHtwZMapX9rNAL7g2N/e0LrLAKxgyqpjxqRhAL6YV7ePULSNAE+0jVK1jFO1AItUto1WtYxWALOIVbKGVLCEAFOwgVOzg1arAHpNkFotf0UZOHU6DfAOADJ/B3NqAXsHy8rS0tR5bgBjxKdhy7N5zwC5gtG6fc6zbwDLr27DpWa5mQBcs45TrYRMqwCASqyCTK6ETwCvhFCuhFGthABSroRUrIJTqwCAU6yBU7CEWACugVehcUh8Q3AXbmBYgHV/B/wdygDJydHR0nxzbQB7cGV9cmd+c1EhAH90aSUAaiEAc7hpf3OCAOQALwBrIwCAem5mfnVv2v8OBQAdzn2dzs3O19ZG11BLIwDc3N6Qcd0hIJXe4N/gYIzk4wDk5eTl5+bn6QDn6Oro6uzq6wDt6+3u7e/w7wDw8vDy8/Hz9UDz9fb09viwAOhg6eve3t+Ak38HyQbJ/Q4wAsbFxcjHUscjAMnIIADIIQDJjyAABwCQAiMAy8rKJgAIzMvLIQApsADMy83MzMzLy5DKycnIAADHxwAwiPbx7gkQ8e7/DEQfYwj/d/87vwDaHQ=='
$bo = _31($bo)
Return _2u($bo)
EndFunc
Func _2z()
Local $bo
$bo &= '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'
$bo &= '8V/Gq1pR/wCpemu/+UAkQ01o64+C+VJ8w93dhPjs1Prom+zHdmImMv479NnkMo/LzsVJgJ85bLQZ2Bk+GP3dpAey7YH4MZMTQxTHRUlZnrHRaaCa7kOyHtWY5V7jJWpA40SuAdRWZLFuVCZVa9ejUcK2YmWxEeuXWygGBaIhYJ8jkixddfqADpBLr9sq2QkP1L01l/kAjxVhklGlBfFneYcnpYvyhZMAuGfs8GtimIT7f7kdkIgg0IyV0gF+NP5xCwIPrrS7q0AmB8MX6kWi8kDitl7GQdqkcr/MPWdQcknGkwuSROzU6wEVu2UcmBLNhXlwk01TDksUOgJkPj4IvowWAP8AXBdVdq+WtFtzPSaoDQ/5AvsrR9eq1b9EvzswO7AUdsMgVxBQWZnUOWS/0vmsBmjOOTkyw9GYeKh/sJLZkP8AU9dfMB//2Q=='
Return Binary(_31($bo))
EndFunc
Func _30()
Local $bo
$bo &= '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'
$bo &= 'BiQ59DpqaiDMpwyyGil/y8jUtzKbs/XrPX6NlzA0Fq9foqA7EYddkKhhvXqW68nIhK5YUDZtCRlS7vKubCww2f7X/TgI1DZypAvt745Zrq74ep06A04y+0pt1F1bySLEccF+jURppamw3nU66shA/CMyjYfkMcs11d8cs11d8cs11d8cs11d8cs11d8cs11d8cs11d8cs11d8Ba0JFk2ATj/xAAhEAEBAAIBBAMBAQAAAAAAAAABEQAhMUFRwfAQYYEwof/aAAgBAQABPyEjt9Sm/s/3N+Tk+N6dyqu8mReAF6bkuL1MpnVzvVlo7AqyBemOUCl5I/rA1zcI+CNmEtSUVQ1UcJJoLXlVWoB1XFfjR6R6E0baz3zxnvnjPfPGe+eMZyioRfoyh7AlLRBxx0Y9fYp5BYPjlNbM3zC89jUAzgcl1jFNRJVIbnTaCMoSXOMHNplE/ebvkZqiniGi6pQMOwXSyBsltvCZrjmxfqQOYTU5cYHHXXboKYjzWwqMDtY+1CcxjDHwUapL28PdaZMZtBUj17bWB0rfAr2lMK3QJ0+BKVrGNKgsovGWlRShRN77Bo7H8SSSSSSSSeQQ0SVeq98//9oADAMBAAIAAwAAABDAku1tuYBXOASefb//AP8A/wD/xAAgEQEAAgMAAwADAQAAAAAAAAABABEhMWFBUXEggZHw/9oACAEDAQE/EGaGz+EoW4bwH5dpAusuwJ3zn7UA+J7ZrEQo1yxVPj7v5UQk7q2U5HNV8jtsKNsr8FeJZQMC8efM4E4E4E4EI0eIgKKKGhaLLwZ1DgZkDAivLnOaxCzhob76iivWv5Eprxv0m2u9VXuz3AL4FFaV0XWcueREhdpuA4aY158foJSxO4Ha0owa/LR8gwUTgRkERKf9cXDHW1x6ys4E4E4E4E4E4E4E4EQtn//EACARAQACAwADAQADAAAAAAAAAAEAESExYUFRcYEgkaH/2gAIAQIBAT8QPi4D+2pbmlshfyj3f7F2yqlDzxRfpZ7Caye28cr7BwNXQHLTqvtwltur1YaTA39xAAVmmGvNvO9NagBpyaz4vH+Tozozozoxjb5gKuCEWhdEMqG0fyFpfDtZXwYaKvMpBd/BcG2/eVmbKuz7Ji/6v0D6j2ZQEWDbV4wYfcKUmEFZGGxm8efcGwjSTZgBvCmefy2fYsts6MvwiWONn5AyUu9Bn3gLZ0Z0Z0Z0Z0Z0Z0Z0YBRP/8QAHxABAQEBAAEEAwAAAAAAAAAAAREAIUEQMVFhIDCB/9oACAEBAAE/EA7IDlu0yqo+V+Tmt+pO4G+dFuUcCWCR+2mANAWCYKrl4BIJSsFTgNojpCgkkEl9M/VLL492YIQQnADPN1OCQCmEfnpz/mV+Bz8a1atWW6/IRWA7A79ZqmiliF92jvmTJYuvyADJaRCNKNQSxgjJSMKADB6m3aWsmWIMbGxEELhbhBEuNQ5gAwW0qo35faywmYAHZlpg/JwoBjx9RwQCmMeLBHdYu/DRlHPCo+zcdS3zApEBFyyKnpPfN/JUlwjiSD7mGoKUCQYWJYHsHpILSTWoQ4JUJaI9y6S1Rh6CGiKI8P0SSSSSSSSTAMD5k7LX53//2Q=='
Return Binary(_31($bo))
EndFunc
Func _31($bu)
Local $bv = DllStructCreate("int")
Local $bw = dllcall($7, "int", "CryptStringToBinary", "str", $bu, "int", 0, "int", 1, "ptr", 0, "ptr", DllStructGetPtr($bv, 1), "ptr", 0, "ptr", 0)
If @error Or Not $bw[0] Then Return SetError(1, 0, "")
Local $bx = DllStructCreate("byte[" & DllStructGetData($bv, 1) & "]")
$bw = dllcall($7, "int", "CryptStringToBinary", "str", $bu, "int", 0, "int", 1, "ptr", DllStructGetPtr($bx), "ptr", DllStructGetPtr($bv, 1), "ptr", 0, "ptr", 0)
If @error Or Not $bw[0] Then Return SetError(2, 0, "")
Return DllStructGetData($bx, 1)
EndFunc
Func _32($by = -1, $6h = 8.5, $bz = 400, $c0 = 0, $c1 = Default, $c2 = 2)
If IsKeyword($c1) Then
Local $c3 = _34()
$c1 = $c3[3]
EndIf
If Not IsDeclared("__i_SetFont_DPI_Ratio") Then
Global $c4 = _35()
$c4 = $c4[2]
EndIf
GUICtrlSetFont($by, $6h / $c4, $bz, $c0, $c1, $c2)
EndFunc
Func _33($6h = 8.5, $bz = 400, $c0 = 0, $c1 = Default, $20 = Default, $c2 = 2)
If Not IsHWnd($20) Then $20 = GUISwitch(0)
If IsKeyword($c1) Then
Local $c3 = _34()
$c1 = $c3[3]
EndIf
If Not IsDeclared("c4") Then
Global $c4 = _35()
$c4 = $c4[2]
EndIf
GUISetFont($6h / $c4, $bz, $c0, $c1, $20, $c2)
EndFunc
Func _34()
Local $c5[5] = [8.5, 400, 0, "Tahoma", 2]
Local $20 = WinGetHandle(AutoItWinGetTitle())
Local $c6 = DllOpen("uxtheme.dll")
Local $c7 = DllCall($c6, 'ptr', 'OpenThemeData', 'hwnd', $20, 'wstr', "Static")
If @error Then Return $c5
$c7 = $c7[0]
Local $c8 = DllStructCreate("long;long;long;long;long;byte;byte;byte;byte;byte;byte;byte;byte;wchar[32]")
Local $c9 = DllStructGetPtr($c8)
DllCall($c6, 'long', 'GetThemeSysFont', 'HANDLE', $c7, 'int', 805, 'ptr', $c9)
If @error Then Return $c5
Local $ca = dllcall($2, "handle", "GetDC", "hwnd", $20)
If @error Then Return $c5
$ca = $ca[0]
Local $cb = dllcall($3, "int", "GetDeviceCaps", "handle", $ca, "int", 90)
If Not @error Then
$cb = $cb[0]
$c5[0] = Int(2 *(.25 - DllStructGetData($c8, 1) * 72 / $cb)) / 2
EndIf
dllcall($2, "int", "ReleaseDC", "hwnd", $20, "handle", $ca)
$c5[3] = DllStructGetData($c8, 14)
$c5[1] = DllStructGetData($c8, 5)
$c5[4] = DllStructGetData($c8, 12)
If DllStructGetData($c8, 6) Then $c5[2] += 2
If DllStructGetData($c8, 7) Then $c5[2] += 4
If DllStructGetData($c8, 8) Then $c5[2] += 8
Return $c5
EndFunc
Func _35()
Local $cc[3]
Local $cd, $ce, $1j = 90, $20 = 0
Local $ca = DllCall($2, "long", "GetDC", "long", $20)
Local $ax = DllCall($3, "long", "GetDeviceCaps", "long", $ca[0], "long", $1j)
Local $ca = DllCall($2, "long", "ReleaseDC", "long", $20, "long", $ca)
$cd = $ax[0]
Select
Case $cd = 0
$cd = 96
$ce = 94
Case $cd < 84
$ce = $cd / 105
Case $cd < 121
$ce = $cd / 96
Case $cd < 145
$ce = $cd / 95
Case Else
$ce = $cd / 94
EndSelect
$cc[0] = 2
$cc[1] = $cd
$cc[2] = $ce
Return $cc
EndFunc
Func _36($20, $cf, $22, $23)
Local $cg = DllStructCreate("ulong_ptr;dword;ptr", $23)
Local $ch = DllStructCreate("char[" & DllStructGetData($cg, 2) & "]", DllStructGetData($cg, 3))
If DllStructGetData($ch, 1) = "/exit" Then _2h()
Return 0
EndFunc
Func _37($20, $ci)
If Not IsHWnd($20) Then Return 0
If $ci = "" Then $ci = " "
Local $cg, $ch
$ch = DllStructCreate("char[" & StringLen($ci) + 1 & "]")
DllStructSetData($ch, 1, $ci)
$cg = DllStructCreate("ulong_ptr;dword;ptr")
DllStructSetData($cg, 2, StringLen($ci) + 1)
DllStructSetData($cg, 3, DllStructGetPtr($ch))
$55 = dllcall($2, "lparam", "SendMessage", "hwnd", $20, "int", $1b, "wparam", 0, "lparam", DllStructGetPtr($cg))
If(@error) Or($55[0] = -1) Then Return 0
Return 1
EndFunc
Func _38($cj, $ck, $cl, $cm = 0, $20 = 0)
Local $cn = DllCallbackRegister("_39", "int", "int;int;int")
Local $co = _a()
$a = _h($2a, DllCallbackGetPtr($cn), 0, $co)
Local $4j = MsgBox($cj, $ck, $cl, $cm, $20)
_i($a)
DllCallbackFree($cn)
Return $4j
EndFunc
Func _39($cp, $22, $23, $a)
Local $55 = 0, $39 = 0, $cq = 0
Local $cr
If $cp < 0 Then
$55 = _6($a, $cp, $22, $23)
Return $55
EndIf
Switch $cp
Case 5
_3a($22, 1, "OK")
_3a($22, 2, "Cancel")
_3a($22, 3, "&Abort")
_3a($22, 4, "&Retry")
_3a($22, 5, "&Ignore")
_3a($22, 6, "&Yes")
_3a($22, 7, "&No")
_3a($22, 8, "Help")
_3a($22, 10, "&Try Again")
_3a($22, 11, "&Continue")
EndSwitch
Return
EndFunc
Func _3a($cs, $ct, $cu)
Local $ax = dllcall($2, "int", "SetDlgItemText", _
"hwnd", $cs, _
"int", $ct, _
"str", $cu)
Return $ax[0]
EndFunc
