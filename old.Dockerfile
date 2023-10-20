ARG FROM_TAG

# https://catalog.ngc.nvidia.com/orgs/nvidia/containers/pytorch
FROM nvcr.io/nvidia/pytorch:${FROM_TAG}

ARG S6_VER="2.0.0.1"

# ----------------------------------------------------------
# Ubuntu Setup

ENV DEBIAN_FRONTEND=noninteractive

# Install locales to prevent X11 errors
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV TZ UTC
RUN apt-get clean && apt-get update && apt-get install --no-install-recommends -y locales && \
  rm -rf /var/lib/apt/lists/* && \
  locale-gen en_US.UTF-8

RUN mkdir /_install

## S6 Overlay
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_VER}/s6-overlay-amd64.tar.gz /_install
RUN tar xzf /_install/s6-overlay-amd64.tar.gz -C / --exclude="./bin" && \
  tar xzf /_install/s6-overlay-amd64.tar.gz -C /usr ./bin

# ----------------------------------------------------------
# Essential Packages

RUN dpkg --add-architecture i386 && \
  apt-get update && apt-get upgrade -y && apt-get install --no-install-recommends -y \
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
  curl \
  dbus-user-session \
  dbus-x11 \
  fakeroot \
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
  git \
  gzip \
  htop \
  i965-va-driver-shaders \
  i965-va-driver-shaders:i386 \
  intel-media-va-driver-non-free \
  intel-media-va-driver-non-free:i386 \
  jq \
  kmod \
  lame \
  less \
  libavcodec-extra \
  libc6-dev \
  libc6:i386 \
  libdbus-c++-1-0v5 \
  libegl1 \
  libegl1-mesa-dev \
  libegl1-mesa-dev:i386 \
  libegl1:i386 \
  libelf-dev \
  libgl1 \
  libgl1-mesa-dev \
  libgl1-mesa-dev:i386 \
  libgl1:i386 \
  libgles2 \
  libgles2-mesa-dev \
  libgles2-mesa-dev:i386 \
  libgles2:i386 \
  libglu1 \
  libglu1:i386 \
  libglvnd-dev \
  libglvnd-dev:i386 \
  libglvnd0 \
  libglvnd0:i386 \
  libglx0 \
  libglx0:i386 \
  libpci3 \
  libpulse0 \
  libsm6 \
  libsm6:i386 \
  libva2 \
  libva2:i386 \
  libvulkan-dev \
  libvulkan-dev:i386 \
  libx11-6 \
  libx11-6:i386 \
  libxau6 \
  libxau6:i386 \
  libxcb1 \
  libxcb1:i386 \
  libxdmcp6 \
  libxdmcp6:i386 \
  libxext6 \
  libxext6:i386 \
  libxrandr-dev \
  libxtst6 \
  libxtst6:i386 \
  libxv1 \
  libxv1:i386 \
  make \
  mesa-utils \
  mesa-utils-extra \
  mesa-vulkan-drivers \
  mesa-vulkan-drivers:i386 \
  mlocate \
  nano \
  net-tools \
  packagekit-tools \
  pkg-config \
  pulseaudio \
  python3 \
  python3-cups \
  python3-numpy \
  rar \
  software-properties-common \
  ssl-cert \
  supervisor \
  unar \
  unrar \
  unzip \
  va-driver-all \
  va-driver-all:i386 \
  vainfo \
  vdpau-driver-all \
  vdpau-driver-all:i386 \
  vdpauinfo \
  vim \
  vulkan-tools \
  wget \
  x11-apps \
  x11-utils \
  x11-xkb-utils \
  x11-xserver-utils \
  xauth \
  xbitmaps \
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
  zip \
  zstd

# ----------------------------------------------------------
# KDE Desktop Plasma

ENV XDG_CURRENT_DESKTOP KDE
# Fix `QStandardPaths: XDG_RUNTIME_DIR not set, defaulting to '/tmp/runtime-ubuntu'` error
ENV XDG_RUNTIME_DIR=/tmp/runtime-root

RUN apt-get install -y \
  adwaita-icon-theme-full \
  appmenu-gtk3-module \
  ark \
  aspell \
  aspell-en \
  breeze \
  breeze-cursor-theme \
  breeze-gtk-theme \
  breeze-icon-theme \
  dbus-x11 \
  debconf-kde-helper \
  desktop-file-utils \
  dolphin \
  dolphin-plugins \
  enchant-2 \
  fcitx \
  fcitx-frontend-gtk2 \
  fcitx-frontend-gtk3 \
  fcitx-frontend-qt5 \
  fcitx-module-dbus \
  fcitx-module-kimpanel \
  fcitx-module-lua \
  fcitx-module-x11 \
  fcitx-tools \
  filelight \
  firefox \
  frameworkintegration \
  gwenview \
  haveged \
  hunspell \
  im-config \
  kate \
  kcalc \
  kcharselect \
  kde-config-fcitx \
  kde-config-gtk-style \
  kde-config-gtk-style-preview \
  kde-plasma-desktop \
  kde-spectacle \
  kdeadmin \
  kdeconnect \
  kdegraphics-thumbnailers \
  kdf \
  kdialog \
  kget \
  kimageformat-plugins \
  kinfocenter \
  kio \
  kio-extras \
  kmag \
  kmenuedit \
  kmix \
  kmousetool \
  kmouth \
  ksshaskpass \
  ktimer \
  kwayland-integration \
  kwin-addons \
  kwin-x11 \
  libdbusmenu-glib4 \
  libdbusmenu-gtk3-4 \
  libgail-common \
  libgdk-pixbuf2.0-bin \
  libgtk-3-bin \
  libgtk2.0-bin \
  libkf5baloowidgets-bin \
  libkf5dbusaddons-bin \
  libkf5iconthemes-bin \
  libkf5kdelibs4support5-bin \
  libkf5khtml-bin \
  libkf5parts-plugins \
  libqt5multimedia5-plugins \
  librsvg2-common \
  media-player-info \
  okular \
  okular-extra-backends \
  partitionmanager \
  pavucontrol-qt \
  plasma-browser-integration \
  plasma-calendar-addons \
  plasma-dataengines-addons \
  plasma-discover \
  plasma-integration \
  plasma-runners-addons \
  plasma-widgets-addons \
  policykit-desktop-privileges \
  polkit-kde-agent-1 \
  print-manager \
  qapt-deb-installer \
  qml-module-org-kde-qqc2desktopstyle \
  qml-module-org-kde-runnermodel \
  qml-module-qtgraphicaleffects \
  qml-module-qtquick-xmllistmodel \
  qt5-gtk-platformtheme \
  qt5-image-formats-plugins \
  qt5-style-plugins \
  qtspeech5-flite-plugin \
  qtvirtualkeyboard-plugin \
  software-properties-qt \
  sonnet-plugins \
  sweeper \
  systemd \
  systemsettings \
  transmission-qt \
  ubuntu-drivers-common \
  vlc \
  vlc-l10n \
  vlc-plugin-access-extra \
  vlc-plugin-notify \
  vlc-plugin-samba \
  vlc-plugin-skins2 \
  vlc-plugin-video-splitter \
  vlc-plugin-visualization \
  xcvt \
  xdg-desktop-portal-kde \
  xdg-user-dirs

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
# Utilities

## Other Applications
RUN apt install -y dolphin konsole

# Firefox
RUN mkdir -pm755 /etc/apt/preferences.d && \
  echo "Package: firefox*\n\
  Pin: version 1:1snap*\n\
  Pin-Priority: -1" > /etc/apt/preferences.d/firefox-nosnap && \
  mkdir -pm755 /etc/apt/trusted.gpg.d && \
  curl -fsSL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x0AB215679C571D1C8325275B9BDB3D89CE49EC21" | gpg --dearmor -o /etc/apt/trusted.gpg.d/mozillateam-ubuntu-ppa.gpg && \
  mkdir -pm755 /etc/apt/sources.list.d && \
  echo "deb https://ppa.launchpadcontent.net/mozillateam/ppa/ubuntu $(grep UBUNTU_CODENAME= /etc/os-release | cut -d= -f2) main" > "/etc/apt/sources.list.d/mozillateam-ubuntu-ppa-$(grep UBUNTU_CODENAME= /etc/os-release | cut -d= -f2).list" && \
  apt-get update && apt-get install --no-install-recommends -y firefox
# Ensure Firefox is the default web browser
RUN update-alternatives --set x-www-browser /usr/bin/firefox

# ----------------------------------------------------------
# VNC Server

RUN apt install -y tigervnc-standalone-server tigervnc-xorg-extension
ENV DISPLAY=:0 \
  VNC_SCREEN_SIZE=1920x1080
EXPOSE 5900

# ----------------------------------------------------------
# OS User

ARG USER_NAME=ubuntu

ENV PGID=0
ENV PUID=0
ENV USER_NAME=${USER_NAME}
ENV USER_PASSWORD=password

ENV HOME=/home/${USER_NAME}

RUN apt-get update && apt-get install --no-install-recommends -y \
  sudo \
  tzdata && \
  rm -rf /var/lib/apt/lists/* && \
  groupadd -g 1000 ubuntu && \
  useradd -ms /bin/bash ubuntu -u 1000 -g 1000 && \
  usermod -a -G adm,audio,cdrom,dialout,dip,fax,floppy,input,lp,lpadmin,plugdev,pulse-access,ssl-cert,sudo,tape,tty,video,voice ubuntu && \
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

# USER "${USER_NAME}"
WORKDIR ${HOME}
# CMD /bin/bash
# ENV USER=${USER_NAME}

# ## USER
# ENV PGID=0 \
#   PUID=0 \
#   ROOT_PASSWORD=password \
#   HOME=/home/ubuntu
# RUN useradd -U -u 6006 -d "$HOME" ubuntu && \
#   usermod -G users ubuntu
# WORKDIR /

# RUN yes | unminimize
COPY ./kde/_root /
COPY ./kde/root /




# RUN sudo apt install -y falkon

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

RUN sudo apt autoremove -y && \
  sudo apt clean && \
  sudo rm -r /_install

COPY ./entrypoint.sh /home/ubuntu/entrypoint.sh

ENTRYPOINT ["/home/ubuntu/entrypoint.sh"]
