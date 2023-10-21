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
# Global Applications & Utilities

RUN apt-get install -y \
  alsa-base \
  alsa-utils \
  apt-transport-https \
  apt-utils \
  build-essential \
  bzip2 \
  ca-certificates \
  cups-browsed \
  cups-bsd \
  cups-common \
  cups-filters \
  cups-pdf \
  dbus-x11 \
  debconf-kde-helper \
  dolphin \
  file \
  fonts-dejavu \
  fonts-freefont-ttf \
  fonts-hack \
  fonts-liberation \
  fonts-noto \
  fonts-noto-cjk \
  fonts-noto-cjk-extra \
  fonts-noto-color-emoji \
  fonts-noto-extra \
  fonts-noto-hinted \
  fonts-noto-mono \
  fonts-noto-ui-extra \
  fonts-noto-unhinted \
  fonts-opensymbol \
  fonts-symbola \
  fonts-ubuntu \
  gcc \
  gnupg \
  gzip \
  i965-va-driver-shaders \
  intel-media-va-driver-non-free \
  jq \
  kdeadmin \
  kde-config-fcitx \
  kde-config-gtk-style \
  kde-config-gtk-style-preview \
  kdeconnect \
  kdegraphics-thumbnailers \
  kde-spectacle \
  kmod \
  lame \
  less \
  libavcodec-extra \
  libc6-dev \
  libdbus-c++-1-0v5 \
  libdbusmenu-glib4 \
  libdbusmenu-gtk3-4 \
  libegl1 \
  libegl1-mesa-dev \
  libelf-dev \
  libgail-common \
  libgdk-pixbuf2.0-bin \
  libgl1 \
  libgl1-mesa-dev \
  libgles2 \
  libgles2-mesa-dev \
  libglu1 \
  libglvnd-dev \
  libglvnd0 \
  libglx0 \
  libgtk-3-bin \
  libgtk2.0-bin \
  libkf5baloowidgets-bin \
  libkf5dbusaddons-bin \
  libkf5iconthemes-bin \
  libkf5kdelibs4support5-bin \
  libkf5khtml-bin \
  libkf5parts-plugins \
  libpci3 \
  libpulse0 \
  libqt5multimedia5-plugins \
  librsvg2-common \
  libsm6 \
  libva2 \
  libvulkan-dev \
  libx11-6 \
  libxau6 \
  libxcb1 \
  libxdmcp6 \
  libxext6 \
  libxrandr-dev \
  libxtst6 \
  libxv1 \
  make \
  net-tools \
  packagekit-tools \
  pkg-config \
  polkit-kde-agent-1 \
  pulseaudio \
  qapt-deb-installer \
  qml-module-org-kde-runnermodel \
  qml-module-org-kde-qqc2desktopstyle \
  qml-module-qtgraphicaleffects \
  qml-module-qtquick-xmllistmodel \
  qt5-gtk-platformtheme \
  qt5-image-formats-plugins \
  qt5-style-plugins \
  qtspeech5-flite-plugin \
  qtvirtualkeyboard-plugin \
  snapd \
  software-properties-common \
  software-properties-qt \
  ssl-cert \
  sudo \
  supervisor \
  tzdata \
  x11-apps \
  x11-utils \
  x11-xkb-utils \
  x11-xserver-utils \
  xauth \
  xbitmaps \
  xdg-desktop-portal-kde \
  xdg-user-dirs \
  xdg-user-dirs \
  xdg-utils \
  xfonts-base \
  xfonts-scalable \
  xinit \
  xkb-data \
  xorg \
  xserver-xorg-input-all \
  xserver-xorg-input-wacom \
  xserver-xorg-video-all \
  xserver-xorg-video-intel \
  xserver-xorg-video-qxl \
  xsettingsd \
  xz-utils \
  zsh

# Firefox ESR
RUN add-apt-repository ppa:mozillateam/ppa && \
  apt-get update && \
  apt-get install -y firefox-esr

# Make Falkon the default browser
RUN update-alternatives --set x-www-browser /usr/bin/firefox-esr

# ----------------------------------------------------------
# KDE Plasma Desktop

RUN apt-get install -y plasma-desktop

# Fix KDE startup permissions issues in containers
RUN cp -f /usr/lib/x86_64-linux-gnu/libexec/kf5/start_kdeinit /tmp/ && \
  rm -f /usr/lib/x86_64-linux-gnu/libexec/kf5/start_kdeinit && \
  cp -r /tmp/start_kdeinit /usr/lib/x86_64-linux-gnu/libexec/kf5/start_kdeinit && \
  rm -f /tmp/start_kdeinit

# ----------------------------------------------------------
# VNC Server

EXPOSE 5900

ENV DISPLAY=:0
ENV VNC_PASSWORD=password
ENV VNC_SCREEN_SIZE=1920x1080

RUN apt-get install -y \
  tigervnc-standalone-server \
  tigervnc-xorg-extension

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
  sudo apt-get install -y code && \
  sed 's~Exec=/usr/share/code/code~Exec=/usr/share/code/code --no-sandbox~' /usr/share/applications/code.desktop \
  | sudo tee /usr/share/applications/code.desktop > /dev/null

# ------------------------------------------------------------------------------
# Boot

# Fix `QStandardPaths: XDG_RUNTIME_DIR not set, defaulting to '/tmp/runtime-root'` error
RUN sudo mkdir -p /run/user/1000 && \
  sudo chown -R ubuntu:ubuntu /run/user/1000 && \
  sudo chmod -R 700 /run/user/1000
ENV XDG_RUNTIME_DIR=/run/user/1000

# Fix `/usr/bin/xauth:  file /home/ubuntu/.Xauthority does not exist` error
RUN touch /home/ubuntu/.Xauthority

# COPY ./etc/supervisor/conf.d/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

COPY ./home/ubuntu/* /home/ubuntu
RUN cat /home/ubuntu/.zshrc.complement >> /home/ubuntu/.zshrc
# Make zsh the default shell
RUN sudo chsh -s $(which zsh) $(whoami)

COPY ./entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
