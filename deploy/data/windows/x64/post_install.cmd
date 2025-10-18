set SotkaPath=%~dp0
echo %SotkaPath%

sc stop AmneziaWGTunnel$Sotka
sc delete AmneziaWGTunnel$Sotka
taskkill /IM "Sotka-service.exe" /F
taskkill /IM "Sotka.exe" /F
REG ADD "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /V Sotka /t REG_SZ /F /D "%SotkaPath%Sotka.exe"
REG ADD "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run" /V Sotka /t REG_BINARY /F /D "020000000000000000000000"

exit /b 0
