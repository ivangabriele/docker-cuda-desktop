# ==============================================================================
# BASE

ARG FROM_TAG

# https://catalog.ngc.nvidia.com/orgs/nvidia/containers/pytorch
FROM nvcr.io/nvidia/pytorch:${FROM_TAG} as base

ENV DEBIAN_FRONTEND=noninteractive

# ----------------------------------------------------------
# Ubuntu Setup

RUN apt-get clean && apt-get update && apt-get upgrade -y

# Install locales to prevent X11 errors
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV TZ UTC
RUN apt-get install -y locales && \
  locale-gen en_US.UTF-8

# ==============================================================================
# DESKTOP

FROM base as desktop

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update

# ----------------------------------------------------------
# KDE Desktop Plasma

RUN apt-get install -y \
  dbus-x11 \
  plasma-desktop

# ----------------------------------------------------------
# VNC Server

EXPOSE 5900

ENV DISPLAY=:0
ENV VNC_PASSWORD=password
ENV VNC_SCREEN_SIZE=1920x1080

RUN apt-get install -y \
  tigervnc-standalone-server \
  tigervnc-xorg-extension

# ----------------------------------------------------------
# OS Applications & Utilities

RUN apt-get install -y \
  apt-transport-https \
  apt-utils \
  build-essential \
  ca-certificates \
  dolphin \
  falkon \
  gnupg \
  make \
  snapd \
  software-properties-common \
  ssl-cert \
  sudo \
  tzdata \
  zsh

# Make Falkon the default browser
RUN update-alternatives --set x-www-browser /usr/bin/falkon

# ==============================================================================
# FINAL

FROM desktop as final

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update

# ------------------------------------------------------------------------------
# User Setup

ENV USER_PASSWORD=password

RUN rm -rf /var/lib/apt/lists/*

RUN groupadd -g 1000 ubuntu && \
  useradd -ms /bin/bash ubuntu -u 1000 -g 1000 && \
  # `ssl-cert` group?
  usermod -a -G adm,audio,cdrom,dialout,dip,fax,floppy,input,lp,plugdev,pulse-access,ssl-cert,sudo,tape,tty,video,voice ubuntu && \
  echo "ubuntu ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
  chown ubuntu:ubuntu /home/ubuntu && \
  echo "ubuntu:${USER_PASSWORD}" | chpasswd && \
  ln -snf "/usr/share/zoneinfo/$TZ" /etc/localtime && echo "$TZ" > /etc/timezone

# Create user and disable both password and gecos for later
# https://askubuntu.com/a/1195288/635348
# RUN adduser --disabled-password --gecos '' --home "${HOME}" --ingroup root --shell /bin/bash --uid 6006 "${USER_NAME}"
# Add user to `sudo` group
# RUN adduser "${USER_NAME}" sudo
# Ensure sudo group users are not asked for a password when using sudo command by ammending sudoers file
# RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER ubuntu
WORKDIR /home/ubuntu
# CMD /bin/bash
ENV USER=ubuntu

# ------------------------------------------------------------------------------
# User Applications & Utilities

RUN sudo add-apt-repository universe

# Fonts
RUN sudo apt-get install fonts-firacode

# Kitty
# https://sw.kovidgoyal.net/kitty/binary/#binary-install
RUN mkdir ~/.local
RUN curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
RUN mkdir -p ~/.local/bin ~/.local/share/applications && \
  ln -sf ~/.local/kitty.app/bin/kitty ~/.local/kitty.app/bin/kitten ~/.local/bin/ && \
  # Place the kitty.desktop file somewhere it can be found by the OS
  cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/ && \
  # If you want to open text files and images in kitty via your file manager also add the kitty-open.desktop file
  cp ~/.local/kitty.app/share/applications/kitty-open.desktop ~/.local/share/applications/ && \
  # Update the paths to the kitty and its icon in the kitty.desktop file(s)
  sed -i "s|Icon=kitty|Icon=/home/$USER/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty*.desktop && \
  sed -i "s|Exec=kitty|Exec=/home/$USER/.local/kitty.app/bin/kitty|g" ~/.local/share/applications/kitty*.desktop

# Oh My Zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Sublime Text
# https://www.geeksforgeeks.org/how-to-install-sublime-text-editor-on-ubuntu/
RUN wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg > /dev/null && \
  echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list && \
  sudo apt-get update && \
  sudo apt-get install sublime-text

# Visual Studio Code
# https://code.visualstudio.com/docs/setup/linux#_debian-and-ubuntu-based-distributions
RUN wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg && \
  sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg && \
  sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list' && \
  rm -f packages.microsoft.gpg && \
  sudo apt-get update && \
  sudo apt-get install -y code

# ------------------------------------------------------------------------------
# Clean

# RUN apt autoremove -y && \
#   sudo apt clean && \
#   rm -r /_install

# ------------------------------------------------------------------------------
# Boot

COPY ./entrypoint.sh /home/ubuntu/entrypoint.sh
COPY ./init.sh /home/ubuntu/Desktop/init.sh

ENTRYPOINT ["/home/ubuntu/entrypoint.sh"]
