#!/bin/bash
set -e

# Set VNC Server password
# echo "${VNC_PASSWORD}" | vncpasswd -f > "${HOME}/.vnc/passwd"
# chmod 600 "${HOME}/.vnc/passwd"

# Kill old VNC Server if still running
# vncserver -kill :1 || rm -Rfv /tmp/.X*-lock /tmp/.X11-unix || echo "No previous VNC Server running."

# Start VNC Server
# vncserver "${DISPLAY}" -geometry "${VNC_SCREEN_SIZE}" -depth 24
/usr/bin/Xvnc "${DISPLAY}" -geometry "${VNC_SCREEN_SIZE}" -depth 24 -SecurityTypes none -AlwaysShared

# Get VNC Server PID
# VNC_PID=$!

# sleep 5

# Tail VNC Server logs
tail -f $HOME/.vnc/*.log
# tail -f "${HOME}/.vnc/*.log"

# Wait to keep container running
# wait $VNC_PID

# while true; do
#   lsof -i -P -n | grep LISTEN
#   sleep 5
# done

