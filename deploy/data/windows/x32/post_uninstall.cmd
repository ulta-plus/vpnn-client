set AmneziaPath=%~dp0
echo %AmneziaPath%

"%AmneziaPath%\Ulta.exe" -c
timeout /t 1
sc stop Ulta-service
sc delete Ulta-service
sc stop AmneziaWGTunnel$Ulta
sc delete AmneziaWGTunnel$Ulta
taskkill /IM "Ulta-service.exe" /F
taskkill /IM "Ulta.exe" /F
exit /b 0
