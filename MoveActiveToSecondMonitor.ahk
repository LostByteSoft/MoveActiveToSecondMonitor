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

;; The Mbutton is choose for people (like me) doesn't have a keyboard.

;;--- Softwares Variables ---

	IfEqual, debug, 1, TrayTip, %title%, DEBUG MODE, 2, 1
	;;IfEqual, debugmove, 1, TrayTip, %title%, DEBUG MODE, 2, 1

	SetWorkingDir, %A_ScriptDir%
	SetTitleMatchMode, 2
	SetTitleMatchMode, Slow
	#NoEnv
	#SingleInstance Force
	#Persistent

	SetEnv, title, ActiveToSecondMonitor
	SetEnv, mode, Toggle move %shortcut%
	SetEnv, version, Version 2017-10-17-0729
	SetEnv, Author, LostByteSoft
	SetEnv, logoicon, ico_monitor.ico

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

	SysGet, MonitorCount, MonitorCount
	SysGet, Mon1, Monitor, 1
	SysGet, Mon2, Monitor, 2

	IniRead, autoconfig, MoveActiveToSecondMonitor.ini, options, autoconfig
	IniRead, traybar, MoveActiveToSecondMonitor.ini, options, traybar
	IniRead, shortcut, MoveActiveToSecondMonitor.ini, options, shortcut
	IniRead, debug, MoveActiveToSecondMonitor.ini, options, debug
	IniRead, debugmove, MoveActiveToSecondMonitor.ini, options, debugmove

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
	Menu, tray, add, Change settings (ini), settings
	Menu, tray, add, Auto 1 && Manu 0 = %autoconfig%, AutoManu
	Menu, tray, add, Hotkey : %shortcut%, tray
	Menu, Tray, Icon, Hotkey : %shortcut%, ico_HotKeys.ico
	menu, tray, add
	Menu, Tray, Tip, %mode% shortcut=%shortcut%

;;--- Automatic or Manual configuration ---

	Menu, Tray, Icon, ico_monitor_w.ico

