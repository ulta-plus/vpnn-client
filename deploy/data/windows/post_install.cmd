sc stop AmneziaWGTunnel$VPNNaruzhu
sc delete AmneziaWGTunnel$VPNNaruzhu
taskkill /IM "VPNNaruzhu-service.exe" /F
taskkill /IM "VPNNaruzhu.exe" /F
REG ADD "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run" /V VPNNaruzhu /t REG_SZ /F /D "%VPNNaruzhuPath%VPNNaruzhu.exe"
REG ADD "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run" /V VPNNaruzhu /t REG_BINARY /F /D "020000000000000000000000"
exit /b 0
