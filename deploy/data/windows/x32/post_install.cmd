sc stop AmneziaWGTunnel$Sotka
sc delete AmneziaWGTunnel$Sotka
taskkill /IM "Sotka-service.exe" /F
taskkill /IM "Sotka.exe" /F
exit /b 0
