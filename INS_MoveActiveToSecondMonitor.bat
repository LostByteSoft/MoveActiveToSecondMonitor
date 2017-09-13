@taskkill /f /im "MoveActiveToSecondMonitor.exe"
@echo ----------------------------------------------------------
cd "%~dp0"
copy "MoveActiveToSecondMonitor.exe" "C:\Program Files\"
copy "*.ico" "C:\Program Files\"
copy "*.ini" "C:\Program Files\"
copy "*.lnk" "%appdata%\Microsoft\Windows\Start Menu\Programs\Startup\"
@echo copy "*.lnk" "%appdata%\Microsoft\Windows\Start Menu\Programs\"
@echo ----------------------------------------------------------
@echo You can close this windows.
@"C:\Program Files\MoveActiveToSecondMonitor.exe"
@exit