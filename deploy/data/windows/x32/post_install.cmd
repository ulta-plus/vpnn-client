sc stop AmneziaWGTunnel$VPNNaruzhu
sc delete AmneziaWGTunnel$VPNNaruzhu
taskkill /IM "VPNNaruzhu-service.exe" /F
taskkill /IM "VPNNaruzhu.exe" /F
exit /b 0
