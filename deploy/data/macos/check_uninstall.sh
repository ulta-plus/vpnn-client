#!/bin/bash
if [ -d "/Applications/VPNNaruzhu.app" ] || pgrep -x "VPNNaruzhu-service" >/dev/null; then
  exit 0
fi
exit 1
