#!/bin/bash
if [ -d "/Applications/VPNNaruzhu.app" ] || pgrep -x "VPNNaruzhu-service" >/dev/null; then
  exit 1
fi
exit 0
