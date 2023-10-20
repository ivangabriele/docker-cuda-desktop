#!/bin/bash
set -e

# Set VNC Server password
mkdir /home/ubuntu/.vnc
echo "${USER_PASSWORD}" | vncpasswd -f > /home/ubuntu/.vnc/passwd
chmod 600 /home/ubuntu/.vnc/passwd

# Kill old VNC Server if still running
# vncserver -kill :1 || rm -Rfv /tmp/.X*-lock /tmp/.X11-unix || echo "No previous VNC Server running."

/usr/bin/startplasma-x11 &

vncconfig -nowin &

# Start VNC Server
# vncserver "${DISPLAY}" -geometry "${VNC_SCREEN_SIZE}" -depth 24
# https://tigervnc.org/doc/Xvnc.html
/usr/bin/Xvnc "${DISPLAY}" \
  -depth 24 \
  -geometry "${VNC_SCREEN_SIZE}" \
  -NeverShared \
  -PasswordFile /home/ubuntu/.vnc/passwd
# /usr/bin/Xvnc "${DISPLAY}" -geometry "${VNC_SCREEN_SIZE}" -depth 24 -SecurityTypes none -AlwaysShared

# Get VNC Server PID
# VNC_PID=$!

# sleep 5

# Tail VNC Server logs
tail -f ~/.vnc/*.log
# tail -f "${HOME}/.vnc/*.log"

# Wait to keep container running
# wait $VNC_PID

# while true; do
#   lsof -i -P -n | grep LISTEN
#   sleep 5
# done
