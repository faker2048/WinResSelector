#AutoIt3Wrapper_UseX64=n ;if x64 is selected WM_NOTIFY respectively coloring listview items will not work properly!
#AutoIt3Wrapper_Res_Description=Converts any file to a base64 string usable in AutoIt for embedded memory read
#AutoIt3Wrapper_Res_Fileversion=1.0.3.0
#AutoIt3Wrapper_Res_Field=CompanyName|UEZ Software Production
#AutoIt3Wrapper_Res_Field=ProductName|File to Base64 String Code Generator
#AutoIt3Wrapper_Res_Field=ProductVersion|%AutoItVer%
#AutoIt3Wrapper_Res_LegalCopyright=UEZ 2011
#AutoIt3Wrapper_Res_Language=1033
#AutoIt3Wrapper_Res_Field=Coded by|UEZ
#AutoIt3Wrapper_Res_Field=Build|2011-11-21
#AutoIt3Wrapper_Res_Field=Compile Date|%longdate% %time%
#AutoIt3Wrapper_Icon=Halloween.ico
#AutoIt3Wrapper_Run_Obfuscator=y
#Obfuscator_Parameters=/sf /sv /om /cs=0 /cn=0
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Run_After=del /f /q "%scriptdir%\%scriptfile%_Obfuscated.au3"
;~ #AutoIt3Wrapper_Run_After=..\..\..\ResourceHacker\ResHacker.exe -delete %out%, %out%, ICON, 1,
;~ #AutoIt3Wrapper_Run_After=..\..\..\ResourceHacker\ResHacker.exe -delete %out%, %out%, ICON, 2,
;~ #AutoIt3Wrapper_Run_After=..\..\..\ResourceHacker\ResHacker.exe -delete %out%, %out%, ICON, 3,
;~ #AutoIt3Wrapper_Run_After=..\..\..\ResourceHacker\ResHacker.exe -delete %out%, %out%, MENU, 166,
;~ #AutoIt3Wrapper_Run_After=..\..\..\ResourceHacker\ResHacker.exe -delete %out%, %out%, DIALOG, 1000,
;~ #AutoIt3Wrapper_Run_After=..\..\..\ResourceHacker\ResHacker.exe -delete %out%, %out%, ICONGROUP, 162,
;~ #AutoIt3Wrapper_Run_After=..\..\..\ResourceHacker\ResHacker.exe -delete %out%, %out%, ICONGROUP, 164,
;~ #AutoIt3Wrapper_Run_After=..\..\..\ResourceHacker\ResHacker.exe -delete %out%, %out%, ICONGROUP, 169,
#AutoIt3Wrapper_Run_After=upx.exe --best --lzma "%out%"
;~ #AutoIt3Wrapper_Run_After=upx.exe --ultra-brute --crp-ms=999999 --all-methods --all-filters "%out%"

#include <ButtonConstants.au3>
#include <Constants.au3>
#include <EditConstants.au3>
#include <GDIPlus.au3>
#include <GUIConstantsEx.au3>
#include <GUIListView.au3>
#include <GUIMenu.au3>
#include <GUIRichEdit.au3>
#include <ListViewConstants.au3>
#Include <Memory.au3>
#include <WindowsConstants.au3>

Break(0)
Opt("MustDeclareVars", 1)

Global Const $title = "File to Base64 String Code Generator "

#region GUI
Global Const $ver = "v1.03 Build 2011-11-21"
Global Const $width = 642
Global Const $height = 540
Global Const $hGUI = GUICreate($title & $ver & " by UEZ", $width, $height)
GUISetFont(8, 400, 0, "Arial")

Global $GUI_Color, $GUI_Color_def = "EAE3F3"
Global $ini_file = @ScriptDir & "\File to Base64 String Code Generator.ini"
If Not FileExists($ini_file) Then
	IniWrite($ini_file, "GUI_Color", "Random", 0)
	IniWrite($ini_file, "GUI_Color", "Color", $GUI_Color_def)
EndIf
Global $random_color = IniRead($ini_file, "GUI_Color", "Random", 0)
Global $aBGColors[12] = [0xBFCDDB, 0xEAE3F3, 0xC0DCC0, 0xA6CAF0, 0xD7E4F2, 0xFFE0C4, 0xFFE4B5, 0xE6E6FA, 0xEEE8AA, 0xFFD948, 0xEEBB88, 0xABCDEF]
 If $random_color = "1" Then
	$GUI_Color = $aBGColors[Random(0, UBound($aBGColors) - 1, 1)]
	GUISetBkColor($GUI_Color)
	$GUI_Color = Hex($GUI_Color, 6)
Else
	$GUI_Color = IniRead($ini_file, "GUI_Color", "Color", $GUI_Color_def)
	If StringLen($GUI_Color) <> 6 Or Not Dec($GUI_Color) Then $GUI_Color = $GUI_Color_def
	GUISetBkColor("0x" & $GUI_Color)
EndIf

Global Const $idLabel_File = GUICtrlCreateLabel("Select File:", 8, 16, 70, 20)
GUICtrlSetFont(-1, 10, 400, 0, "Arial")
GUICtrlSetTip(-1, "Select file which you want to convert to a base64 string", "", 0, 1)
Global Const $idButton_File = GUICtrlCreateButton("&Browse", 80, 12, 75, 25)
GUICtrlSetFont(-1, 9, 400, 0, "Arial")
GUICtrlSetTip(-1, "Select file which you want to convert to a base64 string", "", 0, 1)
Global Const $idInput_File = GUICtrlCreateInput("", 160, 14, 473, 22, $ES_READONLY)
GUICtrlSetFont(-1, 10, 400, 0, "Arial")
Global Const $idLabel_VarName = GUICtrlCreateLabel("Variable / Function Name:", 8, 49, 155, 20)
GUICtrlSetFont(-1, 10, 400, 0, "Arial")
GUICtrlSetTip(-1, "Enter the variable / function name without leading $" & @LF & "In multi selection mode file names will be used!", "", 0, 1)
Global Const $idInput_Var = GUICtrlCreateInput("Base64String", 164, 46, 213, 22)
GUICtrlSetFont(-1, 10, 400, 0, "Arial")
GUICtrlSetTip(-1, "Enter the name of the function / variable to be used without leading $" & @LF & "In multi selection mode file names will be used!", "", 0, 1)
Global Const $idButton_Convert = GUICtrlCreateButton("Convert", 8, 70, 83, 43, $BS_BITMAP)
GUICtrlSetFont(-1, 21, 400, 0, "Arial")
GUICtrlSetTip(-1, "Convert any file to a base64 string incl. function code", "", 0, 1)
Global Const $hButton_Convert = GUICtrlGetHandle($idButton_Convert)

Global Const $STM_SETIMAGE = 0x0172
Global Const $hBmp_Button = Load_BMP_From_Mem(Image_Btn(), True)
_WinAPI_DeleteObject(_SendMessage($hButton_Convert, $BM_SETIMAGE, $IMAGE_BITMAP, $hBmp_Button))
_WinAPI_UpdateWindow($hButton_Convert)
Global Const $hBmp_Button2 = Load_BMP_From_Mem(Image_Btn2(), True)

Global $hRichEdit = _GUICtrlRichEdit_Create($hGUI, "", 8, 120, 625, $height - 125, BitOR($ES_MULTILINE, $WS_VSCROLL, $WS_HSCROLL, $ES_AUTOVSCROLL))
_GUICtrlRichEdit_SetLimitOnText($hRichEdit, 0xFFFFFF)
_GUICtrlRichEdit_SetFont($hRichEdit, 9, "Arial")
_GUICtrlRichEdit_SetCharColor($hRichEdit, 0x200000) ;BGR
_GUICtrlRichEdit_SetCharBkColor($hRichEdit, 0xFFFFFF) ;BGR
_GUICtrlRichEdit_SetReadOnly($hRichEdit, True)

