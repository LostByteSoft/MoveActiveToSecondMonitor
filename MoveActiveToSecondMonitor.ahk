;;--- Head --- Informations --- AHK ---

;;	MoveActiveToSecondMonitor
;;	Compatibility: WINDOWS MEDIA CENTER ,  Windows Xp , Windows Vista , Windows 7 , Windows 8
;;	All files must be in same folder. Where you want.
;;	64 bit AHK version : 1.1.24.2 64 bit Unicode
;;	2 screen supported.
;;	THANKS https://autohotkey.com/board/topic/85457-detecting-the-screen-the-current-window-is-on/
;;	THANKS https://autohotkey.com/board/topic/32874-moving-the-active-window-from-one-monitor-to-the-other/
;;	THANKS http://www.autohotkey.com/forum/topic19440.html
;;	Click on an windows and press F4 , if windows not move press F4 again.

;;--- Softwares Variables ---

	SetWorkingDir, %A_ScriptDir%
	SetTitleMatchMode, 2
	SetTitleMatchMode, Slow
	#NoEnv
	#SingleInstance Force
	#Persistent

	SetEnv, title, ActiveToSecondMonitor
	SetEnv, mode, Toggle move %shortcut%
	SetEnv, version, Version 2017-10-12-1610
	SetEnv, Author, LostByteSoft
	SetEnv, logoicon, ico_monitor.ico
	SetEnv, debug, 0					;; When 1 show all MsgBox for debug, when 0 no MsgBox

	FileInstall, ico_about.ico, ico_about.ico, 0
	FileInstall, ico_HotKeys.ico, ico_HotKeys.ico, 0
	FileInstall, ico_lock.ico, ico_lock.ico, 0
	FileInstall, ico_monitor_w.ico, ico_monitor_w.ico, 0
	FileInstall, ico_monitor.ico, ico_monitor.ico, 0
	FileInstall, ico_shut.ico, ico_shut.ico, 0
	FileInstall, ico_reboot.ico, ico_reboot.ico, 0
	FileInstall, ico_options.ico, ico_options.ico, 0

	SysGet, MonitorCount, MonitorCount
	SysGet, MonitorPrimary, MonitorPrimary
	SysGet, Mon1, Monitor, 1
	SysGet, Mon2, Monitor, 2
	SysGet, Mon2, Monitor, 3

	IniRead, shortcut, MoveActiveToSecondMonitor.ini, options, shortcut
	IniRead, traybar, MoveActiveToSecondMonitor.ini, options, traybar
	IniRead, autoconfig, MoveActiveToSecondMonitor.ini, options, autoconfig

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
	Menu, tray, add, Exit, Close						; Close exit program
	Menu, Tray, Icon, Exit, ico_shut.ico
	Menu, tray, add, Refresh FitScreen, doReload				; Reload the script. Usefull if you change something in configuration
	Menu, Tray, Icon, Refresh FitScreen, ico_reboot.ico
	Menu, tray, add,
	Menu, tray, add, Change settings (ini), settings
	Menu, Tray, Icon, Change settings (ini), ico_options.ico
	Menu, tray, add, Auto 1 & Manu 0 = %autoconfig%, AutoManu
	;Menu, Tray, Icon, Auto 1 & Manu 0 = %autoconfig%, ico_options.ico
	Menu, tray, add, Debug MsgBox = 0, debug
	menu, tray, add,
	Menu, tray, add, Hotkey : %shortcut%, tray
	Menu, Tray, Icon, Hotkey : %shortcut%, ico_HotKeys.ico
	menu, tray, add
	Menu, Tray, Tip, %mode% shortcut=%shortcut%

;;--- Automatic or Manual configuration ---

	Menu, Tray, Icon, ico_monitor_w.ico

	;; TrayTip, %title%, %mode% Shortcut=%shortcut%, 2, 1

