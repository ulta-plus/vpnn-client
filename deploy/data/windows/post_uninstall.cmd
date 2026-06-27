set AmneziaPath=%~dp0
echo %AmneziaPath%

rem Define directories for logs
set "ORG_DIR=%AppData%\VPNNaruzhu.ORG"
set "USER_APP_DIR=%ORG_DIR%\VPNNaruzhu"
set "USER_LOG_DIR=%USER_APP_DIR%\log"
set "SYS_APP_DIR=%ProgramData%\VPNNaruzhu"
set "SYS_LOG_DIR=%SYS_APP_DIR%\log"
set "SYS_LOG_FILE=%SYS_LOG_DIR%\VPNNaruzhu-service.log"

timeout /t 1
sc stop VPNNaruzhu-service
sc delete VPNNaruzhu-service
sc stop AmneziaWGTunnel$VPNNaruzhu
sc delete AmneziaWGTunnel$VPNNaruzhu
taskkill /IM "VPNNaruzhu-service.exe" /F
taskkill /IM "VPNNaruzhu.exe" /F
reg delete "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run" /v VPNNaruzhu /f

rem Delete the service log file under ProgramData
if exist "%SYS_LOG_FILE%" del /F /Q "%SYS_LOG_FILE%"
if exist "%SYS_LOG_DIR%" rmdir /S /Q "%SYS_LOG_DIR%"
rem Try to remove application dir if empty
rd "%SYS_APP_DIR%" 2>nul

rem Delete client logs under current user's AppData\Roaming (Organization\Application)
if exist "%USER_LOG_DIR%" rmdir /S /Q "%USER_LOG_DIR%"
rem Try to remove app and org directories if empty
rd "%USER_APP_DIR%" 2>nul
rd "%ORG_DIR%" 2>nul

exit /b 0
