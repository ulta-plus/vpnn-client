sc stop AmneziaWGTunnel$Ulta
sc delete AmneziaWGTunnel$Ulta
taskkill /IM "Ulta-service.exe" /F
taskkill /IM "Ulta.exe" /F
exit /b 0