Global Const $idButton_Save = GUICtrlCreateButton("&Save", 104, 88, 75, 25)
GUICtrlSetFont(-1, 9, 400, 0, "Arial")
GUICtrlSetTip(-1, "Save script to a file (AU3 format)", "", 0, 1)
Global Const $idButton_Clipboard = GUICtrlCreateButton("&Clipboard", 192, 88, 75, 25)
GUICtrlSetFont(-1, 9, 400, 0, "Arial")
GUICtrlSetTip(-1, "Put script to clipboard", "", 0, 1)
Global Const $idCheckbox_Compression = GUICtrlCreateCheckbox("Com&pression", 278, 76, 81, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlSetTip(-1, "Enable build-in compression." & @LF & "Press RMB to set compression strength." & @LF & "Default: high (slow).", "", 0, 1)
Global Const $idCheckbox_decompFunction = GUICtrlCreateCheckbox("&Add decomp. funct.", 278, 96, 110, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlSetTip(-1, "Add also decompression function to the code", "", 0, 1)
Global Const $idGroup_Statistics = GUICtrlCreateGroup("Statistics", 392, 40, 241, 73)
Global Const $idLabel_Length = GUICtrlCreateLabel("Old Length:", 400, 60, 59, 18)
GUICtrlSetTip(-1, "Size of the file", "", 0, 1)
Global Const $idLabel_Lenght_n = GUICtrlCreateLabel(StringFormat("%.2f %s", 0, "kb"), 466, 60, 96, 18)
Global Const $idLabel_Length_C = GUICtrlCreateLabel("New Length:", 400, 88, 66, 18)
GUICtrlSetTip(-1, "Size of the compressed file", "", 0, 1)
Global Const $idLabel_Length_C_n = GUICtrlCreateLabel(StringFormat("%.2f %s", 0, "kb"), 466, 88, 88, 18)
Global Const $idLabel_Saved = GUICtrlCreateLabel("Saved:", 539, 88, 38, 18)
GUICtrlSetTip(-1, "Compression benefit", "", 0, 1)
Global Const $idLabel_SavedPerc = GUICtrlCreateLabel(StringFormat("%05.2f %s", 0, "%"), 579, 88, 46, 18)
GUICtrlSetFont(-1, 8, 800, 0, "Arial")
GUICtrlSetTip(-1, "The higher the value the better the compression!", "", 0, 1)
Global Const $idLabel_MS = GUICtrlCreateLabel("Multiselect:", 539, 60, 57, 18)
Global Const $idLabel_MS_state = GUICtrlCreateLabel("False", 595, 60, 30, 18)
GUICtrlCreateGroup("", -99, -99, 1, 1)

Global Enum $id_Standard = 0x400, $id_High, $id_About
Global Const $hQMenu_Sub = _GUICtrlMenu_CreatePopup()
_GUICtrlMenu_InsertMenuItem($hQMenu_Sub, 0, "Standard", $id_Standard)
_GUICtrlMenu_InsertMenuItem($hQMenu_Sub, 1, "High", $id_High)
Global Const $hQMenu = _GUICtrlMenu_CreatePopup()
_GUICtrlMenu_InsertMenuItem($hQMenu, 0, "Compression Strength", 0, $hQMenu_Sub)
_GUICtrlMenu_CheckRadioItem($hQMenu_Sub, 0, 1, 1)
Global Const $hBMP_Compression = Load_BMP_From_Mem(Compress_Icon(), True)
_GUICtrlMenu_SetItemBmp($hQMenu, 0, $hBMP_Compression)
Global Const $hMenu = _GUICtrlMenu_GetSystemMenu($hGUI)
_GUICtrlMenu_AppendMenu($hMenu, $MF_SEPARATOR, 0, 0)
_GUICtrlMenu_AppendMenu($hMenu, $MF_STRING, $id_About, "About")
Global Const $hBMP_About = Load_BMP_From_Mem(Info_Icon(), True)
_GUICtrlMenu_SetItemBmp($hMenu, 8, $hBMP_About)
GUISetIcon(@ScriptDir & '\Halloween.ico', $hGUI)
GUISetState(@SW_SHOW, $hGUI)
#endregion GUI

Global $_B64E_CodeBuffer, $_B64E_CodeBufferMemory, $_B64E_Init, $_B64E_EncodeData, $_B64E_EncodeEnd
Global $err = False, $compressed = True, $compressed2, $compression_strength = 1, $multiselect = False, $ToolTip = False
Global $nMsg, $text, $Script, $Decompress_Func, $BinaryString, $BinaryStringComp, $Script_Base64Decode, $BinStringLen, $bSize, $hListView
Global $hWndListView, $hWndFrom, $iIDFrom, $iCode, $aStatistic[1][4]
Global Const $LineLen = 2000, $limit = 50 * 1024^2
;Global Const $WM_MOVING = 0x0216
Global $aCoord, $tPoint, $Prev_Coord[2], $aFiles[2], $sFiles, $converted = False

#region function codes
Global _
$Script_Base64Decode = 'Func _Base64Decode($input_string)' & @LF
$Script_Base64Decode &= @TAB & 'Local $struct = DllStructCreate("int")' & @LF
$Script_Base64Decode &= @TAB & 'Local $a_Call = DllCall("Crypt32.dll", "int", "CryptStringToBinary", "str", $input_string, "int", 0, "int", 1, "ptr", 0, "ptr", DllStructGetPtr($struct, 1), "ptr", 0, "ptr", 0)' & @LF
$Script_Base64Decode &= @TAB & 'If @error Or Not $a_Call[0] Then Return SetError(1, 0, "")' & @LF
$Script_Base64Decode &= @TAB & 'Local $a = DllStructCreate("byte[" & DllStructGetData($struct, 1) & "]")' & @LF
$Script_Base64Decode &= @TAB & '$a_Call = DllCall("Crypt32.dll", "int", "CryptStringToBinary", "str", $input_string, "int", 0, "int", 1, "ptr", DllStructGetPtr($a), "ptr", DllStructGetPtr($struct, 1), "ptr", 0, "ptr", 0)' & @LF
$Script_Base64Decode &= @TAB & 'If @error Or Not $a_Call[0] Then Return SetError(2, 0, "")' & @LF
$Script_Base64Decode &= @TAB & 'Return DllStructGetData($a, 1)' & @LF
$Script_Base64Decode &= 'EndFunc   ;==>_Base64Decode' & @LF & @LF

Global _
$Decompress_Func = "Func _WinAPI_LZNTDecompress(ByRef $tInput, ByRef $tOutput, $iBufferSize = 0x800000)" & @LF
$Decompress_Func &= @TAB & "Local $tBuffer, $Ret" & @LF
$Decompress_Func &= @TAB & "$tOutput = 0" & @LF
$Decompress_Func &= @TAB & "$tBuffer = DllStructCreate('byte[' & $iBufferSize & ']')" & @LF
$Decompress_Func &= @TAB & "If @error Then Return SetError(1, 0, 0)" & @LF
$Decompress_Func &= @TAB & "$Ret = DllCall('ntdll.dll', 'uint', 'RtlDecompressBuffer', 'ushort', 0x0002, 'ptr', DllStructGetPtr($tBuffer), 'ulong', $iBufferSize, 'ptr', DllStructGetPtr($tInput), 'ulong', DllStructGetSize($tInput), 'ulong*', 0)" & @LF
$Decompress_Func &= @TAB & "If @error Then Return SetError(2, 0, 0)" & @LF
$Decompress_Func &= @TAB & "If $Ret[0] Then Return SetError(3, $Ret[0], 0)" & @LF
$Decompress_Func &= @TAB & "$tOutput = DllStructCreate('byte[' & $Ret[6] & ']')" & @LF
$Decompress_Func &= @TAB & "If Not _WinAPI_MoveMemory(DllStructGetPtr($tOutput), DllStructGetPtr($tBuffer), $Ret[6]) Then" & @LF
$Decompress_Func &= @TAB & @TAB & "$tOutput = 0" & @LF
$Decompress_Func &= @TAB & @TAB & "Return SetError(4, 0, 0)" & @LF
$Decompress_Func &= @TAB & "EndIf" & @LF
$Decompress_Func &= @TAB & "Return $Ret[6]" & @LF
$Decompress_Func &= "EndFunc   ;==>_WinAPI_LZNTDecompress" & @LF & @LF
$Decompress_Func &= "Func _WinAPI_MoveMemory($pDestination, $pSource, $iLenght)" & @LF
$Decompress_Func &= @TAB & "DllCall('ntdll.dll', 'none', 'RtlMoveMemory', 'ptr', $pDestination, 'ptr', $pSource, 'ulong_ptr', $iLenght)" & @LF
$Decompress_Func &= @TAB & "If @error Then Return SetError(5, 0, 0)" & @LF
$Decompress_Func &= @TAB & "Return 1" & @LF
$Decompress_Func &= "EndFunc   ;==>_WinAPI_MoveMemory" & @LF & @LF
#endregion

GUIRegisterMsg($WM_COMMAND, "WM_COMMAND")
GUIRegisterMsg($WM_CONTEXTMENU, "WM_CONTEXTMENU")
GUIRegisterMsg($WM_MOVING, "WM_MOVING")
GUIRegisterMsg($WM_SYSCOMMAND, "WM_SYSCOMMAND")
GUIRegisterMsg($WM_ACTIVATEAPP, "WM_ACTIVATEAPP")

Global $aPos, $mhover = False, $mhover_stat1 = False, $mhover_stat2 = True

_GUICtrlRichEdit_SetText($hRichEdit, "Ready.")

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			GUIRegisterMsg($WM_NOTIFY, "")
			GUIRegisterMsg($WM_COMMAND, "")
			GUIRegisterMsg($WM_SYSCOMMAND, "")
			GUIRegisterMsg($WM_CONTEXTMENU, "")
			GUIRegisterMsg($WM_MOVING, "")
			GUIRegisterMsg($WM_ACTIVATEAPP, "")
			_GUICtrlRichEdit_Destroy($hRichEdit)
			_WinAPI_DeleteObject($hBMP_Compression)
			_WinAPI_DeleteObject($hBMP_About)
			_WinAPI_DeleteObject($hBmp_Button)
			_WinAPI_DeleteObject($hBmp_Button2)
			GUIDelete($hGUI)
			IniWrite($ini_file, "GUI_Color", "Color", $GUI_Color)
			Exit
		Case $idButton_File
			Load_File()
		Case $idButton_Save
			If _GUICtrlRichEdit_GetText($hRichEdit) = "" Or _GUICtrlRichEdit_GetText($hRichEdit) = "Ready." Then
				MsgBox(16 + 262144, "Error", "Noting to save!" & @LF & @LF & "Convert any file before pressing the Save button!", 30, $hGUI)
			Else
				Save_File()
			EndIf
		Case $idButton_Clipboard
			$text = _GUICtrlRichEdit_GetText($hRichEdit)
			If _GUICtrlRichEdit_GetText($hRichEdit) = "" Or _GUICtrlRichEdit_GetText($hRichEdit) = "Ready." Then
				MsgBox(16 + 262144, "Error", "Noting to put to clipboard!" & @LF & @LF & "Convert any file before pressing the Clipboard button!", 30, $hGUI)
			Else
				If Not ClipPut($text) Then $err = True
				If $err Then
					MsgBox(16 + 262144, "Error", "Unable to put script to clipboad!", 30, $hGUI)
				Else
					MsgBox(64 + 262144, "Information", "Script was properly put to clipboard!", 30, $hGUI)
				EndIf
			EndIf
		Case $idButton_Convert
			Convert()
	EndSwitch
	$aPos = GUIGetCursorInfo($hGUI)
	If $aPos[4] = $idButton_Convert Then
		If $mhover_stat2 Then
			_SendMessage($hButton_Convert, $BM_SETIMAGE, $IMAGE_BITMAP, $hBmp_Button2)
			_WinAPI_UpdateWindow($hButton_Convert)
			$mhover_stat2 = False
			$mhover_stat1 = True
		EndIf
	Else
		If $mhover_stat1 Then
			_SendMessage($hButton_Convert, $BM_SETIMAGE, $IMAGE_BITMAP, $hBmp_Button)
			_WinAPI_UpdateWindow($hButton_Convert)
			$mhover_stat1 = False
			$mhover_stat2 = True
		EndIf
	EndIf
WEnd

Func Convert()
	If GUICtrlRead($idInput_File) = "" Then Return MsgBox(16 + 262144, "Error", "No file(s) selected!", 30, $hGUI)
	GUICtrlSetState($idButton_Convert, $GUI_DISABLE)
	GUISetState(@SW_DISABLE, $hGUI)
	GUICtrlSetColor($idLabel_SavedPerc, 0x000000)
	_GUICtrlRichEdit_SetText($hRichEdit, "Please wait while converting to base64 string...")
	Local $old_cursor = MouseGetCursor()
	GUISetCursor(15, 1, $hGUI)
	Local $compression = BitAND(GUICtrlRead($idCheckbox_Compression), $GUI_CHECKED)
	Local $decomp_function = BitAND(GUICtrlRead($idCheckbox_decompFunction), $GUI_CHECKED)
	Local $path = $aFiles[0], $j, $fHandle, $BinaryString, $bSize, $BinarySuffix, $VarName, $comp
	$Script = ";Code was generated by File to Base64 String Code Generator" & @LF & @LF
	If $multiselect Then
		GUICtrlSetData($idLabel_SavedPerc, StringFormat("%05.2f %s", 0, "%"))
		ReDim $aStatistic[UBound($aFiles) - 1][4] ;filename, files size, compressed file size, saved %
		For $j = 1 To UBound($aFiles) - 1
			ToolTip("Progress: " & StringFormat("%05.2f %s", 100 * $j / (UBound($aFiles) - 1), "%"), 10 + MouseGetPos(0), 20 + MouseGetPos(1))
			If FileGetSize($path & $aFiles[$j]) = 0 Then
				$aStatistic[$j - 1][0] = $aFiles[$j]
				$aStatistic[$j - 1][1] = 0
				ContinueLoop
			EndIf
			$fHandle = FileOpen($path & $aFiles[$j], 16)
			If @error Then ContinueLoop
			$BinaryString = FileRead($fHandle)
			FileClose($fHandle)
			$bSize = BinaryLen($BinaryString)
			$aStatistic[$j - 1][1] = $bSize
			$comp = $compression
			If $compression Then
				$BinaryStringComp = Compress($BinaryString)
				If BinaryLen($BinaryStringComp) > $bSize Then
					$comp = False
					$aStatistic[$j - 1][2] = $bSize
					$aStatistic[$j - 1][3] = StringFormat("%05.2f", 100 - (100 * BinaryLen($BinaryStringComp) / $bSize))
				Else
					$compressed2 = True
					$comp = True
					$aStatistic[$j - 1][2] = BinaryLen($BinaryStringComp)
					$aStatistic[$j - 1][3] = StringFormat("%05.2f", 100 - (100 * $aStatistic[$j - 1][2] / $bSize))
				EndIf
			Else
					$aStatistic[$j - 1][2] = $bSize
					$aStatistic[$j - 1][3] = StringFormat("%05.2f", 0)
			EndIf
			$aStatistic[$j - 1][0] = $aFiles[$j]
			$BinaryString = _Base64Encode($BinaryString)
			$BinStringLen = StringLen($BinaryString)
			$BinarySuffix = StringRight($BinaryString, Mod($BinStringLen, $LineLen))
			$VarName = StringRegExpReplace($aFiles[$j], "[^\w]", "")
			Create_Function($Script, $VarName, $BinaryString, $BinStringLen, $LineLen, $comp, $BinarySuffix)
		Next
		ToolTip("")
		_GUICtrlRichEdit_SetText($hRichEdit, "")
		If Not $compressed2 Then GUICtrlSetState($idCheckbox_Compression,  $GUI_UNCHECKED)
		If $decomp_function Then
			If Not $compressed2 Then
				_GUICtrlRichEdit_InsertText($hRichEdit, $Script & $Script_Base64Decode)
			Else
				_GUICtrlRichEdit_InsertText($hRichEdit, $Script & $Script_Base64Decode & $Decompress_Func)
			EndIf
		Else
			_GUICtrlRichEdit_InsertText($hRichEdit, $Script)
		EndIf
		Display_Statistic($aStatistic)
		If Not $compressed2 And $compression Then
			$aCoord = ControlGetPos($hGUI, "", $idCheckbox_Compression)
			$tPoint = DllStructCreate("int X;int Y")
			DllStructSetData($tPoint, "X", $aCoord[0] + 20)
			DllStructSetData($tPoint, "Y", $aCoord[1] + 12)
			_WinAPI_ClientToScreen($hGUI, $tPoint)
			ToolTip("All compressed files size exceeded original file size!" & @LF & "Compression was disabled for all files!", DllStructGetData($tPoint, "X"), DllStructGetData($tPoint, "Y"), "Warning", 2, 1)
			AdlibRegister("ToolTip_Off", 7500)
		EndIf
	Else
		Local $file = $path & $aFiles[1]
		If Not FileExists($file) Then
			_Enable_Ctrls($old_cursor)
			Return MsgBox(16 + 262144, "Error", '"' & $file & '" not found!', 30, $hGUI)
		EndIf
		If FileGetSize($file) = 0 Then
			_Enable_Ctrls($old_cursor)
			Return MsgBox(16 + 262144, "Error", '"' & $file & '" is empty (0 kb)', 30, $hGUI)
		EndIf
		$VarName = StringRegExpReplace(GUICtrlRead($idInput_Var), "[^\w]", "")
		If $VarName = "" Then
			_Enable_Ctrls($old_cursor)
			Return MsgBox(16 + 262144, "Error", "Variable / function name is empty!", 30, $hGUI)
		EndIf
		$fHandle = FileOpen($file, 16)
		$BinaryString = FileRead($fHandle)
		FileClose($fHandle)
		$bSize = BinaryLen($BinaryString)
		If $compression Then
			$BinaryStringComp = Compress($BinaryString)
			$BinStringLen = BinaryLen($BinaryStringComp)
			Local $SavedPerc = 100 - (100 * $BinStringLen / $bSize)
			GUICtrlSetData($idLabel_SavedPerc, StringFormat("%05.2f %s", $SavedPerc, "%"))
			If $SavedPerc >= 0 Then
				GUICtrlSetData($idLabel_Length_C_n, StringFormat("%.2f %s", BinaryLen($BinaryStringComp) / 1024, "kb"))
				GUICtrlSetColor($idLabel_SavedPerc, 0x008000)
				$BinaryString = $BinaryStringComp
			Else
				GUICtrlSetData($idLabel_Length_C_n, StringFormat("%.2f %s", $bSize / 1024, "kb"))
				$ToolTip = True
				$compression = False
				GUICtrlSetState($idCheckbox_Compression,  $GUI_UNCHECKED)
				GUICtrlSetColor($idLabel_SavedPerc, 0x800000)
				$aCoord = ControlGetPos($hGUI, "", $idLabel_SavedPerc)
				$tPoint = DllStructCreate("int X;int Y")
				DllStructSetData($tPoint, "X", $aCoord[0] + 20)
				DllStructSetData($tPoint, "Y", $aCoord[1] + 12)
				_WinAPI_ClientToScreen($hGUI, $tPoint)
				ToolTip("Size is larger than original size!" & @LF & "Compression disabled!", DllStructGetData($tPoint, "X"), DllStructGetData($tPoint, "Y"), "Warning", 2, 1)
				AdlibRegister("ToolTip_Off", 5000)
			EndIf
			$BinaryStringComp = 0
		Else
			GUICtrlSetData($idLabel_SavedPerc, StringFormat("%05.2f %s", 0, "%"))
		EndIf
		$BinaryString = _Base64Encode($BinaryString)
		$BinStringLen = StringLen($BinaryString)
		$BinarySuffix = StringRight($BinaryString, Mod($BinStringLen, $LineLen))
		Create_Function($Script, $VarName, $BinaryString, $BinStringLen, $LineLen, $compression, $BinarySuffix)
		_GUICtrlRichEdit_SetText($hRichEdit, "")
		If $decomp_function Then
			If Not $compressed Then
				_GUICtrlRichEdit_InsertText($hRichEdit, $Script & $Script_Base64Decode)
			Else
				_GUICtrlRichEdit_InsertText($hRichEdit, $Script & $Script_Base64Decode & $Decompress_Func)
			EndIf
		Else
			_GUICtrlRichEdit_InsertText($hRichEdit, $Script)
		EndIf
	EndIf
	_Enable_Ctrls($old_cursor)
	$converted = True
EndFunc   ;==>Convert

Func Create_Function(ByRef $Script, $VarName, $BinaryString, $BinStringLen, $LineLen, $compression, $BinarySuffix)
	$Script &= "Func _" & $VarName & "()" & @LF & @TAB & "Local $" & $VarName & @LF
	If $BinStringLen > $LineLen Then
		Local $aBinString = StringRegExp($BinaryString, ".{" & $LineLen & "}", 3)
		For $i = 0 To UBound($aBinString) - 1
			$Script &= @TAB & "$" & $VarName & " &= '" & $aBinString[$i] & "'" & @LF
		Next
		$Script &= @TAB & "$" & $VarName & " &= '" & $BinarySuffix & "'" & @LF
	Else
		$Script &= @TAB & "$" & $VarName & " &= '" & $BinaryString & "'" & @LF
	EndIf
	If Not $compression Then
		$Script &= @TAB & "Return Binary(_Base64Decode($" & $VarName & "))" & @LF & "EndFunc   ;==>_" & $VarName & @LF & @LF
		$compressed = False
	Else
		$Script &= @TAB & "$" & $VarName & " = _Base64Decode($" & $VarName & ")" & @LF
		$Script &= @TAB & "Local $tSource = DllStructCreate('byte[' & BinaryLen($" & $VarName & ") & ']')" & @LF
		$Script &= @TAB & "DllStructSetData($tSource, 1, $" & $VarName & ")" & @LF
		$Script &= @TAB & "Local $tDecompress" & @LF
		$Script &= @TAB & "_WinAPI_LZNTDecompress($tSource, $tDecompress)" & @LF
		$Script &= @TAB & "$tSource = 0" & @LF
		$Script &= @TAB & "Return Binary(DllStructGetData($tDecompress, 1))" & @LF
		$Script &= "EndFunc   ;==>_" & $VarName & @LF & @LF
		$compressed = True
	EndIf
EndFunc   ;==>Create_Function

Func _Enable_Ctrls($old_cursor)
	GUICtrlSetState($idButton_Convert, $GUI_ENABLE)
	GUISetCursor($old_cursor, 1, $hGUI)
	GUISetState(@SW_ENABLE, $hGUI)
EndFunc   ;==>_Enable_Ctrls

Func Compress($binString)
	Local $tCompressed
	Local $tSource = DllStructCreate('byte[' & BinaryLen($binString) & ']')
	DllStructSetData($tSource, 1, $binString)
	_WinAPI_LZNTCompress($tSource, $tCompressed, $compression_strength)
	Local $binCompressed = DllStructGetData($tCompressed, 1)
	$tSource = 0
	Return Binary($binCompressed)
EndFunc   ;==>Compress

Func ToolTip_Off()
	$ToolTip = False
	ToolTip("")
	AdlibUnRegister("ToolTip_Off")
EndFunc   ;==>ToolTip_Off

Func Load_File()
	ToolTip("")
	Local $file = FileOpenDialog("Select any file to convert to base64 string", "", "Files (*.*)", 3 + 4, "", $hGUI), $c, $s
	If @error Then Return MsgBox(64 + 262144, "Warning", "Selection has been aborted!", 30, $hGUI)
	_GUICtrlRichEdit_SetText($hRichEdit, "")
	Local $fSize
	$aFiles = StringSplit($file, "|", 2)
	If Not @error Then
		$aFiles[0] &= "\"
		For $c = 1 To UBound($aFiles) - 1
			$s += FileGetSize($aFiles[0] & $aFiles[$c])
		Next
		If $s > $limit Then Return MsgBoxEx(" No, I'm not ;-) ", 48 + 262144, "Limit of " & Round($limit / 1024^2, 2) & " MB exceeded. Crazy?", Round($s / 1024^2, 2) & "MB. Are you nuts to convert this size of files?", 60, $hGUI)
		$multiselect = True
		$compressed2 = False
		GUICtrlSetData($idLabel_MS_state, "True")
		GUICtrlSetState($idInput_Var, $GUI_DISABLE)
		$sFiles = UBound($aFiles) - 1 & " files selected!" & @LF & "Ready!"
		_GUICtrlRichEdit_SetText($hRichEdit, $sFiles)
	Else
		$fSize = FileGetSize($file)
		If $fSize > $limit Then Return MsgBoxEx(" No, I'm not ;-) ", 48 + 262144, "Limit of" & Round($limit / 1024^2, 2) & " MB exceeded. Crazy?", Round($fSize / 1024^2, 2) & " MB. Are you nuts to convert this size of file?", 60, $hGUI)
		ReDim $aFiles[2]
		Local $aSplit = StringRegExp($file, "(.*\\)(.*)", 3)
		$aFiles[0] = $aSplit[0]
		$aFiles[1] = $aSplit[1]
		$multiselect = False
		GUICtrlSetData($idLabel_MS_state, "False")
		GUICtrlSetState($idInput_Var, $GUI_ENABLE)
		_GUICtrlRichEdit_SetText($hRichEdit, "Ready.")
	EndIf
	If Not $multiselect Then
		GUICtrlSetData($idLabel_Lenght_n, StringFormat("%.2f %s", FileGetSize($file) / 1024, "kb"))
		GUICtrlSetData($idLabel_Length_C_n, StringFormat("%.2f %s", 0, "kb"))
		GUICtrlSetData($idLabel_SavedPerc, StringFormat("%05.2f %s", 0, "%"))
	EndIf
	$Script = ""
	GUICtrlSetColor($idLabel_SavedPerc, 0x00000)

	GUICtrlSetData($idInput_File, _ArrayToString($aFiles, ",", 1))
	GUICtrlSetState($idButton_Convert, $GUI_ENABLE)
	$converted = False
EndFunc   ;==>Load_File

Func Save_File()
	Local $filename = FileSaveDialog("Save", "", "AutoIt Format (*.au3)", 18, "", $hGUI)
	If @error Then Return MsgBox(48 + 262144, "Warning", "Save was aborted!", 30, $hGUI)
	If StringRight($filename, 4) <> ".au3" Then $filename &= ".au3"
	Local $hFile = FileOpen($filename, 2)
	If $hFile = -1 Then Return MsgBox(16 + 262144, "Error", "Unable to create '" & $filename & "'!", 30, $hGUI)
	FileWrite($hFile, _GUICtrlRichEdit_GetText($hRichEdit))
	FileClose($hFile)
	Return MsgBox(64 + 262144, "Information", "Text was properly saved to '" & $filename & "'!", 30, $hGUI)
EndFunc   ;==>Save_File

Func Display_Statistic($array)
	GUISetState(@SW_DISABLE, $hGUI)
	GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")
	Local $w = 500, $h = 600
	Local $hGUI_stat = GUICreate("Statistic", $w, $h, -1, -1, Default, Default, $hGUI)
	$hListView = _GUICtrlListView_Create($hGUI_stat, "", 0, 0, $w, $h)
	_GUICtrlListView_SetExtendedListViewStyle($hListView, BitOR($LVS_EX_GRIDLINES, $LVS_EX_DOUBLEBUFFER, $LVS_EX_FULLROWSELECT))
	_GUICtrlListView_InsertColumn($hListView, 0, "File Name", 170)
	_GUICtrlListView_InsertColumn($hListView, 1, "File Size (bytes)", 100)
	_GUICtrlListView_InsertColumn($hListView, 2, "Compressed Size (bytes)", 130)
	_GUICtrlListView_InsertColumn($hListView, 3, "Saved (%)", 80)
	_GUICtrlListView_BeginUpdate($hListView)
	_GUICtrlListView_AddArray($hListView, $array)
	GUISetState(@SW_SHOW, $hGUI_stat)
	Local $t = TimerInit()
	Local $dt = 120 * 1000
	Do
		If TimerDiff($t) > $dt Then ExitLoop
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUISetState(@SW_ENABLE, $hGUI)
	GUIDelete($hGUI_stat)
	GUIRegisterMsg($WM_NOTIFY, "")
EndFunc   ;==>Display_Statistic

Func _Credits()
	GUIRegisterMsg($WM_SYSCOMMAND, "")
	GUICtrlSetState($idButton_Convert, $GUI_DISABLE)
	GUICtrlSetState($idButton_Clipboard, $GUI_DISABLE)
	GUICtrlSetState($idButton_File, $GUI_DISABLE)
	GUICtrlSetState($idButton_Save, $GUI_DISABLE)
	GUICtrlSetState($idCheckbox_Compression, $GUI_DISABLE)
	GUICtrlSetState($idCheckbox_decompFunction, $GUI_DISABLE)
	GUICtrlSetState($idInput_Var, $GUI_DISABLE)

	ToolTip("")
	Opt("GUIOnEventMode", 1)
	Local $sleep = 400
	Local $save = _GUICtrlRichEdit_GetText($hRichEdit)
	_GUICtrlRichEdit_SetText($hRichEdit, "")
	_GUICtrlRichEdit_SetParaAlignment($hRichEdit, "c")
	_GUICtrlRichEdit_AppendText($hRichEdit, "{\rtf1\utf8{\colortbl;\red16\green16\blue16;}\cf1 {\fs24 {\b " & $title & $ver & "}}\cf0 \line \line }")
	Sleep($sleep)
	Local $Image_UEZ = StringMid(Image_UEZ(), 31)
	Local $binRtf = '{\rtf1{\pict\dibitmap ' & $Image_UEZ & '}}'
	_GUICtrlRichEdit_AppendText($hRichEdit, @LF)
	_GUICtrlRichEdit_AppendText($hRichEdit, "{\rtf1\utf8{\colortbl;\red128\green128\blue255;}\cf1 {\fs32 {\b   Coded by}}\cf0 \line \line }")
	Sleep(1000)
	_GUICtrlRichEdit_AppendText($hRichEdit, $binRtf)
	_GUICtrlRichEdit_AppendText($hRichEdit, @LF & @LF & @LF & @LF)
	Sleep($sleep)
	_GUICtrlRichEdit_AppendText($hRichEdit, "{\rtf1\utf8{\colortbl;\red0\green128\blue0;}\cf1 {\fs28 {\i  Credits to:}}\cf0 \line \line }")
	Sleep(600)
	_GUICtrlRichEdit_SetFont($hRichEdit, 10, "Times Roman")
	Local $text =	"Ward for the _Base64Encode() and MsgBoxEx() functions." & @LF & @LF & _
							"trancexx for the LZNTCompress / LZNTDecompress and _Base64Decode() functions!" & @LF & @LF & @LF & _
							"Press ESC to go back to main screen!" & @LF & @LF
	Local $aText = StringSplit($text, "", 2), $i
	For $i = 0 To UBound($aText) - 1
		_GUICtrlRichEdit_AppendText($hRichEdit, $aText[$i])
		Sleep(20)
	Next
	Local $dll = DllOpen("user32.dll")
	While Not _IsPressed("1B", $dll) * Sleep(50)
	WEnd
	DllClose($dll)
	_GUICtrlRichEdit_SetText($hRichEdit, "")
	_GUICtrlRichEdit_SetParaAlignment($hRichEdit, "l")
	_GUICtrlRichEdit_PauseRedraw($hRichEdit)
	_GUICtrlRichEdit_SetCharColor($hRichEdit, 0x000000)
	_GUICtrlRichEdit_AppendText($hRichEdit, $save)
	_GUICtrlRichEdit_ResumeRedraw($hRichEdit)
	Opt("GUIOnEventMode", 0)

	GUIRegisterMsg($WM_SYSCOMMAND, "WM_SYSCOMMAND")
	GUICtrlSetState($idButton_Convert, $GUI_ENABLE)
	GUICtrlSetState($idButton_Clipboard, $GUI_ENABLE)
	GUICtrlSetState($idButton_File, $GUI_ENABLE)
	GUICtrlSetState($idButton_Save, $GUI_ENABLE)
	GUICtrlSetState($idCheckbox_Compression, $GUI_ENABLE)
	GUICtrlSetState($idCheckbox_decompFunction, $GUI_ENABLE)
	GUICtrlSetState($idInput_Var, $GUI_ENABLE)
EndFunc

#region WM functions
Func WM_ACTIVATEAPP($hWnd, $Msg, $wParam, $lParam)
	#forceref $hWnd, $Msg, $lParam
	If Not $wParam Then ;GUI lost focus
		$ToolTip = False
		ToolTip("")
	EndIf
	Return "GUI_RUNDEFMSG"
EndFunc   ;==>MY_WM_ACTIVATEAPP

Func WM_NOTIFY($hWnd, $Msg, $wParam, $lParam)
	#forceref $hWnd, $Msg, $wParam
	If IsHWnd($hListView) Then
		$hWndListView = $hListView
	Else
		$hWndListView = GUICtrlGetHandle($hListView)
	EndIf
	Local $tNMHDR = DllStructCreate($tagNMHDR, $lParam)
	$hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
	$iIDFrom = DllStructGetData($tNMHDR, "IDFrom")
	$iCode = DllStructGetData($tNMHDR, "Code")
	Switch $hWndFrom
		Case $hWndListView
			Switch $iCode
				Case $NM_CUSTOMDRAW
					Local $tCustDraw = DllStructCreate($tagNMLVCUSTOMDRAW, $lParam)
					Local $iDrawStage = DllStructGetData($tCustDraw, "dwDrawStage")
					If $iDrawStage = $CDDS_PREPAINT Then Return $CDRF_NOTIFYITEMDRAW
					If $iDrawStage = $CDDS_ITEMPREPAINT Then Return $CDRF_NOTIFYSUBITEMDRAW
					Local $iItem = DllStructGetData($tCustDraw, "dwItemSpec")
					Local $iSubItem = DllStructGetData($tCustDraw, "iSubItem")
					Local $iColor = 0x000000
					If $iSubItem = 3 Then
						If $aStatistic[$iItem][$iSubItem] < 0 Then
							$iColor = 0x0000C0
							Local $hDC = DllStructGetData($tCustDraw, 'hdc')
							Local $FORMATLV_hFONT = _WinAPI_CreateFont(14, 0, 0, 0, $FW_BOLD, False, False, False, $DEFAULT_CHARSET, $OUT_DEFAULT_PRECIS, _
									$CLIP_DEFAULT_PRECIS, $DEFAULT_QUALITY, 0)
							_WinAPI_SelectObject($hDC, $FORMATLV_hFONT)
							_WinAPI_DeleteObject($FORMATLV_hFONT)
						Else
							$iColor = 0x00C000
						EndIf
					EndIf
					DllStructSetData($tCustDraw, "clrText", $iColor)
			EndSwitch
	EndSwitch
	Return "GUI_RUNDEFMSG"
EndFunc   ;==>WM_NOTIFY

Func WM_COMMAND($hWnd, $Msg, $wParam, $lParam)
	#forceref $hWnd, $Msg, $lParam
	If $converted Then
		If $multiselect Then
			SetRichText($compressed2, $wParam)
		Else
			SetRichText($compressed, $wParam)
		EndIf
	EndIf

	Switch $wParam
		Case $id_Standard
			_GUICtrlMenu_CheckRadioItem($hQMenu_Sub, 0, 1, 0)
			$compression_strength = 0
		Case $id_High
			_GUICtrlMenu_CheckRadioItem($hQMenu_Sub, 0, 1, 1)
			$compression_strength = 1
	EndSwitch

	Return "GUI_RUNDEFMSG"
EndFunc   ;==>WM_COMMAND

Func SetRichText($mode, $wParam)
	Switch $mode
		Case 0
			Switch $wParam
				Case $idCheckbox_Compression
					If BitAND(GUICtrlRead($idCheckbox_Compression), $GUI_CHECKED) Then
						_GUICtrlRichEdit_SetText($hRichEdit, "")
					Else
						If BitAND(GUICtrlRead($idCheckbox_decompFunction), $GUI_UNCHECKED) Then
							_GUICtrlRichEdit_InsertText($hRichEdit, $Script)
						Else
							_GUICtrlRichEdit_InsertText($hRichEdit, $Script & $Script_Base64Decode)
						EndIf
					EndIf
				Case $idCheckbox_decompFunction
					_GUICtrlRichEdit_SetText($hRichEdit, "")
					If BitAND(GUICtrlRead($idCheckbox_Compression), $GUI_UNCHECKED) Then
						If BitAND(GUICtrlRead($idCheckbox_decompFunction), $GUI_CHECKED) Then
							_GUICtrlRichEdit_InsertText($hRichEdit, $Script & $Script_Base64Decode)
						Else
							_GUICtrlRichEdit_InsertText($hRichEdit, $Script)
						EndIf
					EndIf
			EndSwitch
		Case 1
			Switch $wParam
				Case $idCheckbox_Compression
					If BitAND(GUICtrlRead($idCheckbox_Compression), $GUI_UNCHECKED) Then
						_GUICtrlRichEdit_SetText($hRichEdit, "")
					Else
						If BitAND(GUICtrlRead($idCheckbox_decompFunction), $GUI_UNCHECKED) Then
							_GUICtrlRichEdit_InsertText($hRichEdit, $Script)
						Else
							_GUICtrlRichEdit_InsertText($hRichEdit, $Script & $Decompress_Func)
						EndIf
					EndIf
				Case $idCheckbox_decompFunction
					If BitAND(GUICtrlRead($idCheckbox_Compression), $GUI_CHECKED) Then
						_GUICtrlRichEdit_SetText($hRichEdit, "")
						If BitAND(GUICtrlRead($idCheckbox_decompFunction), $GUI_UNCHECKED) Then
							_GUICtrlRichEdit_InsertText($hRichEdit, $Script)
						Else
							_GUICtrlRichEdit_InsertText($hRichEdit, $Script & $Script_Base64Decode & $Decompress_Func)
						EndIf
					EndIf
			EndSwitch
	EndSwitch
EndFunc   ;==>SetRichText

Func WM_CONTEXTMENU($hWnd, $Msg, $wParam, $lParam)
	#forceref $hWnd, $Msg, $wParam, $lParam
	Local $mi = GUIGetCursorInfo()
	If Not @error Then
		If $mi[4] = $idCheckbox_Compression Then
			_GUICtrlMenu_TrackPopupMenu($hQMenu, $hWnd)
			Return True
		EndIf
	EndIf
	Return "GUI_RUNDEFMSG"
EndFunc   ;==>WM_CONTEXTMENU

Func WM_MOVING($hWnd, $Msg, $wParam, $lParam)
	#forceref $hWnd, $Msg, $wParam, $lParam
	Local $iX, $iY
	If $ToolTip Then
		$aCoord = ControlGetPos($hGUI, "", $idLabel_SavedPerc)
		$tPoint = DllStructCreate("int X;int Y")
		DllStructSetData($tPoint, "X", $aCoord[0] + 20)
		DllStructSetData($tPoint, "Y", $aCoord[1] + 12)
		_WinAPI_ClientToScreen($hGUI, $tPoint)
		$iX = DllStructGetData($tPoint, "X")
		$iY = DllStructGetData($tPoint, "Y")
		If $iX <> $Prev_Coord[0] Or $iY <> $Prev_Coord[1] Then
			ToolTip("Size is larger than original size!" & @LF & "Compression disabled!", $iX, $iY, "Warning", 2, 1)
			$Prev_Coord[0] = $iX
			$Prev_Coord[1] = $iY
		EndIf
		$tPoint = 0
	EndIf
EndFunc   ;==>WM_MOVING

Func WM_SYSCOMMAND($hWnd, $Msg, $wParam, $lParam)
	#forceref $hWnd, $Msg, $lParam
	Local $idFrom
	$idFrom = BitAND($wParam, 0x0000FFFF)
	Switch $idFrom
		Case $id_About
			_Credits()
	EndSwitch
	Return "GUI_RUNDEFMSG"
EndFunc   ;==>WM_SYSCOMMAND
#endregion

#region additional functions
Func MsgBoxEx($CustomButton, $Flag, $Title, $Text, $Timeout = 0, $Hwnd = 0) ;thanks to Ward
    Assign("MsgBoxEx:CustomButton", $CustomButton, 2)
    Local $CBT_ProcCB = DllCallbackRegister("MsgBoxEx_CBT_Proc", "long", "int;hwnd;lparam")
    Local $CBT_Hook = _WinAPI_SetWindowsHookEx($WH_CBT, DllCallbackGetPtr($CBT_ProcCB), 0, _WinAPI_GetCurrentThreadId())
    Local $Ret = MsgBox($Flag, $Title, $Text, $Timeout, $Hwnd)
    Local $Error = @Error
    _WinAPI_UnhookWindowsHookEx($CBT_Hook)
    DllCallbackFree($CBT_ProcCB)
    Assign("MsgBoxEx:CustomButton", 0, 2)
    Return SetError($Error, 0, $Ret)
EndFunc   ;==>MsgBoxEx

Func MsgBoxEx_CBT_Proc($nCode, $wParam, $lParam) ;thanks to Ward
    If $nCode = 5 Then ; HCBT_ACTIVATE
        Local $CustomButton = StringSplit(Eval("MsgBoxEx:CustomButton"), "|")
        For $i = 1 To $CustomButton[0]
            ControlSetText($wParam, "", $i, $CustomButton[$i])
        Next
    EndIf
    Return _WinAPI_CallNextHookEx(0, $nCode, $wParam, $lParam)
EndFunc   ;==>MsgBoxEx_CBT_Proc

Func _Base64Decode($input_string) ;code by trancexx
	Local $struct = DllStructCreate("int")
	Local $a_Call = DllCall("Crypt32.dll", "int", "CryptStringToBinary", "str", $input_string, "int", 0, "int", 1, "ptr", 0, "ptr", DllStructGetPtr($struct, 1), "ptr", 0, "ptr", 0)
	If @error Or Not $a_Call[0] Then Return SetError(1, 0, "")
	Local $a = DllStructCreate("byte[" & DllStructGetData($struct, 1) & "]")
	$a_Call = DllCall("Crypt32.dll", "int", "CryptStringToBinary", "str", $input_string, "int", 0, "int", 1, "ptr", DllStructGetPtr($a), "ptr", DllStructGetPtr($struct, 1), "ptr", 0, "ptr", 0)
	If @error Or Not $a_Call[0] Then Return SetError(2, 0, "")
	Return DllStructGetData($a, 1)
EndFunc   ;==>_Base64Decode

; #FUNCTION# ====================================================================================================================
; Name...........: 	_WinAPI_LZNTCompress
; Description....: 	Compresses an input data.
; Syntax.........: 	_WinAPI_LZNTCompress ( $tInput, ByRef $tOutput [, $fMaximum] )
; Parameters.....: 	$tInput   - "byte[n]" or any other structure that contains the data to be compressed.
;                  			$tOutput  - "byte[n]" structure that is created by this function, and contain the compressed data.
;                  			$fMaximum - Specifies whether use a maximum data compression, valid values:
;                  			|TRUE     - Uses an algorithm which provides maximum data compression but with relatively slower performance.
;                  			|FALSE    - Uses an algorithm which provides a balance between data compression and performance. (Default)
; Return values..:	Success   - The size of the compressed data, in bytes.
;                  			Failure   - 0 and sets the @error flag to non-zero, @extended flag may contain the NTSTATUS code.
; Author.........: 	trancexx
; Modified.......: 	Yashied, UEZ
; Remarks........: 	The input and output buffers must be different, otherwise, the function fails.
; Related........:
; Link...........: 		@@MsdnLink@@ RtlCompressBuffer
; Example........: 	Yes
; ===============================================================================================================================
Func _WinAPI_LZNTCompress(ByRef $tInput, ByRef $tOutput, $fMaximum = True)
	Local $tBuffer, $tWorkSpace, $Ret
	Local $COMPRESSION_FORMAT_LZNT1 = 0x0002, $COMPRESSION_ENGINE_MAXIMUM = 0x0100
	If $fMaximum Then $COMPRESSION_FORMAT_LZNT1 = BitOR($COMPRESSION_FORMAT_LZNT1, $COMPRESSION_ENGINE_MAXIMUM)
	$tOutput = 0
	$Ret = DllCall('ntdll.dll', 'uint', 'RtlGetCompressionWorkSpaceSize', 'ushort', $COMPRESSION_FORMAT_LZNT1, 'ulong*', 0, 'ulong*', 0)
	If @error Then Return SetError(1, 0, 0)
	If $Ret[0] Then Return SetError(2, $Ret[0], 0)
	$tWorkSpace = DllStructCreate('byte[' & $Ret[2] & ']')
	$tBuffer = DllStructCreate('byte[' & (2 * DllStructGetSize($tInput)) & ']')
	$Ret = DllCall('ntdll.dll', 'uint', 'RtlCompressBuffer', 'ushort', $COMPRESSION_FORMAT_LZNT1, 'ptr', DllStructGetPtr($tInput), 'ulong', DllStructGetSize($tInput), 'ptr', DllStructGetPtr($tBuffer), 'ulong', DllStructGetSize($tBuffer), 'ulong', 4096, 'ulong*', 0, 'ptr', DllStructGetPtr($tWorkSpace))
	If @error Then Return SetError(3, 0, 0)
	If $Ret[0] Then Return SetError(4, $Ret[0], 0)
	$tOutput = DllStructCreate('byte[' & $Ret[7] & ']')
	If Not _WinAPI_MoveMemory(DllStructGetPtr($tOutput), DllStructGetPtr($tBuffer), $Ret[7]) Then
		$tOutput = 0
		Return SetError(5, 0, 0)
	EndIf
	Return $Ret[7]
EndFunc   ;==>_WinAPI_LZNTCompress

Func _WinAPI_MoveMemory($pDestination, $pSource, $iLenght)
	DllCall('ntdll.dll', 'none', 'RtlMoveMemory', 'ptr', $pDestination, 'ptr', $pSource, 'ulong_ptr', $iLenght)
	If @error Then Return SetError(1, 0, 0)
	Return 1
EndFunc   ;==>_WinAPI_MoveMemory

Func _Base64EncodeInit($LineBreak = 76) ;code by Ward
	If Not IsDllStruct($_B64E_CodeBuffer) Then
		If @AutoItX64 Then
			Local $Opcode = '0x89C08D42034883EC0885D2C70100000000C64104000F49C2C7410800000000C1F80283E20389410C740683C00189410C4883C408C389C94883EC3848895C242848897424304889CB8B0A83F901742083F9024889D87444C6000A4883C001488B74243029D8488B5C24284883C438C30FB67204E803020000BA3D0000004080FE3F7F08480FBEF60FB614308813C643013D488D4303C643023DEBBC0FB67204E8D7010000BA3D0000004080FE3F7F08480FBEF60FB614308813C643013D488D4302EB9489DB4883EC68418B014863D248895C242848897424304C89C348897C24384C896424484C89CE83F80148896C24404C896C24504C897424584C897C24604C8D2411410FB6790474434D89C64989CD0F82F700000083F8024C89C5747B31C0488B5C2428488B742430488B7C2438488B6C24404C8B6424484C8B6C24504C8B7424584C8B7C24604883C468C34C89C54989CF4D39E70F840B010000450FBE374D8D6F014489F025F0000000C1F80409C7E8040100004080FF3FBA3D0000007F08480FBEFF0FB614384489F78855004883C50183E70FC1E7024D39E50F84B2000000450FB675004983C5014489F025C0000000C1F80609C7E8BD0000004080FF3FBA3D0000007F08480FBEFF0FB61438BF3F0000008855004421F74C8D7502E896000000480FBED70FB604108845018B460883C0013B460C89460875104C8D7503C645020AC7460800000000904D39E5742E410FBE7D004D8D7D01498D6E01E8560000004889FA83E70348C1EA02C1E70483E23F0FB60410418806E913FFFFFF4489F040887E04C7060000000029D8E9CCFEFFFF89E840887E04C7060200000029D8E9B9FEFFFF89E840887E04C7060100000029D8E9A6FEFFFFE8400000004142434445464748494A4B4C4D4E4F505152535455565758595A6162636465666768696A6B6C6D6E6F707172737475767778797A303132333435363738392B2F58C3'
		Else
			Local $Opcode = '0x89C08B4C24088B44240489CAC1FA1FC1EA1E01CAC1FA0283E103C70000000000C6400400C740080000000089500C740683C20189500CC2100089C983EC0C8B4C2414895C24048B5C2410897424088B1183FA01741D83FA0289D87443C6000A83C0018B74240829D88B5C240483C40CC210000FB67104E80C020000BA3D00000089F180F93F7F0989F20FBEF20FB6143088138D4303C643013DC643023DEBBD0FB67104E8DF010000BA3D00000089F180F93F7F0989F20FBEF20FB6143088138D4302C643013DEB9489DB83EC3C895C242C8B5C244C896C24388B542440897424308B6C2444897C24348B030FB6730401D583F801742D8B4C24488954241C0F820101000083F80289CF747D31C08B5C242C8B7424308B7C24348B6C243883C43CC210008B4C244889D739EF0F84400100008D57010FBE3F89542418894C241489F825F0000000C1F80409C6897C241CE8330100008B542418C644240C3D8B4C241489C789F03C3F7F0B0FBEF00FB604378844240C0FB644240C8D790188018B74241C83E60FC1E60239EA0F84CB0000000FB60A83C2018954241C89C825C0000000C1F80609C6884C2414E8D8000000BA3D0000000FB64C24148944240C89F03C3F7F0B0FBEF08B44240C0FB6143083E13F881789CEE8AD00000089F10FBED18D4F020FB604108847018B430883C0013B430C894308750EC647020A8D4F03C7430800000000396C241C743A8B44241C8B7C241C0FBE30894C241483C701E8650000008B4C241489F283E60381E2FC000000C1EA02C1E6040FB60410880183C101E9E4FEFFFF89F088430489C8C703000000002B442448E9B2FEFFFF89F189F8884B04C703020000002B442448E99CFEFFFF89F088430489C8C703010000002B442448E986FEFFFFE8400000004142434445464748494A4B4C4D4E4F505152535455565758595A6162636465666768696A6B6C6D6E6F707172737475767778797A303132333435363738392B2F58C3'
		EndIf
		$_B64E_Init = (StringInStr($Opcode, "89C0") - 3) / 2
		$_B64E_EncodeData = (StringInStr($Opcode, "89DB") - 3) / 2
		$_B64E_EncodeEnd = (StringInStr($Opcode, "89C9") - 3) / 2
		$Opcode = Binary($Opcode)

		$_B64E_CodeBufferMemory = _MemVirtualAlloc(0, BinaryLen($Opcode), $MEM_COMMIT, $PAGE_EXECUTE_READWRITE)
		$_B64E_CodeBuffer = DllStructCreate("byte[" & BinaryLen($Opcode) & "]", $_B64E_CodeBufferMemory)
		DllStructSetData($_B64E_CodeBuffer, 1, $Opcode)
		OnAutoItExitRegister("_B64E_Exit")
	EndIf

	Local $State = DllStructCreate("byte[16]")
	DllCall("user32.dll", "none", "CallWindowProc", "ptr", DllStructGetPtr($_B64E_CodeBuffer) + $_B64E_Init, _
													"ptr", DllStructGetPtr($State), _
													"uint", $LineBreak, _
													"int", 0, _
													"int", 0)
	Return $State
EndFunc   ;==>_Base64EncodeInit

Func _Base64EncodeData(ByRef $State, $Data) ;code by Ward
	If Not IsDllStruct($_B64E_CodeBuffer) Or Not IsDllStruct($State) Then Return SetError(1, 0, "")
	$Data = Binary($Data)
	Local $InputLen = BinaryLen($Data)
	Local $Input = DllStructCreate("byte[" & $InputLen & "]")
	DllStructSetData($Input, 1, $Data)
	Local $OputputLen = Ceiling(BinaryLen($Data) * 1.4) + 3
	Local $Output = DllStructCreate("char[" & $OputputLen & "]")
	DllCall("user32.dll", "int", "CallWindowProc", "ptr", DllStructGetPtr($_B64E_CodeBuffer) + $_B64E_EncodeData, _
													"ptr", DllStructGetPtr($Input), _
													"uint", $InputLen, _
													"ptr", DllStructGetPtr($Output), _
													"ptr", DllStructGetPtr($State))

	Return DllStructGetData($Output, 1)
EndFunc   ;==>_Base64EncodeData

Func _Base64EncodeEnd(ByRef $State) ;code by Ward
	If Not IsDllStruct($_B64E_CodeBuffer) Or Not IsDllStruct($State) Then Return SetError(1, 0, "")
	Local $Output = DllStructCreate("char[5]")
	DllCall("user32.dll", "int", "CallWindowProc", "ptr", DllStructGetPtr($_B64E_CodeBuffer) + $_B64E_EncodeEnd, _
													"ptr", DllStructGetPtr($Output), _
													"ptr", DllStructGetPtr($State), _
													"int", 0, _
													"int", 0)
	Return DllStructGetData($Output, 1)
EndFunc   ;==>_Base64EncodeEnd

Func _Base64Encode($Data, $LineBreak = 0) ;code by Ward - modified by UEZ
	Local $State = _Base64EncodeInit($LineBreak)
	Return StringReplace(StringStripCR(_Base64EncodeData($State, $Data) & _Base64EncodeEnd($State)), @LF, "")
EndFunc   ;==>_Base64Encode

Func _B64E_Exit() ;code by Ward
	$_B64E_CodeBuffer = 0
	_MemVirtualFree($_B64E_CodeBufferMemory, 0, $MEM_RELEASE)
EndFunc   ;==>_B64E_Exit

Func _WinAPI_LZNTDecompress(ByRef $tInput, ByRef $tOutput, $iBufferSize = 0x800000)
	Local $tBuffer, $Ret
	$tOutput = 0
	$tBuffer = DllStructCreate('byte[' & $iBufferSize & ']')
	If @error Then Return SetError(1, 0, 0)
	$Ret = DllCall('ntdll.dll', 'uint', 'RtlDecompressBuffer', 'ushort', 0x0002, 'ptr', DllStructGetPtr($tBuffer), 'ulong', $iBufferSize, 'ptr', DllStructGetPtr($tInput), 'ulong', DllStructGetSize($tInput), 'ulong*', 0)
	If @error Then Return SetError(2, 0, 0)
	If $Ret[0] Then Return SetError(3, $Ret[0], 0)
	$tOutput = DllStructCreate('byte[' & $Ret[6] & ']')
	If Not _WinAPI_MoveMemory(DllStructGetPtr($tOutput), DllStructGetPtr($tBuffer), $Ret[6]) Then
		$tOutput = 0
		Return SetError(4, 0, 0)
	EndIf
	Return $Ret[6]
EndFunc   ;==>_WinAPI_LZNTDecompress

;======================================================================================
; Function Name:		Load_BMP_From_Mem
; Description:			Loads an image which is saved as a binary string and converts it to a bitmap or hbitmap
;
; Parameters:    		$bImage:				the binary string which contains any valid image which is supported by GDI+
; Optional:  				$hHBITMAP:		if false a bitmap will be created, if true a hbitmap will be created
;
; Remark:					hbitmap format is used generally for GUI internal images, $bitmap is more a GDI+ image format
;
; Requirement(s):		GDIPlus.au3, Memory.au3
; Return Value(s):	Success: handle to bitmap or hbitmap, Error: 0
; Error codes:			1: $bImage is not a binary string
;
; Author(s):				UEZ
; Additional Code:	thanks to progandy for the MemGlobalAlloc and tVARIANT lines
; Version:					v0.95 Build 2011-06-14 Beta
;=======================================================================================
Func Load_BMP_From_Mem($bImage, $hHBITMAP = False)
	If Not IsBinary($bImage) Then Return SetError(1, 0, 0)
	Local $declared = True
	If Not $ghGDIPDll Then
		_GDIPlus_Startup()
		$declared = False
	EndIf
	Local Const $memBitmap = Binary($bImage) ;load image  saved in variable (memory) and convert it to binary
	Local Const $len = BinaryLen($memBitmap) ;get length of image
	Local Const $hData = _MemGlobalAlloc($len, $GMEM_MOVEABLE) ;allocates movable memory  ($GMEM_MOVEABLE = 0x0002)
	Local Const $pData = _MemGlobalLock($hData) ;translate the handle into a pointer
	Local $tMem = DllStructCreate("byte[" & $len & "]", $pData) ;create struct
	DllStructSetData($tMem, 1, $memBitmap) ;fill struct with image data
	_MemGlobalUnlock($hData) ;decrements the lock count  associated with a memory object that was allocated with GMEM_MOVEABLE
	Local $hStream = DllCall("ole32.dll", "int", "CreateStreamOnHGlobal", "handle", $pData, "int", True, "ptr*", 0)
	$hStream = $hStream[3]
	Local $hBitmap = DllCall($ghGDIPDll, "uint", "GdipCreateBitmapFromStream", "ptr", $hStream, "int*", 0) ;Creates a Bitmap object based on an IStream COM interface
	$hBitmap = $hBitmap[2]
	Local Const $tVARIANT = DllStructCreate("word vt;word r1;word r2;word r3;ptr data; ptr")
	DllCall("oleaut32.dll", "long", "DispCallFunc", "ptr", $hStream, "dword", 8 + 8 * @AutoItX64, _
			"dword", 4, "dword", 23, "dword", 0, "ptr", 0, "ptr", 0, "ptr", DllStructGetPtr($tVARIANT)) ;release memory from $hStream to avoid memory leak
	$tMem = 0
	If $hHBITMAP Then
		Local Const $hHBmp = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hBitmap)
		_GDIPlus_BitmapDispose($hBitmap)
		If Not $declared Then _GDIPlus_Shutdown()
		Return $hHBmp
	EndIf
	If Not $declared Then _GDIPlus_Shutdown()
	Return $hBitmap
EndFunc   ;==>Load_BMP_From_Mem
#endregion

#region Base64 strings
Func Compress_Icon()
	Local $Compress_Icon
	$Compress_Icon &= 'iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAMAAAAoLQ9TAAACEFBMVEUAAADCwsK0mlpGRkbQ0NConHyLka0aGhqSpb21xd8eHh83Nzm70elzibk3ODpgYGDh5++70+zGztnx+P3D1OiQkK3Kxrutp5diYmMCAgI9OjLIv6bEokuzpoS0xuDm8frL5PiNkay1m1iKmrq9qG/GxsbZ4evQuHDOsGGpnXuwutPY6/e93vW2ucPe3uDX19c+Oi9lZWXz4beumVysj0DPt3LOsGKonXyrtc7I4vWt1vJ5irrz4bismFsFBgbf4OHOsWS4zOWkrsy63POg0/O1nFv15sCsmFzNu37OtG6TmL+etdqPsNqMj6y0nF306sysmV/IrWHPtXKtn3i+vsV9clGxsbinnIG9nUfp0pmpl2Xg4OGDbzeCbjinn4pERENFQz+4n1vGo0fMqVTBrXnh39jVzK/GoELRrFCpkVG6uLO3t7bFqVnjzZStjjqAdVuCeWCekGnBrGzTsV3hwniykTjKq1zny4W3mUu1tLQSEhLDnD3dumfDplmMgF5xZER7aTeylEXaxIr36cu5mDrUvn737M65omKMka0lJSW6kCfKojqjhzyGd0+DdU6HeEx/aCnQsmTky5G4ki/Jp1HcwoW0lkrOuHarj0Cljk63tbDX1tTLysjGxcO5sZuskEGrj0aliTiojDypjkKkjUzU1NXLy8zb29rMzMwuLi7Yvnt1dXXPz8+zsrnZ2dkBAQF94J3+AAAAAXRSTlMAQObYZgAAAAlwSFlzAAAbrwAAG68BXhqRHAAAAOlJREFUeF5NyFOzwwAUAOGT1LZtX9u2bdu2bds2/mI7babTfdsPsKhkiiMQfGJyjAwuywdodHa0DvFuXKkwkccXyERiifulIXKFUqXWaIv0BjcEmMwWq82+gQYFx3sgNCw8IjKKiMbE+nngPIGQlJxCTE1LxyAjk5CVnZObl1+AQeFXcclvWXlFZVU11NTW1Tc0NjW3tLa1d3R2dUNPb1//wODQ8Mjo2PjEJDIF0zOzc/MLi0vLK6tr6/hNgK3tnd29/YPDo+OT0zM8CeDi8ur65vbu/uHx6fnl1QVv7x+fONz3j7+rP+QfnFHKPe9xFNwIAAAAAElFTkSuQmCC'
	Return Binary(_Base64Decode($Compress_Icon))
EndFunc   ;==>Compress_Icon

Func Info_Icon()
	Local $Info_Icon
	$Info_Icon &= 'iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAMAAAAoLQ9TAAABvFBMVEUAAADv8fUFBQWDtfFUjOQTL5ICBBQICAhelegUO8cpXNUTOMVjm+kFCBZWjOYwNDtNhuQwZ9lLYYwfHyI/eN5pousrY9dJguIOKaJ0qu9wo+twoukIFl4eSbBnoOgNFCt7su9noOkgTbW61fMwZNdEfuJLg+RPiOSMtOsSK5VknelsousJCg53q+/t8fUFD1Y0bNk7dNweSbpRiOS0yu/A0++5z+/A1/MAAgsAAAJhl+iCtPEwZModQKMOJpEKHYZwpe1ckuY2bdqCqObx8/d/sO9jl+ZYkeYcQ7IgIicIG4MkWNMHFFtLf97v8/VbjOSPte1RjORYj+YZP61+su8FDlYdS8wgUc8kVtNAd9pPg+A8d95Ae+BGf+IZO6B/tO8UO8UbRsodTc4gT885bNdGeNw0adk4cNw7d94pXs8yTZF4q+8NJp17sO8YQMonWM+6zOvz9ff19ffB0e87cNktY9kvZNkRMKNUW2kOKrAjO3gcRspnj95zmuB3m+J0muIqXtUjVtEQMLBkm+gOFC0PKqMOLboXP8gZQ8oTO8EOKqISExMJCw4jOXsUMJ3x8/UTL5owTZFUXGwfIieN7tAOAAAAAXRSTlMAQObYZgAAAN9JREFUeF5ty0NzBGEABuH3G65t24pt27Zt23byh1NTm9pTnlsfGv8rbGVZG5fJojBj7qVph13+19kit8VbMEGXlDohKFcpqqwJUrfiWvPEhN/nDwQVoc5ItDLOHANIprJ0Obl5+TfFMr2+jAcqDOpqXU3tRz3TIJI1NgHNLRKDuo20dxhVXd09SqCvf2BQMkTI8MjomHFcC3CTU9Mzs4TMzS8sLi1TAFbF6xubW9s7u3v7B4cAID+SnpyenV9cXl1rKAhu7+6l4ofHp2fNC9Je395Nps+vbwoZ/I9Sm85fvUwsK6pN0U8AAAAASUVORK5CYII='
	Return Binary(_Base64Decode($Info_Icon))
EndFunc   ;==>Info_Icon

Func Image_Btn()
	Local $Image_Btn
	$Image_Btn &= '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'
	$Image_Btn &= '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'
	$Image_Btn &= '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'
	$Image_Btn &= 'PM91Xc+2bbtYLOZyuVy6UCjM53K5c47jTHLOZwzDWNA0LdvY2Fju7u7m4XBYVUYt1yXRXBGsbDYL/rXTlUxSMMZONBp1gsHgMud8LJ/PH8lms1omkzGUUkEACEspIxjjCMa4HiEUQgiZCCG9Ao0KIRgAcKWUq5QqSymLUso8ABQQQkUAKCGEygghLxKJcEqpCgQCyldgoVCAQqFwRRu+0rP9H8KgwQhpvkDgAAAAAElFTkSuQmCC'
	Return Binary(_Base64Decode($Image_Btn))
EndFunc   ;==>Image_Btn

Func Image_Btn2()
	Local $Image_Btn2
	$Image_Btn2 &= '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'
	$Image_Btn2 &= 'uL7tXXHUP0V1axbKg7s6NXH+BgxGaWetcwDIau2cc7DWzgITnoSf8slPpVgQ+MSlICaORU2jNPa8vDWc2t6PposXZeobG/ypQh5eOpALz2mXKk7c5OiE2fz8a5FOFBoXzBWti+bJbDbLA8/n7R3LKIn2xt6yltqend3f+6Pf/vF1yVT5HiVtl1TMnRIsYwzW7nk5+6d33nEXhLy7ZeV8bhMdlyYKak5bC8/ni3ZkaMxWCiVbKZRsWKxYHWnHQGAekUwFxBjD+I4jAGOytq0hEJ4QRMQYYwRG5Iy1nDMHYPpQPgDAWgdrnXPGQCfK5UfzToXDVkfKGaXhnIPM+OSnAioOT5qRV7ut15zxms9ZGIwPj54gVsZINMxrEkmUuLGeQdO/9WCcbq7hLUvmiZqGOpGty1F+dDLJ1KelzCy4Znxf/4pkovxVJe16qZh9W1jWWnzz19/P/vDeH/xt7aLWO3KNKRuHYRJOVnQ4XrC7hjYbxsglU2VLUsCvTZGfS3M/4xNxNvvUy+MFa4oxB8B1pCSA9Gc++In00rbF3PM8mihM2e39+/Terk410jcYh+WKhoWdhjejPwIAJji8LK+ar3XQSeKGtneb8qFxxwIpRNrjI5198HNpJwJJTJw0ISUv7QvpS0SFit2/brv2azO2YXGzUGECHcUmVZtVLasWLeS+/EV+/+BXlDTPvFlh4nhH/qOnf+bd/437/qZ+xYI7co0pxOXIVCaKNhorujgfQhUj50LlwBiJrEe6FFPkF4n7EiQ5wBgROah8SDYxHIKhNDLl33P3X9V8fM2HmMXsZ7MPnXeZiFUSDOZHs/t6D9hXu7eqzp17k7GeoSQuVowzzh5T3rEzhqMFFx7JExNcpBc3cJnxKC6GrjxccC7WjiSDSPvEUx5xzk7ExsC9bACVr7ijrx8wzJMk0pKcI5Ouy+imjrmNFvbHxT0Df+ace/F43zELa9/wIfbtb37nc7lFzXfk5uRYHEYqnCzZaKLk4skKVDkmV1bMagNYg6SiAJRnDjC9G3PTeRIBENAWpa5Rlk1nEOnYvdmhM0Zoq29GW30z++j5V/jRJ2P/6OQwdnbtMS/v36QPbN2bTB4cVEkh0s5Yp/KhNcWEIBgXdQGZckKmnMyqkDiDiw2iQsHZRDsIRtwXxDzxxgqBAWCMGAOpfOhMrMAYd0TOpOpzrKm9tVUXKn8XHp64SUIceQOsSqWCL9//9eU2sd+qmVcfGGV0nK8gKoRICiGZcsJcqMhq43CyADtzLbEn/NoUExarhBKt3jHKMcawoLEVCxpbxScvuUZUbg6DnrF+9/qh7WbD1o360Ct7kvzBYW3KidFTkdWFaOYfT75hrJAUk+k/IUCwNwCbBkhcexQLQSQ5uJQuqMmYxpULzhucCP9aFcOvA4hmYb2+a7Pg3f4drZetmM85N5Vy2SWVBLoUkwkVm45cb1TRqS8WxiGU0W+ZNrxlqBYCy+YupmVzF4svXH6DKN9eCQ4PH3GvHN5qt23apns27FWl7jFtirF5s8me8DwtAG3e/HTAGMEITboSkyoLFgcehCeRyqUos6TxC4Wd/Q875zbMwrKJWZRenLs2lQtglIGNFOlIkVGaOWUJFlXzEqdPChZMKUWxiul0YZ0kKUXHvCW0oq2duStuFKWoEhwa7HEbenaYHZu2m/6N+3Wpb0KbULnj9P4OjxKAdbDakIk16SihJFEQgURtW1O6dGDk80PN8SYARjjnwEAd6aZcO3FGJoqYUdo6pRm0JQAODA4MYKAzYOVYohUlWuGsNp8ASOnhnIUddM7CDmGv/KwoRWX/8NFe91rvDrvz1W2mf/0+nYyV9NuqbsaErSOnNHPKkFOKWWspyAYk64OLnDFNAIbF4JwKkc87/IwvGaoB3Dk3IyEHRo44w5lqgmnLSkmZoiSGhcN7uTzhYcWi5bRi0XJmr/ys2PaHu7wf3Pd9VTw4krwVMCICGKFaqhKcc8w5IlgH5nHyalKtAOYAGBYA'
	$Image_Btn2 &= 'GASrJSkIQLXC5RzEGUEwR5wcExyWnWFPiIgpZxHpGNZa/L6WMRYWjvyMz0uS87eCxVB1/NWEmaNagjsGVu0VMU/4AIJjqYO2JWstgTHixBljIOJkuRRwQjsLgJkzg2WtY6WkgiiJ6b2E5RygtcJUKY+D433YuXe32//ydlfoGjVMcPbWzxKAYCDOQJKIJAdNt0aIiKw2CQA1A8uaWHfZilLS96ROEss8Ae57zEYaNhAOCQHanpEZMctZ7BSUUtDWnEU4DsYYlColdE8dxYGeLvTuO+zGugZcNFKwVhsHACQZHd9EPJmySHJwn4P7HglPQHiSCSEAgJKpynCmsXYcAMS8sYyDxaHi8MTh5o62DuF5TKY8ZyPjbKJhrXNEgOUEfgbCMNaR1ppilbxrWNYahGGI3uIQDh05jN793W6sawCVkYKzyTQcIkdE4FW3grcDNZ1Ig3MCT3kQgSQRCAhPEJeCdKJcMhVuBTB2zAyt7an0T61NoqRD+h4Z5UNnDEmjnXOWNAMo1tP98NNUlmJIkoS01lBGnZZynHMI4wgDlTEcHuxD34EeN3qwH5WRojNxAjDmZhJz5vFTg/MmEyQuwH0OkfbgpT3ITEDS9+AFHo10HS2ZcvI4STZrhmCCh6aYPDS4q/szy69avdBqTdWyxhKsAxGDYQxW29NOLJ2yMM5CGQWt9TulGUiSBMPhBHqH+9DX1YfRQ4MoD0/CxKr6wYwDDMRT3mmBOSksTuBSgPsCfiYNLxvATwXwMylobe3E7qNPwGLb3BHfzMIS4DaB3pffM/T3E0vb7mtsa8rMQmFV56c4wSgLpzRgTx2YlQxJFMJae1IzTLTCWDSFvrEB9Hf3YvhQP0pDeehITYf1ql/hvqSz5vCqqQK4FGCegJf2qqAy07BSPjqf37ZHjZf/gQk+NVNXitmiVlBoI/Wrvud3vS970+W3ZWqzPhGBOAMnAmMcOklgFIMzDs6dmgOTjLB3427U1NShKV0Hj0lUdIShwhj6e/ow1H0UxcEJ6EqCmWIYjEGkfRCd/byMqBoYmWDgvoQIPHhZH0E6BS+dQk1DDbo3dw5M7R74LhjrlCTMCV0H6YRTHiaSsfL3Op983Tvvpsv/JFtX4zHGwDkHlwJxyGEjA50ksNYB9p3NkgmOiZ5h/O7fHwf3BYgzmFhBJ2a2wCVOEGnvPc27qiplYHAgKSA8CRFIeGkfXjoFP+UhW1eD3l1dw4Mvdt4DbX/nCS9+y+afdMIqgSPRUOG7Ox9bX1p5wyW31c6pz5WmCrO2rcIELCTYxMFaA2fsrEN+a3kd78M0GCN47zGcE0ABICnAOQMLJHzfgwgk/FQAL+0jnc24ro17Dw6u6/yW1ea3nvDKbx4HnNBWliSs8nAkGSrdu+uRlw4tunb115asWt5eLpZIeBLKV0gCCR0p6ERVnb4xQLXeni7v327x3w+h6ZqPoapc4gCXEnIakhf4kL5EuiYLq43a8T+vrZ/aOfBtABs94YUnm5ucdGAhnbAqwJitqP84/NS23WMHjt557rUXXdPQ3JgrFYqQvoROKag4gYk1tNYwxoIpBYDBOTqtIHD2QVHV3027ECY4ppPNKixPIJVJI5VJu74Dh0cOr935T2q8/AgE6/VJ6tOe7kgnHKQox069XNwz1Lnx0NPXNl++7Ksdl557fq62RpaLJSRRDKMMlNIwSsEoC2NUNQCY6UagPQUzPUtmVvVJVT/JGAMTDMKT4NM+SkoBPxUgnc24kYHhyR1PrH+61DPxUyb4ZiZ4SZJw72rI6pPUwflNQ6Yc/3LkpQOvjG7qvm7OhYuvb//Ayoua5jbXVEpliuMYRmkYZWCMqf5sDKx2cMbAwsIZN9MKedfgjsGh2fSCEwdxAhMcnHMIT1YVJarBKZVJw/M8O9Q3MLb9v159ttI19kvy+YbmS9sn64e57enpOTvj+7a41jXNbYq7Oya7pg4M/svI+q4nRl7tujS3cu5nF1204vLm+XNbiUhGlRBJ'
	$Image_Btn2 &= 'kkzDstXRltawdhradPS01sKZ41uYeNvh6/E+qGpe1RdHqhU/HackDjadPwkh4ad8+L7vKpVKpWd314GhjYf+NxopPuvVpXY2Xbqk0J40GQ8exvjY2XvXYab0aC/UO8ytT7o7JvuLR8afCAfzz+38+QtLeMa7onZ5y5Wtq5Z8oKWtZa5M+YFOFEuiGEqpaTh2uvi1s2nHzPjteFjHMyPCGwYNjFVzsGoWQLOwiDMIISE8gSAIQES6mC8We3Z3dY3u6n09PDL1AgTb7tWkBpsvbY9WuFZLIMA7dm9n/cWQmU2X5Osc1dZrm7OTvfWFqULf2K5K/+TD+3YPtO0DzvVbsmtql85dPWfJ3GV1zQ1zUqlUmgkujNJklIZSahqaOQ7SOygLAGPHlCOlhBACxJlVcZKUCsXC6KHBo2NdA/tKPRPbVD7czjPeQb8xM9awZmG0zLYYKSUIBIczcwVn/H6Wcw5EhMVTtY5q65SrcZNa68nDmam94Wj+qYm9/dmRDV1zkNg2ysilXkNmWaalZmGqMTc311g7J12TqfGCIJC+9KSUgog4Y4w556ojLWNBRM4YY51zJkmSJIniJCzHlXK+OFkeLoxUJgoDlaF8tynGXS42vTzjDVJKTKTn1Yap8xfq9kq9m261vONDOWuwJiYmEIbhKW0YADZFfuQ8L0pqkrHJVNwZDxdeiI9MyfDIpA+LNIAstK2BYDWMUS0YMmAsAINHRByCCVdtUWhYxLA2tNYVoW0eQAGMFQGUwBAyUOI1ZzX5wjXrrAMAVmBw+RADOLUzn+q9/T/84ZZhzPdgSAAAAABJRU5ErkJggg=='
	Return Binary(_Base64Decode($Image_Btn2))
EndFunc   ;==>Image_Btn2

Func Image_UEZ()
	Local $Image_UEZ
	$Image_UEZ &= '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'
	$Image_UEZ &= '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'
	$Image_UEZ &= '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'
	$Image_UEZ &= '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'
	$Image_UEZ &= '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'
	$Image_UEZ &= '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'
	$Image_UEZ &= '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'
	$Image_UEZ &= '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'
	$Image_UEZ &= '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'
	$Image_UEZ &= 'knVZdQMAAgHKWZK8UVCSELxzhDg2faYckhsAi4AnswEBAAKSkpIAQry8vHeHUFAAUHNzhFFRwSvAUVCHUOC3/5QCAADE5XWSc1HBwQEASjHnMAdo+mgAZjFmMTGY5xOAKtbCjLhupIOaQYCbpG7fO1qAmsEtgZpZAJpBTZLANnNR5OnEtR9tWUARQgCBEgJ3AUmEUSsrg/ACgwBwhlhYWMKFwcBwWIR37G7/Oj8AAcBLG1m8h1Dp6RA6prE2Sj3Et7EA3kOeZupm2dZIyN/EhU0uLkBNjHCFhoNRAU1COsBLCbV2f2rAq9TASgCVc8GSCPCDhoFIjIzLWhBaO1rDwABaWsvAjIyFg1B2/zo/AACQkDYcknVqJAIdGES3sUOeMeogExbIuN1oTbhaQMKGwXO8QiAdc2xRX/8ldAtkYZQAcIeUUIQgJVgCJctaACQAhVjJhoPB2c8AmOrn5zBqZna8dqa/CR8AHwA/FuU/EQHBTTaxQzFcmdYEy6ilJi7dqDuMuFjwwABD/yXVlwlAeoRCvKBwUYNYhiAkIPBRz5gxIyQ6Q+im3rGAXm6ffR8AHwAbHwDjS6Yfg6gFsUNpQGlmKsLLxIMmtcAubjvwc8H/JRQABp4gcaCWwHNzUc8A52RqdnZDpiT/QSQ/Bx8AHwAfAB8AHwAidCBo19DLbgRNK1Fu1P8lDwABACbyEvBT7Px23m8kDwAPAA8ADwAPAH8PAA8ADwAPAA8ADwCGKacQOiXIuDETxxKxh/8BDwAPAJCeQrzAS/gwaN6vAQ8ADwAPAA8A/w8ADwAPAA8ADwAPAA8AjCYAHWk6nFqkqM8P/xIPAA8A8Ti8QuWm/58lDwAPAA8ADwAPAA8ADwA/DwAPAA8ADwAPAHEmQ+ociZj/Eg8ADwCQkKLwQtT6HW8BDwAPAA8A/w8ADwAPAA8ADwAPAA8ADwA/DwC1c++IDwAPAAAAduX/b0sPAA8ADwAPAA8ADwAPAP8PAA8ADwAPAA8ADwAPAA8A/QsAQ49iDwAPAA8ADwAPAP8PAA8ADwAPAA8ADwAPAA8A/w8ADwAPAA8ADwAPAA8ADwAfDwAPAA8ADwACAAOwApCCAQ=='
	$Image_UEZ = _Base64Decode($Image_UEZ)
	Local $tSource = DllStructCreate('byte[' & BinaryLen($Image_UEZ) & ']')
	DllStructSetData($tSource, 1, $Image_UEZ)
	Local $tDecompress
	_WinAPI_LZNTDecompress($tSource, $tDecompress)
	$tSource = 0
	Return Binary(DllStructGetData($tDecompress, 1))
EndFunc   ;==>Image_UEZ
#endregion