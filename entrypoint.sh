#!/bin/bash
set -e

# ------------------------------------------------------------------------------
# Functions

sync_backup() {
  while true; do
    echo "[CUDA Desktop] Syncing /home/ubuntu to /volumes/home_ubuntu_backup..."
    rsync -a --delete /home/ubuntu/ /volumes/home_ubuntu_backup/
    sleep 60
  done
}

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
# Backup Volume

if [ -d "/volumes/home_ubuntu_backup" ]; then
  sudo chown -R ubuntu:ubuntu /volumes/home_ubuntu_backup
  sudo chmod -R 755 /volumes/home_ubuntu_backup

  # Check if the volume is empty
  if [ -z "$(ls -A /volumes/home_ubuntu_backup)" ]; then
    # If it's empty, sync /home/ubuntu to /volumes/home_ubuntu_backup
    echo "[CUDA Desktop] Initializing backup volume with data from /home/ubuntu..."
    rsync -a /home/ubuntu/ /volumes/home_ubuntu_backup/
  else
    # If it's not empty, restore contents into /home/ubuntu
    echo "[CUDA Desktop] Restoring data into /home/ubuntu from backup volume..."
    rsync -a /volumes/home_ubuntu_backup/ /home/ubuntu/
  fi

  sync_backup &
fi

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
