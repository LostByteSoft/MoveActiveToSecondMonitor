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


	; verify to not overpass the screen border if sceen is smaller than the one

;;--- Softwares Variables ---

	SetWorkingDir, %A_ScriptDir%
	#SingleInstance Force
	#Persistent
	#NoEnv
	SetTitleMatchMode, Slow
	SetTitleMatchMode, 2

	IniRead, leftMonitorWidth, MoveActiveToSecondMonitor.ini, options, leftMonitorWidth
	IniRead, leftMonitorHeight, MoveActiveToSecondMonitor.ini, options, leftMonitorHeight
	IniRead, rightMonitorWidth, MoveActiveToSecondMonitor.ini, options, rightMonitorWidth
	IniRead, rightMonitorHeight, MoveActiveToSecondMonitor.ini, options, rightMonitorHeight
	IniRead, shortcut, MoveActiveToSecondMonitor.ini, options, shortcut

	SetEnv, title, MoveActiveToSecondMonitor
	SetEnv, mode, Toggle move %shortcut%
	SetEnv, version, Version 2017-09-11-1037
	SetEnv, Author, LostByteSoft
	SetEnv, fullscreen, 0

	SysGet, MonitorCount, MonitorCount
	SysGet, MonitorPrimary, MonitorPrimary
	SysGet, Mon1, Monitor, 1
	SysGet, Mon2, Monitor, 2

	FileInstall, ico_about.ico, ico_about.ico, 0
	FileInstall, ico_HotKeys.ico, ico_HotKeys.ico, 0
	FileInstall, ico_lock.ico, ico_lock.ico, 0
	FileInstall, ico_monitor_w.ico, ico_monitor_w.ico, 0
	FileInstall, ico_monitor.ico, ico_monitor.ico, 0
	FileInstall, ico_shut.ico, ico_shut.ico, 0
	FileInstall, ico_reboot.ico, ico_reboot.ico, 0
	FileInstall, ico_options.ico, ico_options.ico, 0

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
	Menu, tray, add, Change settings, settings					; Show version
	Menu, Tray, Icon, Change settings, ico_options.ico
	Menu, tray, add,
	Menu, tray, add, Exit, Exit						; GuiClose exit program
	Menu, Tray, Icon, Exit, ico_shut.ico
	Menu, tray, add, Refresh FitScreen, doReload				; Reload the script. Usefull if you change something in configuration
	Menu, Tray, Icon, Refresh FitScreen, ico_reboot.ico
	menu, tray, add,

	Menu, tray, add, Hotkey : F4, tray
	Menu, Tray, Icon, Hotkey : F4, ico_HotKeys.ico
	menu, tray, add
	Menu, Tray, Tip, %mode%

;;--- Software start here ---

	IfEqual, MonitorCount, 1, goto, error_00
	TrayTip, %title%, %mode%, 2, 1

	;; developpement for autodetect resolutions, work but not really well
	;; leftMonitorWidth = 1920	;; leftMonitorHeight = 1080	;; rightMonitorWidth = 1920	;; rightMonitorHeight = 1080

	; newrightMonitorWidth := Mon2Right - Mon1Right
	; newleftMonitorHeight := Mon1Bottom - 38		; Tray bar
	;; leftMonitorWidth = %Mon1Right%
	;; leftMonitorHeight = %newleftMonitorHeight%
	;; rightMonitorWidth = %newrightMonitorWidth%
	;; rightMonitorHeight = %Mon2Bottom%

	;; msgbox, LastActive=%LastActive%`n`nThe active window is at %X% %Y% %w%`n`nMonitorPrimary=%MonitorPrimary% MonitorCount=%MonitorCount%`n`nEcran 1 -- mon1Left=%Mon1Left% -- Top=%Mon1Top% -- Right=%Mon1Right% -- Bottom=%Mon1Bottom% ---`n`nEcran 2 -- mon2Left=%Mon2Left% -- Top=%Mon2Top% -- Right=%Mon2Right% -- Bottom=%Mon2Bottom%`n`nHere it must be your 2 resolutions .. Screen 1 = %leftMonitorWidth% %leftMonitorHeight% Screen 2 =  %rightMonitorWidth% %rightMonitorHeight%

Start:
	KeyWait, %shortcut% , D
	IfEqual, MonitorCount, 1, goto, 1mon

Movetray:

	activeWindow := WinActive("A")
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
			xScale := rightMonitorWidth / leftMonitorWidth
			yScale := rightMonitorHeight / leftMonitorHeight
			x := leftMonitorWidth + x
			newX := x * xScale
			newY := y * yScale
			newWidth := width * xScale
			newHeight := height * yScale
		}
	else
		{
			xScale := leftMonitorWidth / rightMonitorWidth
			yScale := leftMonitorHeight / rightMonitorHeight
			newX := x * xScale
			newY := y * yScale
			newWidth := width * xScale
			newHeight := height * yScale
			newX := newX - leftMonitorWidth
		}
	WinMove, ahk_id %activeWindow%, , %newX%, %newY%, %newWidth%, %newHeight%
	if minMax = 1
		{
			WinMaximize, ahk_id %activeWindow%
		}
	WinActivate ahk_id %activeWindow%   ;Needed - otherwise another window may overlap it
	Sleep, 500
	goto, start

error_00:
	Random, error_00, 1, 128000
	MsgBox, error_%error_00% You have only 1 screen. You must have at least 2 monitors. This is an random error generator.
	Goto, Start

;;--- Quit (escape , esc) ---

Exit:
	ExitApp

;;--- Tray Bar (must be at end of file) ---

tray:
	TrayTip, %title%, You must click on an windows., 2, 1
	KeyWait, LButton, D
	Goto, Movetray

secret:
	TrayTip, %title%, You must click on an windows., 2, 1
	KeyWait, LButton, D
	WinGetTitle, LastActive, A
	WinGetPos, X, Y, w, h, A
	msgbox, LastActive=%LastActive%`n`nThe active window is at %X% %Y% %w%`n`nMonitorPrimary=%MonitorPrimary% MonitorCount=%MonitorCount%`n`nEcran 1 -- mon1Left=%Mon1Left% -- Top=%Mon1Top% -- Right=%Mon1Right% -- Bottom=%Mon1Bottom% ---`n`nEcran 2 -- mon2Left=%Mon2Left% -- Top=%Mon2Top% -- Right=%Mon2Right% -- Bottom=%Mon2Bottom%`n`nHere it must be your 2 resolutions .. Screen 1 = %leftMonitorWidth% %leftMonitorHeight% Screen 2 =  %rightMonitorWidth% %rightMonitorHeight%
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

settings:
	run, notepad.exe "MoveActiveToSecondMonitor.ini"
	Sleep, 1000
	return

1mon:
	TrayTip, %title%, You must have 2 monitors, 2, 1
	goto, start

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