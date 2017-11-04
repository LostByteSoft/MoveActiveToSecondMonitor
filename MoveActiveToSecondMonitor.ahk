;;--- Head --- Informations --- AHK ---

;;	MoveActiveToSecondMonitor
;;	Compatibility: WINDOWS MEDIA CENTER ,  Windows Xp , Windows Vista , Windows 7 , Windows 8
;;	All files must be in same folder. Where you want.
;;	64 bit AHK version : 1.1.24.2 64 bit Unicode
;;	2 screen supported.
;;	Click on an windows and press F4 , if windows not move press F4 again.
;;	The Mbutton is choose for people (like me) who doesn't have a keyboard.

;;--- Softwares Variables ---

	SetWorkingDir, %A_ScriptDir%
	SetTitleMatchMode, 2
	SetTitleMatchMode, Slow
	#NoEnv
	#SingleInstance Force
	#Persistent

	SetEnv, title, ActiveToSecondMonitor
	SetEnv, mode, Toggle move %shortcut%
	SetEnv, version, Version 2017-11-04-0923
	SetEnv, Author, LostByteSoft
	SetEnv, logoicon, ico_monitor.ico

	FileInstall, MoveActiveToSecondMonitor.ini, MoveActiveToSecondMonitor.ini
	FileInstall, ico_about.ico, ico_about.ico, 0
	FileInstall, ico_HotKeys.ico, ico_HotKeys.ico, 0
	FileInstall, ico_lock.ico, ico_lock.ico, 0
	FileInstall, ico_monitor_w.ico, ico_monitor_w.ico, 0
	FileInstall, ico_monitor.ico, ico_monitor.ico, 0
	FileInstall, ico_shut.ico, ico_shut.ico, 0
	FileInstall, ico_reboot.ico, ico_reboot.ico, 0
	FileInstall, ico_options.ico, ico_options.ico, 0
	FileInstall, ico_debug.ico, ico_debug.ico, 0
	FileInstall, ico_pause.ico, ico_pause.ico, 0

	IniRead, shortcut, MoveActiveToSecondMonitor.ini, options, shortcut
	IniRead, debug, MoveActiveToSecondMonitor.ini, options, debug

;;--- Menu Tray options ---

	Menu, Tray, NoStandard
	Menu, tray, add, ---=== %title% ===---, about
	Menu, Tray, Icon, ---=== %title% ===---, %logoicon%
	Menu, tray, add, Show logo, GuiLogo
	Menu, tray, add, Secret MsgBox, secret					; Secret MsgBox, just show all options and variables of the program
	Menu, Tray, Icon, Secret MsgBox, ico_lock.ico
	Menu, tray, add, About && ReadMe, author
	Menu, Tray, Icon, About && ReadMe, ico_about.ico
	Menu, tray, add, Author %author%, about
	menu, tray, disable, Author %author%
	Menu, tray, add, %version%, about
	menu, tray, disable, %version%
	Menu, tray, add,
	Menu, tray, add, --== Control ==--, about
	Menu, Tray, Icon, --== Control ==--, ico_options.ico
	Menu, tray, add, Exit %title%, Close					; Close exit program
	Menu, Tray, Icon, Exit %title%, ico_shut.ico
	Menu, tray, add, Refresh (ini mod), doReload 				; Reload the script.
	Menu, Tray, Icon, Refresh (ini mod), ico_reboot.ico
	Menu, tray, add, Set Debug (Toggle), debug
	Menu, Tray, Icon, Set Debug (Toggle), ico_debug.ico
	Menu, tray, add, Pause (Toggle), pause
	Menu, Tray, Icon, Pause (Toggle), ico_pause.ico
	Menu, tray, add,
	Menu, tray, add, --== Options ==--, about
	Menu, Tray, Icon, --== Options ==--, ico_options.ico
	Menu, tray, add, Hotkey : %shortcut%, tray
	Menu, Tray, Icon, Hotkey : %shortcut%, ico_HotKeys.ico
	menu, tray, add
	Menu, Tray, Tip, %mode% shortcut=%shortcut%

;;--- Software start here ---

Start:
	IfEqual, debug, 1, MsgBox, (Start) waiting shortcut=%shortcut%
	Menu, Tray, Icon, ico_monitor_w.ico
	KeyWait, %shortcut% , D
	WinGetTitle, WinActive, A

Movetray:
	activeWindow := WinActive("A")
	IfEqual, debug, 1, MsgBox, (Movetray) Winactive=%WinActive%- activeWindow=%activeWindow%
	Send, {LWin Down}{LShift Down}{RIGHT}{LShift Up}{LWin Up}
	KeyWait, %shortcut%
	Goto, Start

;;--- Debug Pause ---

debug:
	IniRead, debug, MoveActiveToSecondMonitor.ini, options, debug
	IfEqual, debug, 0, goto, debug1
	IfEqual, debug, 1, goto, debug0

	debug0:
	SetEnv, debug, 0
	IniWrite, 0, MoveActiveToSecondMonitor.ini, options, debug
	goto, doReload

	debug1:
	SetEnv, debug, 1
	IniWrite, 1, MoveActiveToSecondMonitor.ini, options, debug
	goto, doReload

pause:
	Ifequal, pause, 0, goto, paused
	Ifequal, pause, 1, goto, unpaused

	paused:
	Menu, Tray, Icon, ico_pause.ico
	SetEnv, pause, 1
	goto, sleep

	unpaused:	
	Menu, Tray, Icon, ico_time_w.ico
	SetEnv, pause, 0
	Goto, start

	sleep:
	Menu, Tray, Icon, ico_pause.ico
	sleep, 24000
	goto, sleep

;;--- Quit (escape , esc) ---

ExitApp:
GuiClose2:
Close:
	ExitApp

doReload:
	Reload
	sleep, 500
	goto, Close

;;--- Tray Bar (must be at end of file) ---

tray:
	TrayTip, %title%, You must click on an windows. With Left mouse button., 2, 1
	KeyWait, LButton, D
	Goto, Movetray

secret:													; for debug and informations
	TrayTip, %title%, You must click on an windows. With Left mouse button., 2, 1
	KeyWait, LButton, D
	WinGetTitle, LastActive, A
	WinGetPos, X, Y, w, h, A
	msgbox, 48, %title%,title=%title% mode=%mode% version=%version% author=%author% logoicon=%logoicon% A_ScriptDir=%A_ScriptDir% LastActive=%LastActive%`n`nThe active window is at X=%X% Y=%Y% W=%w% H=%h%`n`nMonitorPrimary=%MonitorPrimary% MonitorCount=%MonitorCount% shortcut=%shortcut% autoconfig=%autoconfig% traybar=%traybar%
	Return

about:
about1:
about2:
	TrayTip, %title%, %mode% by %author%, 2, 1
	Sleep, 1000
	Return

version:
	TrayTip, %title%, %version%, 2, 2
	Sleep, 1000
	Return

author:
	MsgBox, 64, %title%, %title% %mode% %version% %author%. This software is usefull to move windows between two screen.`n`n`tGo to https://github.com/LostByteSoft
	Return

GuiLogo:
	Gui, Add, Picture, x25 y25 w400 h400 , %logoicon%
	Gui, Show, w450 h450, %title% Logo
	; Gui, Color, 000000
	Sleep, 500
	return

settings:
	run, notepad.exe "MoveActiveToSecondMonitor.ini"
	Sleep, 1000
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