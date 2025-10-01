set SotkaPath=%~dp0
echo %SotkaPath%

sc stop AmneziaWGTunnel$Sotka
sc delete AmneziaWGTunnel$Sotka
taskkill /IM "Sotka-service.exe" /F
taskkill /IM "Sotka.exe" /F
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /V Sotka /t REG_SZ /F /D "%SotkaPath%Sotka.exe"
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run" /V Sotka /t REG_BINARY /F /D "020000000000000000000000"

exit /b 0