loadconf:
	IfEqual, debug, 1, MsgBox, autoconfig=%autoconfig%
	IfEqual, autoconfig, 0, goto, Iniread
	IfEqual, autoconfig, 1, goto, autoconfig
	Goto, error_00

	Iniread:
		IniRead, MainMonitorWidth, MoveActiveToSecondMonitor.ini, options, MainMonitorWidth
		IniRead, MainMonitorHeight, MoveActiveToSecondMonitor.ini, options, MainMonitorHeight
		IniRead, SecondMonitorWidth, MoveActiveToSecondMonitor.ini, options, SecondMonitorWidth
		IniRead, SecondMonitorHeight, MoveActiveToSecondMonitor.ini, options, SecondMonitorHeight
		MainMonitorHeight -= traybar						; Tray bar
		IfEqual, debug, 1, MsgBox, Resolutions manual : MainMonitorWidth=%MainMonitorWidth% - MainMonitorHeight=%MainMonitorHeight%(tray bar is removed) - SecondMonitorWidth=%SecondMonitorWidth% - SecondMonitorHeight=%SecondMonitorHeight%
		Goto, Start

	autoconfig:
		SysGet, MonitorCount, MonitorCount
		SysGet, MonitorPrimary, MonitorPrimary
		SysGet, Mon1, Monitor, 1
		SysGet, Mon2, Monitor, 2
		SysGet, Mon2, Monitor, 3

		MainMonitorWidth := Mon1Right
		MainMonitorHeight := Mon1Bottom
		SecondMonitorWidth := Mon2Left
		SecondMonitorHeight := Mon2Bottom

		MainMonitorHeight -= traybar			; Tray bar remove
		;; SecondMonitorHeight -= 0			; not implemented, but remove the ; and it works.

		IfLess, SecondMonitorWidth, -1, goto, negative
		IfEqual, debug, 1, MsgBox, Resolutions automatic :`n`nMainMonitorWidth = %MainMonitorWidth% - MainMonitorHeight = %MainMonitorHeight% (tray bar is removed)`n`nSecondMonitorWidth =%SecondMonitorWidth% - SecondMonitorHeight = %SecondMonitorHeight%
		goto, start

		negative:
		SecondMonitorWidth *=-1
		IfEqual, debug, 1, MsgBox, Resolutions automatic :`n`nMainMonitorWidth = %MainMonitorWidth% - MainMonitorHeight = %MainMonitorHeight% (tray bar is removed)`n`nSecondMonitorWidth =%SecondMonitorWidth% - SecondMonitorHeight = %SecondMonitorHeight%
		goto, start

;;--- Software start here ---

Start:
	IfEqual, debug, 1, MsgBox, waiting shortcut=%shortcut% - Mbutton = mouse middle button. Monitorcount=%monitorcount%
	KeyWait, %shortcut% , D
	IfEqual, debug, 1, goto, skip5
	IfEqual, Monitorcount, 1, goto, error_00
	skip5:
	IfEqual, Monitorcount, 2, goto, Movetray
	IfEqual, Monitorcount, 3, goto, Movetray
	IfEqual, Autoconfig, 1, Goto, autoconfig		;; added in case changes (resolution or more monitors)
	IfEqual, Autoconfig, 0, Goto, Iniread			;; added in case changes (resolution or more monitors)
	Goto, error_00

Movetray:
	IfEqual, debug, 1, Goto, start
	IfEqual, MonitorCount, 1, goto, error_00
	activeWindow := WinActive("A")
	IfEqual, debug, 1, MsgBox, active windows for deplacement = %activeWindow%
	if activeWindow = 0
		{
			return
		}
	WinGet, minMax, MinMax, ahk_id %activeWindow%
	if minMax = 1
		{
			WinRestore, ahk_id %activeWindow%
		}
	WinGetPos, x, y, width, height, ahk_id %activeWindow%
	if x < 0
		{
			xScale := SecondMonitorWidth / MainMonitorWidth
			yScale := SecondMonitorHeight / MainMonitorHeight
			x := MainMonitorWidth + x
			newX := x * xScale
			newY := y * yScale
			newWidth := width * xScale
			newHeight := height * yScale
		}
	else
		{
			xScale := MainMonitorWidth / SecondMonitorWidth
			yScale := MainMonitorHeight / SecondMonitorHeight
			newX := x * xScale
			newY := y * yScale
			newWidth := width * xScale
			newHeight := height * yScale
			newX := newX - MainMonitorWidth
		}
	WinMove, ahk_id %activeWindow%, , %newX%, %newY%, %newWidth%, %newHeight%
	if minMax = 1
		{
			WinMaximize, ahk_id %activeWindow%
		}
	WinActivate ahk_id %activeWindow% 		 ;Needed - otherwise another window may overlap it
	KeyWait, %shortcut%
	goto, start

error_00:
	KeyWait, %shortcut%
	Random, error, 1111, 9999
	TrayTip, %title%, error_%error% You have only 1 screen. You must have at least 2 monitors. Something when wrong. !!! Do a reload !!! Maybe your screen or resolutions has changed, 2, 1
	Sleep, 500
	Goto, Start