loadconf:
	IfEqual, debug, 1, msgbox, (loadconf) shortcut=%shortcut% traybar=%traybar% autoconfig=%autoconfig% debug=%debug% debugmove=%debugmove% Monitorcount=%monitorcount%`n`nAutoconfig if autoconfig=0 it will ignore.`n`nEcran 1 -- mon1Left=%Mon1Left% -- Top=%Mon1Top% -- Right=%Mon1Right% -- Bottom=%Mon1Bottom%`nEcran 2 -- mon2Left=%Mon2Left% -- Top=%Mon2Top% -- Right=%Mon2Right% -- Bottom=%Mon2Bottom%
	IfEqual, autoconfig, 0, goto, Iniread
	IfEqual, autoconfig, 1, goto, autoconfig
	MsgBox, Autoconfig failled...
	Goto, error_01

	Iniread:
		IniRead, MainMonitorWidth, MoveActiveToSecondMonitor.ini, options, MainMonitorWidth
		IniRead, MainMonitorHeight, MoveActiveToSecondMonitor.ini, options, MainMonitorHeight
		IniRead, LeftMonitorWidth, MoveActiveToSecondMonitor.ini, options, LeftMonitorWidth
		IniRead, LeftMonitorHeight, MoveActiveToSecondMonitor.ini, options, LeftMonitorHeight
		MainMonitorHeight -= traybar
		MainMonitorWidth := MainMonitorWidth
		MainMonitorHeight := MainMonitorHeight
		SecondMonitorWidth := LeftMonitorWidth
		SecondMonitorHeight := LeftMonitorHeight
		IfEqual, debug, 1, MsgBox, (Iniread) autoconfig=%autoconfig% Resolutions manual :`n`nMainMonitorWidth=%MainMonitorWidth% - MainMonitorHeight=%MainMonitorHeight% (tray bar is removed)`n`nLeftMonitorWidth=%LeftMonitorWidth% - LeftMonitorHeight=%LeftMonitorHeight%
		Goto, Start

	autoconfig:
		SetEnv, MainMonitorWidth, %Mon1Right%
		SetEnv, MainMonitorHeight, %Mon1Bottom%
		SetEnv, SecondMonitorWidth, %Mon2Right%
		SetEnv, SecondMonitorHeight, %Mon2Bottom%
		SecondMonitorWidth -= %Mon2Left%
		MainMonitorHeight -= traybar			; Tray bar remove
		IfEqual, debug, 1, MsgBox, (autoconfig) Resolutions automatic :`n`nMainMonitorWidth=%MainMonitorWidth% - MainMonitorHeight=%MainMonitorHeight% (tray bar is removed)`n`nSecondMonitorWidth=%SecondMonitorWidth% - SecondMonitorHeight=%SecondMonitorHeight%
		goto, start

Goto, error_01

;;--- Software start here ---

Start:
	IfEqual, debug, 1, MsgBox, (Start) waiting shortcut=%shortcut%`n`nMainMonitorWidth=%MainMonitorWidth% MainMonitorHeight=%MainMonitorHeight%`n`nSecondMonitorWidth=%SecondMonitorWidth% SecondMonitorHeight=%SecondMonitorHeight%
	Menu, Tray, Icon, ico_monitor_w.ico
	KeyWait, %shortcut% , D
	WinGetTitle, WinActive, A
	IfEqual, Monitorcount, 1, goto, error_00

Movetray:
	;; debugmove start here
	;; The scale NOT occur in W H, causes bug with some windows ie: calcs, cmd, and others non modifiable size.
	activeWindow := WinActive("A")
	IfEqual, debugmove, 1, MsgBox, (Movetray) activeWindow=%activeWindow%`n`nWinactive=%WinActive%
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
	IfEqual, debugmove, 1, MsgBox, (WinGetPos) activewindows=%activeWindow%`n`nx=%x% y=%y% width=%width% height=%height%`n`nDetermine var to check if negative or positive : x=%x% SecondMonitorWidth=%SecondMonitorWidth% Mon2Left=%mon2left%
	;; Set windows dimentions if x < 0
	;; if screen is left (negative var)
	ifLess, mon2left, 0
	{
	xScale := MainMonitorWidth / secondMonitorWidth
	yScale := MainMonitorHeight / secondMonitorHeight
	newX := x * xScale
	newY := y * yScale
	newWidth := width 		;* xScale	;; no scale in W H
	newHeight := height 		;* yScale	;; no scale in W H
	newX += secondMonitorWidth			;; must be +

	SetEnv, newx1, %mon2Left%
	newx1 *=-1
	IfEqual, debugmove, 1, MsgBox, (Check) newx=%newx% ne doit pas etre plus grand que newx1=%newx1%

	IfLess, newx, %Mon1RIght%, Goto, skip3

	IfGreater, newx, %newx1%, Goto, skip3

	x := secondMonitorWidth + x
	newX *=-1


	skip3:
	}
	else
	{
	;; if x > 0 , Set windows dimentions if x > 0 , no scale in W H
	xScale := MainMonitorWidth / secondMonitorWidth
	yScale := MainMonitorHeight / secondMonitorHeight
	newX := x * xScale
	newY := y * yScale
	newWidth := width 		;* xScale	;; no scale in W H
	newHeight := height 		;* yScale	;; no scale in W H
	newX += secondMonitorWidth			;; must be +
	newX1 := MainMonitorWidth + MainMonitorWidth
	IfEqual, debugmove, 1, MsgBox, (isINsecmon) newx=%newx% ne doit pas etre plus grand que newx1=%newx1%
	IfGreater, newx, %newx1%, Goto, isINsecmon2
	x := secondMonitorWidth + x
	goto, skip4
	isINsecmon2:
	moin := MainMonitorWidth+secondMonitorWidth
	newX := newX - moin
	IfEqual, debugmove, 1, MsgBox, (issecmonright) change value newx newX=%newX%
	;;IfGreater, newx, 0, goto, skip4
	;;IfEqual, debugmove, 1, MsgBox, Newx is negative. newx=%newx% newX *=-1
	;;newX *=-1
	skip4:
	}


WinMove:
	IfEqual, debugmove, 1, MsgBox, (WinMove) Move windows with new dimentions. activeWindow=%activeWindow%`n`nnewx=%newX% newy=%newY% newWidth=%newWidth% newHeight=%newHeight%
	WinMove, ahk_id %activeWindow%, , %newX%, %newY%, %newWidth%, %newHeight%
	if minMax = 1
	{
	WinMaximize, ahk_id %activeWindow%
	}
	WinActivate ahk_id %activeWindow%  			;Needed - otherwise another window may overlap it
	KeyWait, %shortcut%
	IfEqual, debug, 1, MsgBox, (KeyWait) windows has moved ?
	goto, start

error_00:
	KeyWait, %shortcut%
	Random, error, 1111, 9999
	TrayTip, %title%, error_%error% You have only 1 screen. You must have at least 2 monitors. Something when wrong. !!! Do a reload !!! Maybe your screen or resolutions has changed, 2, 1
	Sleep, 500
	Goto, Start

error_01:
	Random, error, 1111, 9999
	TrayTip, %title%, error_%error% ERROR IN CONFIG FILES, 2, 1
	Sleep, 3000
	Goto, Close

error_03:
	Random, error, 1111, 9999
	TrayTip, %title%, error_%error% ERROR IN : secondmon left or right, 2, 1
	Sleep, 3000
	Goto, Close

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

Escape::			;; debug purpose
	Goto, ExitApp

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
	RightMonitorWidth = %Mon2Left%
	RightMonitorHeight = %Mon2Bottom%
	IfLess, RightMonitorWidth, -1, goto, negative3
	goto, msgboxMAS

	secretmanu:
	IniRead, MainMonitorWidth, MoveActiveToSecondMonitor.ini, options, MainMonitorWidth
	IniRead, MainMonitorHeight, MoveActiveToSecondMonitor.ini, options, MainMonitorHeight
	IniRead, RightMonitorWidth, MoveActiveToSecondMonitor.ini, options, RightMonitorWidth
	IniRead, RightMonitorHeight, MoveActiveToSecondMonitor.ini, options, RightMonitorHeight
	MainMonitorHeight -= traybar									; Tray bar
	IfLess, RightMonitorWidth, -1, goto, negative3
	goto, msgboxMAS

	negative3:
	RightMonitorWidth *=-1
	goto, msgboxMAS

	msgboxMAS:
	msgbox, 48, %title%,title=%title% mode=%mode% version=%version% author=%author% logoicon=%logoicon% A_ScriptDir=%A_ScriptDir% LastActive=%LastActive%`n`nThe active window is at X=%X% Y=%Y% W=%w% H=%h%`n`nMonitorPrimary=%MonitorPrimary% MonitorCount=%MonitorCount% shortcut=%shortcut% autoconfig=%autoconfig% traybar=%traybar%`n`nEcran 1 -- mon1Left=%Mon1Left% -- Top=%Mon1Top% -- Right=%Mon1Right% -- Bottom=%Mon1Bottom% ---`nEcran 2 -- mon2Left=%Mon2Left% -- Top=%Mon2Top% -- Right=%Mon2Right% -- Bottom=%Mon2Bottom%`n`nHere it must be your 2 resolutions :`n`nScreen 1 = %MainMonitorWidth% x %MainMonitorHeight% (Tray bar is removed)`nScreen 2 = %RightMonitorWidth% x %RightMonitorHeight%
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