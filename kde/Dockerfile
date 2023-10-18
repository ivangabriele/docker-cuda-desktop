ARG FROM_TAG

# https://catalog.ngc.nvidia.com/orgs/nvidia/containers/pytorch
FROM nvcr.io/nvidia/pytorch:${FROM_TAG} as base

ARG S6_VER="2.0.0.1"

RUN mkdir /_install

## S6 Overlay
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_VER}/s6-overlay-amd64.tar.gz /_install
RUN tar xzf /_install/s6-overlay-amd64.tar.gz -C / --exclude="./bin" && \
  tar xzf /_install/s6-overlay-amd64.tar.gz -C /usr ./bin
ENTRYPOINT ["/init"]

## KDE
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && \
  apt upgrade -y && \
  apt install -y plasma-desktop
RUN apt install -y dbus-x11

## Other Applications
RUN apt install -y dolphin konsole

## VNC
RUN apt install -y tigervnc-standalone-server tigervnc-xorg-extension
ENV DISPLAY=:0 \
  VNC_SCREEN_SIZE=1920x1080
EXPOSE 5900

## USER
ENV PGID=0 \
  PUID=0 \
  ROOT_PASSWORD=password \
  HOME=/home/ubuntu
RUN useradd -U -u 6006 -d "$HOME" ubuntu && \
  usermod -G users ubuntu
WORKDIR /

# RUN yes | unminimize
COPY ./kde/_root /
COPY ./kde/root /

# ------------------------------------------------------------------------------
# Utilities

# Visual Studio Code
# https://code.visualstudio.com/docs/setup/linux#_debian-and-ubuntu-based-distributions
# RUN wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg && \
#   install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg && \
#   sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list' && \
#   rm -f packages.microsoft.gpg && \
#   apt-get update && \
#   apt-get install -y code

# ------------------------------------------------------------------------------
# Clean

RUN apt autoremove -y && \
  apt clean && \
  rm -r /_install