;;--- Quit (escape , esc) ---

Close:
	ExitApp

; Escape::		; Debug purpose
	ExitApp

;;--- Tray Bar (must be at end of file) ---

tray:
	TrayTip, %title%, You must click on an windows. With Left mouse button., 2, 1
	KeyWait, LButton, D
	Goto, Movetray

secret:													; for debug and informations
	IniRead, shortcut, MoveActiveToSecondMonitor.ini, options, shortcut
	IniRead, traybar, MoveActiveToSecondMonitor.ini, options, traybar
	IniRead, autoconfig, MoveActiveToSecondMonitor.ini, options, autoconfig
	TrayTip, %title%, You must click on an windows. With Left mouse button., 2, 1

	KeyWait, LButton, D

	WinGetTitle, LastActive, A
	WinGetPos, X, Y, w, h, A
	SysGet, MonitorCount, MonitorCount
	SysGet, MonitorPrimary, MonitorPrimary
	SysGet, Mon1, Monitor, 1
	SysGet, Mon2, Monitor, 2
	IfEqual, autoconfig, 0, goto, secretmanu
	IfEqual, autoconfig, 1, goto, secretauto
	Goto, error_00

	secretauto:
	MainMonitorWidth = %Mon1Right%
	MainMonitorHeight := Mon1Bottom - traybar							; Tray bar
	SecondMonitorWidth = %Mon2Left%
	SecondMonitorHeight = %Mon2Bottom%
	IfLess, SecondMonitorWidth, -1, goto, negative3
	goto, msgboxMAS

	secretmanu:
	IniRead, MainMonitorWidth, MoveActiveToSecondMonitor.ini, options, MainMonitorWidth
	IniRead, MainMonitorHeight, MoveActiveToSecondMonitor.ini, options, MainMonitorHeight
	IniRead, SecondMonitorWidth, MoveActiveToSecondMonitor.ini, options, SecondMonitorWidth
	IniRead, SecondMonitorHeight, MoveActiveToSecondMonitor.ini, options, SecondMonitorHeight
	MainMonitorHeight -= traybar									; Tray bar
	IfLess, SecondMonitorWidth, -1, goto, negative3
	goto, msgboxMAS

	negative3:
	SecondMonitorWidth *=-1
	goto, msgboxMAS

	msgboxMAS:
	msgbox, 48, %title%,title=%title% mode=%mode% version=%version% author=%author% logoicon=%logoicon% A_ScriptDir=%A_ScriptDir% LastActive=%LastActive%`n`nThe active window is at X=%X% Y=%Y% W=%w% H=%h%`n`nMonitorPrimary=%MonitorPrimary% MonitorCount=%MonitorCount% shortcut=%shortcut% autoconfig=%autoconfig% traybar=%traybar%`n`nEcran 1 -- mon1Left=%Mon1Left% -- Top=%Mon1Top% -- Right=%Mon1Right% -- Bottom=%Mon1Bottom% ---`nEcran 2 -- mon2Left=%Mon2Left% -- Top=%Mon2Top% -- Right=%Mon2Right% -- Bottom=%Mon2Bottom%`n`nHere it must be your 2 resolutions :`n`nScreen 1 = %MainMonitorWidth% x %MainMonitorHeight%`nScreen 2 = %SecondMonitorWidth% x %SecondMonitorHeight%
	Return

debug:
	IfEqual, debug, 0, goto, debug1
	IfEqual, debug, 1, goto, debug0

	debug0:
	Menu, Tray, Rename, Debug MsgBox = 1, Debug MsgBox = 0
	SetEnv, debug, 0
	goto, loadconf

	debug1:
	Menu, Tray, Rename, Debug MsgBox = 0, Debug MsgBox = 1
	SetEnv, debug, 1
	goto, loadconf

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

doReload:
	Reload
	sleep, 100
	goto, Close

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

AutoManu:
	IfEqual, autoconfig, 0, goto, autoconfig1
	IfEqual, autoconfig, 1, goto, autoconfig0

	autoconfig0:
	IniWrite, 0, MoveActiveToSecondMonitor.ini, options, autoconfig
	goto, doReload

	autoconfig1:
	IniWrite, 1, MoveActiveToSecondMonitor.ini, options, autoconfig
	goto, doReload

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