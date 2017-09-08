;;--- Head --- Informations --- AHK ---

;;	MoveActiveToSecondMonitor
;;	Compatibility: WINDOWS MEDIA CENTER ,  Windows Xp , Windows Vista , Windows 7 , Windows 8
;;	All files must be in same folder. Where you want.
;;	64 bit AHK version : 1.1.24.2 64 bit Unicode
;;	2 screen supported.

;;	Click on an windows and press F4 , if windows not move press F4 again.

;;--- Softwares Variables ---

	SetEnv, title, MoveActiveToSecondMonitor
	SetEnv, mode, Toggle move F4
	SetEnv, version, Version 2017-09-08-1722
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
	FileInstall, ico_shut.ico, ico_shut.ico, 0
	FileInstall, ico_reboot.ico, ico_reboot.ico, 0

	SysGet, MonitorCount, MonitorCount
	SysGet, MonitorPrimary, MonitorPrimary
	SysGet, Mon1, Monitor, 1
	SysGet, Mon2, Monitor, 2

;;--- Menu Tray options ---

	Menu, Tray, NoStandard
	Menu, Tray, Icon, ico_monitor_w.ico
	Menu, tray, add, --= %title% =--, about1
	Menu, Tray, Icon, --= %title% =--, ico_monitor.ico
	Menu, tray, add, Show logo, GuiLogo
	Menu, tray, add, Secret MsgBox, secret					; Secret MsgBox, just show all options and variables of the program
	Menu, Tray, Icon, Secret MsgBox, ico_lock.ico
	Menu, tray, add,
	Menu, tray, add, About LostByteSoft, about2				; Creates a new menu item.
	Menu, Tray, Icon, About LostByteSoft, ico_about.ico
	Menu, tray, add, %Version%, Version					; Show version
	Menu, Tray, Icon, %Version%, ico_about.ico
	Menu, tray, add,
	Menu, tray, add, Exit, Exit						; GuiClose exit program
	Menu, Tray, Icon, Exit, ico_shut.ico
	Menu, tray, add, Refresh FitScreen, doReload				; Reload the script. Usefull if you change something in configuration
	Menu, Tray, Icon, Refresh FitScreen, ico_reboot.ico
	menu, tray, add,
	Menu, tray, add, Hotkey : F4, F4
	Menu, Tray, Icon, Hotkey : F4, ico_HotKeys.ico
	menu, tray, add
	Menu, Tray, Tip, %mode%

;;--- Software start here ---

	TrayTip, %title%, Press F4, 2, 1

	;; MsgBox, Last active %Title% ... The active window is "%Title%"`n`nThe active window is at %X% %Y% %w% %h% newx=%newx%`n`nMonitorCount=%MonitorCount% MonitorPrimary=%MonitorPrimary%`n`nEcran 1 -- mon1Left=%Mon1Left% -- Top=%Mon1Top% -- Right=%Mon1Right% -- Bottom=%Mon1Bottom% --- `n`nEcran 2 -- mon2Left=%Mon2Left% -- Top=%Mon2Top% -- Right=%Mon2Right% -- Bottom=%Mon2Bottom%

	; in need of detecting monitor and move to another monitor
	; verify to not overpass the screen border if sceen is smaller than the one


start:
	KeyWait, F4 , D
	IfEqual, MonitorCount, 1, goto, error01

skip:

	WinGetTitle, LastActive, A
	WinGetPos, X, Y, w, h, A 		; "A" to get the active window's pos.
	IfEqual, var, 1, goto, reverse

forward:
	SetEnv, var, 1

	newx := Mon2Left - x

	WinMove, %LastActive%,, %newx%, %Mon2Top%, %w%, %h%
	Sleep, 500
	Goto, start


reverse:
	SetEnv, var, 0

	newx := Mon2Left - x

	WinMove, %LastActive%,, %newx%, %Mon2Top%, %w%, %h%
	Sleep, 500
	Goto, start


error01:
	WinGetTitle, LastActive, A
	WinGetPos, X, Y, w, h, A
	newx := Mon2Left - x
	MsgBox, 48, %title%, You have only 1 monitor. This software requires 2 monitors.
	MsgBox, Last active %Title% ... The active window is "%Title%"`n`nThe active window is at %X% %Y% %w% %h% newx=%newx%`n`nMonitorCount=%MonitorCount% MonitorPrimary=%MonitorPrimary%`n`nEcran 1 -- mon1Left=%Mon1Left% -- Top=%Mon1Top% -- Right=%Mon1Right% -- Bottom=%Mon1Bottom% --- `n`nEcran 2 -- mon2Left=%Mon2Left% -- Top=%Mon2Top% -- Right=%Mon2Right% -- Bottom=%Mon2Bottom%
	goto, start


;;--- Quit (escape , esc) ---

Exit:
	ExitApp

;;--- Tray Bar (must be at end of file) ---

F4:
	; IfEqual, MonitorCount, 1, goto, error01
	TrayTip, %title%, Select a Windows with your mouse, 2, 1
	KeyWait, LButton, D
	Goto, skip

secret:
	TrayTip, %title%, You must click on an windows., 2, 1
	KeyWait, LButton, D
	WinGetTitle, LastActive, A
	WinGetPos, X, Y, w, h, A
	newx := Mon2Left - x
	MsgBox, Last active %Title% ... The active window is "%Title%"`n`nThe active window is at %X% %Y% %w% %h% newx=%newx%`n`nMonitorCount=%MonitorCount% MonitorPrimary=%MonitorPrimary%`n`nEcran 1 -- mon1Left=%Mon1Left% -- Top=%Mon1Top% -- Right=%Mon1Right% -- Bottom=%Mon1Bottom% --- `n`nEcran 2 -- mon2Left=%Mon2Left% -- Top=%Mon2Top% -- Right=%Mon2Right% -- Bottom=%Mon2Bottom%
	Return

about1:
about2:
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