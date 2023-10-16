ARG FROM_TAG

# https://catalog.ngc.nvidia.com/orgs/nvidia/containers/pytorch
FROM nvcr.io/nvidia/pytorch:${FROM_TAG}

EXPOSE 5901

# ------------------------------------------------------------------------------
# User Environment Variables

ENV VNC_PASSWORD="password"
ENV VNC_USER="root"

# ------------------------------------------------------------------------------
# Ubuntu Environment Variables

# Use noninteractive mode to skip confirmation when installing packages
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV TZ UTC

# ------------------------------------------------------------------------------
# Ubuntu Setup

# Install locales to prevent X11 errors
RUN apt-get clean && \
  apt-get update && apt-get install --no-install-recommends -y locales && \
  locale-gen en_US.UTF-8

# ------------------------------------------------------------------------------
# GPU Environment Variables

# Disable VSYNC for NVIDIA GPUs
ENV __GL_SYNC_TO_VBLANK 0
# All NVIDIA driver capabilities should preferably be used
ENV NVIDIA_DRIVER_CAPABILITIES all
# Enable GUI-based applications to connect to X server by selecting first available display as default
ENV DISPLAY :0

# ------------------------------------------------------------------------------
# KDE Desktop Plasma

RUN apt-get install --no-install-recommends -y kde-plasma-desktop
# Fix KDE startup permissions issues in containers
RUN cp -f /usr/lib/x86_64-linux-gnu/libexec/kf5/start_kdeinit /tmp/ && \
  rm -f /usr/lib/x86_64-linux-gnu/libexec/kf5/start_kdeinit && \
  cp -r /tmp/start_kdeinit /usr/lib/x86_64-linux-gnu/libexec/kf5/start_kdeinit && \
  rm -f /tmp/start_kdeinit
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

# ------------------------------------------------------------------------------
# Various Fixes

# Fix Xtightvnc & some font-related errors
RUN apt-get install --no-install-recommends -y \
  xfonts-base \
  xfonts-scalable
# Fix `xauth: file /root/.Xauthority does not exist' error
RUN touch ~/.Xauthority
# Fix `xrdb: can't open file '/root/.Xresources' error
RUN touch ~/.Xresources

# ------------------------------------------------------------------------------
# Utilities

# Visual Studio Code
# https://code.visualstudio.com/docs/setup/linux#_debian-and-ubuntu-based-distributions
RUN wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg && \
  install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg && \
  sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list' && \
  rm -f packages.microsoft.gpg && \
  apt-get update && \
  apt-get install -y code

# ------------------------------------------------------------------------------
# VNC Server

ENV USER=${VNC_USER}

RUN apt-get install -y tightvncserver

COPY ./entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
