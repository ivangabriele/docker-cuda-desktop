# ==============================================================================
# BASE

ARG FROM_TAG

# https://catalog.ngc.nvidia.com/orgs/nvidia/containers/pytorch
FROM nvcr.io/nvidia/pytorch:${FROM_TAG} as base

RUN mkdir /_install

# ----------------------------------------------------------
# Ubuntu Environment Variables

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV TZ UTC

RUN apt update && apt upgrade -y
# Install locales to prevent X11 errors
RUN apt install -y locales && \
  echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
  locale-gen en_US.UTF-8

# ==============================================================================
# DESKTOP

FROM base as desktop

ENV DEBIAN_FRONTEND=noninteractive

# ----------------------------------------------------------
# KDE Desktop Plasma

RUN apt install -y dbus-x11 plasma-desktop
# KDE disable screen lock, double-click to open instead of single-click
RUN echo "[Daemon]\n\
  Autolock=false\n\
  LockOnResume=false" > /etc/xdg/kscreenlockerrc && \
  echo "[KDE]\n\
  SingleClick=false\n\
  \n\
  [KDE Action Restrictions]\n\
  action/lock_screen=false\n\
  logout=false" > /etc/xdg/kdeglobals

# ==============================================================================
# SERVER

FROM desktop as server

ENV DEBIAN_FRONTEND=noninteractive

# ----------------------------------------------------------
# VNC Server

RUN apt install -y tigervnc-standalone-server tigervnc-xorg-extension

# ----------------------------------------------------------
# Utilities

# RUN apt install -y dolphin konsole
RUN apt install -y \
  lsof

# ----------------------------------------------------------
# OS User

ARG USER_NAME=ubuntu

ENV PGID=0
ENV PUID=0
ENV USER_NAME=${USER_NAME}

ENV HOME=/home/${USER_NAME}

# Create user and disable both password and gecos for later
# https://askubuntu.com/a/1195288/635348
RUN adduser --disabled-password --gecos '' --home "${HOME}" --ingroup root --shell /bin/bash --uid 1001 "${USER_NAME}"
# Add user to `sudo` group
RUN adduser "${USER_NAME}" sudo
# Ensure sudo group users are not asked for a password when using sudo command by ammending sudoers file
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER "${USER_NAME}"
WORKDIR ${HOME}
CMD /bin/bash
ENV USER=${USER_NAME}

# ----------------------------------------------------------
# VNC Server Setup

EXPOSE 5900
EXPOSE 5901

ENV DISPLAY=:1
ENV VNC_PASSWORD=password
ENV VNC_SCREEN_SIZE=1920x1080

# Fix `QStandardPaths: XDG_RUNTIME_DIR not set, defaulting to '/tmp/runtime-ubuntu'` error
ENV XDG_RUNTIME_DIR=/tmp/runtime-root

# Fix `/usr/bin/xauth:  file /home/ubuntu/.Xauthority does not exist` error
RUN touch "${HOME}/.Xauthority"
# Start KDE during VNC Server startup
RUN mkdir -p "${HOME}/.vnc"
COPY ./kde/xstartup "${HOME}/.vnc/xstartup"

# RUN useradd -U -u 6006 -d "${HOME}" "${USER_NAME}" && \
#   usermod -G users "${USER_NAME}"

# ----------------------------------------------------------
# Boot

COPY ./entrypoint.sh /home/ubuntu/entrypoint.sh

ENTRYPOINT ["/home/ubuntu/entrypoint.sh"]
