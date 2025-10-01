set AmneziaPath=%~dp0
echo %AmneziaPath%

"%AmneziaPath%\Sotka.exe" -c
timeout /t 1
sc stop Sotka-service
sc delete Sotka-service
sc stop AmneziaWGTunnel$Sotka
sc delete AmneziaWGTunnel$Sotka
taskkill /IM "Sotka-service.exe" /F
taskkill /IM "Sotka.exe" /F
exit /b 0
