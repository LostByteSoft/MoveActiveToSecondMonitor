;;--- Head --- Informations --- AHK ---

;;	MoveActiveToSecondMonitor
;;	Compatibility: WINDOWS MEDIA CENTER ,  Windows Xp , Windows Vista , Windows 7 , Windows 8
;;	All files must be in same folder. Where you want.
;;	64 bit AHK version : 1.1.24.2 64 bit Unicode
;;	2 screen supported.

;;--- Softwares Variables ---

	SetEnv, title, MoveActiveToSecondMonitor
	SetEnv, mode, Toggle move F8
	SetEnv, version, Version 2017-09-02-1353
	SetEnv, Author, LostByteSoft

;;--- Softwares options ---

	SetWorkingDir, %A_ScriptDir%
	#SingleInstance Force
	#Persistent
	#NoEnv
	SetTitleMatchMode, Slow
	SetTitleMatchMode, 2

	FileInstall, ico_about.ico, ico_about.ico, 0
	FileInstall, ico_HotKeys.ico, ico_HotKeys.ico, 0
	FileInstall, ico_lock.ico, ico_lock.ico, 0
	FileInstall, ico_monitor_w.ico, ico_monitor_w.ico, 0
	FileInstall, ico_monitor.ico, ico_monitor.ico, 0
	FileInstall, ico_reboot.ico, ico_reboot.ico, 0
	FileInstall, ico_shut.ico, ico_shut.ico, 0

	SysGet, MonitorCount, MonitorCount
	SysGet, MonitorPrimary, MonitorPrimary
	SysGet, Mon1, Monitor, 1
	SysGet, Mon2, Monitor, 2

;;--- Menu Tray options ---

	Menu, Tray, NoStandard
	Menu, Tray, Icon, ico_monitor_w.ico
	Menu, tray, add, --= %title% =--, about
	Menu, Tray, Icon, --= %title% =--, ico_monitor.ico
	Menu, tray, add, Show logo, GuiLogo
	Menu, tray, add, Secret MsgBox, secret					; Secret MsgBox, just show all options and variables of the program
	Menu, Tray, Icon, Secret MsgBox, ico_lock.ico
	menu, tray, add
	Menu, tray, add, Exit, Exit						; GuiClose exit program
	Menu, Tray, Icon, Exit, ico_shut.ico
	Menu, tray, add, Refresh FitScreen, doReload				; Reload the script.
	Menu, Tray, Icon, Refresh FitScreen, ico_reboot.ico
	menu, tray, add
	Menu, tray, add, Hotkey : F8, F8
	Menu, Tray, Icon, Hotkey : F8, ico_HotKeys.ico
	Menu, Tray, Tip, %mode%

;;--- Software start here ---


start:
	KeyWait, F8 , D
	; IfEqual, MonitorCount, 1, goto, error01

skip:
	WinGetTitle, LastActive, A
	WinGetPos, X, Y, w, h, A  						; "A" to get the active window's pos.
	MsgBox, The active window is "%LastActive%" ... The active window is at %X% %Y% %w% %h% ... MonitorCount=%MonitorCount% MonitorPrimary=%MonitorPrimary%

;Gui +HwndMainGui -Border
;Gui, Add, Button, gMove, Move
;Gui, Add, Button, gExit x+5 yp, Exit
;Gui, Show, x0 y0 ; adjust x and y so gui appears where you want it on the TV

;Loop
;{
	WinGet, CheckHwnd, ID, A
	if (CheckHwnd != MainGui)
		LastActive := CheckHwnd
	Sleep, 50
;}
;return

Move:
	WinMove, ahk_id %LastActive%,, %x%, %y%					 ; adjust x and y so window will appear on the TV
;return

	Goto, start


error01:
	MsgBox, You have only 1 monitor. This software require 2 monitor.
	goto, start


;;--- Quit (escape , esc) ---

Exit:
	ExitApp

;;--- Tray Bar (must be at end of file) ---

F8:
	; IfEqual, MonitorCount, 1, goto, error01
	TrayTip, %title%, Select a Windows with your mouse, 2, 1
	KeyWait, LButton, D
	Goto, skip

secret:
	MsgBox, Last active %Title% ... The active window is "%Title%" ... The active window is at %X% %Y% %w% %h% ... MonitorCount=%MonitorCount% MonitorPrimary=%MonitorPrimary% `n`nEcran 1 -- mon1Left=%Mon1Left% -- Top=%Mon1Top% -- Right=%Mon1Right% -- Bottom=%Mon1Bottom% --- `n`nEcran 2 -- mon2Left=%Mon2Left% -- Top=%Mon2Top% -- Right=%Mon2Right% -- Bottom=%Mon2Bottom%
	Return

about:
	TrayTip, %title%, %mode% by %author%, 2, 1
	Sleep, 500
	Return

version:
	TrayTip, %title%, %version%, 2, 2
	Sleep, 500
	Return

doReload:
	Reload
	sleep, 500
	Return

GuiLogo:
	Gui, Add, Picture, x25 y25 w400 h400 , ico_monitor.ico
	Gui, Show, w450 h450, %title% Logo
	; Gui, Color, 000000
	return

;;--- End of script ---
;
;            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
;   Version 3.14159265358979323846264338327950288419716939937510582
;                          March 2017
;
; Everyone is permitted to copy and distribute verbatim or modified
; copies of this license document, and changing it is allowed as long
; as the name is changed.
;
;            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
;   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
;
;              You just DO WHAT THE FUCK YOU WANT TO.
;
;		     NO FUCKING WARRANTY AT ALL
;
;	As is customary and in compliance with current global and
;	interplanetary regulations, the author of these pages disclaims
;	all liability for the consequences of the advice given here,
;	in particular in the event of partial or total destruction of
;	the material, Loss of rights to the manufacturer's warranty,
;	electrocution, drowning, divorce, civil war, the effects of
;	radiation due to atomic fission, unexpected tax recalls or
;	    encounters with extraterrestrial beings 'elsewhere.
;
;              LostByteSoft no copyright or copyleft.
;
;	If you are unhappy with this software i do not care.
;
;;--- End of file ---