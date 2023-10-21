#!/bin/bash
set -e

# ------------------------------------------------------------------------------
# Functions

wait_countdown() {
  local seconds=$1
  for ((i=seconds; i>=1; i--)); do
    echo "[CUDA Desktop] Waiting for ${i}s..."
    sleep 1
  done
}

# ------------------------------------------------------------------------------
# Shell

source /home/ubuntu/.bashrc

# ------------------------------------------------------------------------------
# D-Bus

# Start dbus-daemon
echo "[CUDA Desktop] Starting D-Bus daemon..."
DBUS_SESSION_BUS_ADDRESS=$(dbus-daemon --config-file=/usr/share/dbus-1/session.conf --fork --print-address)
# Check if D-Bus daemon started successfully and print its address
if [[ ! -z "$DBUS_SESSION_BUS_ADDRESS" ]]; then
  echo "[CUDA Desktop] D-Bus daemon is running at address: ${DBUS_SESSION_BUS_ADDRESS}."

  # Export D-Bus address for other processes to use
  export DBUS_SESSION_BUS_ADDRESS=$DBUS_SESSION_BUS_ADDRESS

  wait_countdown 10
else
  echo "[CUDA Desktop] [ERROR] Failed to start D-Bus daemon."
  exit 1
fi

# ------------------------------------------------------------------------------
# Supervisor

# sudo /usr/bin/supervisord &

# ------------------------------------------------------------------------------
# KDE Plasma Desktop

echo "
[KDE]
LookAndFeelPackage=org.kde.breezedark.desktop
SingleClick=false

[KDE Action Restrictions]
action/lock_screen=false
logout=false
" >> /home/ubuntu/.config/kdeglobals

echo "
[Daemon]
Autolock=false
LockOnResume=false
" > /home/ubuntu/.config/kscreenlockerrc

echo "[CUDA Desktop] Starting KDE Plasma Desktop (X11)..."
/usr/bin/startplasma-x11 &

# ------------------------------------------------------------------------------
# VNC Server

# Set VNC Server password
echo "[CUDA Desktop] Setting VNC Server password..."
mkdir /home/ubuntu/.vnc
echo "${VNC_PASSWORD}" | vncpasswd -f > /home/ubuntu/.vnc/passwd
chmod 600 /home/ubuntu/.vnc/passwd

echo "[CUDA Desktop] Preparing VNC Server..."
vncconfig -nowin &

# Start VNC Server
echo "[CUDA Desktop] Starting VNC Server..."
# https://tigervnc.org/doc/Xvnc.html
/usr/bin/Xvnc "${DISPLAY}" \
  -depth 24 \
  -geometry "${VNC_SCREEN_SIZE}" \
  -NeverShared \
  -PasswordFile /home/ubuntu/.vnc/passwd
# Tail VNC Server logs
tail -f ~/.vnc/*.log
