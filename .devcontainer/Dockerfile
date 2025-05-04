# SPDX-License-Identifier: MIT OR GPL-3.0-or-later

# 開発環境としてCentOS Stream 9を利用する。
# 本当はBlenderのLinux版の公式ビルド用のOSであるRocky Linux 8を利用するのが望ましいが、
# 開発環境にするには付属パッケージが古すぎると感じるので同系統の新しいOSを選択した。
# https://projects.blender.org/blender/blender-developer-docs/src/commit/b7d7d239c97443bec2a22ea3ae4b8ad6c585eef3/docs/handbook/release_process/build/rocky_8.md#
FROM quay.io/centos/centos:stream9

# https://github.com/hadolint/hadolint/wiki/DL4006
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN <<'INSTALL_PACKAGES'
  set -eu
  dnf update -y
  dnf install-n -y dnf-plugins-core
  dnf config-manager --set-enabled crb
  dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo
  dnf install-n -y epel-release
  dnf update -y
  dnf install-n \
    ImageMagick \
    ShellCheck \
    advancecomp \
    blender \
    curl \
    diffutils \
    file \
    gh \
    git \
    git-lfs \
    less \
    libSM \
    libXi \
    libxkbcommon \
    moreutils \
    nkf \
    openssh-clients \
    patchutils \
    pv \
    python3-dulwich \
    python3-numpy \
    python3-tqdm \
    python3-typing-extensions \
    ruby \
    rubygems \
    sudo \
    unzip \
    vim-enhanced \
    xz \
    zopfli \
    -y --setopt=install_weak_deps=False --allowerasing

  if [ "$(uname -m)" != "x86_64" ]; then
    dnf install-n \
      OpenImageIO-devel \
      automake \
      autoconf \
      bison \
      boost-devel \
      bzip2-devel \
      cmake \
      dbus-devel \
      fftw-devel \
      freetype \
      gcc-c++ \
      gcc \
      glfw-devel \
      libSM \
      libX11-devel \
      libXcursor-devel \
      libXext \
      libXi-devel \
      libXinerama-devel \
      libXrandr-devel \
      libXtst-devel \
      libXxf86vm-devel \
      libdecor-devel \
      libepoxy-devel \
      libffi-devel \
      libjpeg-turbo-devel \
      libtool \
      libxkbcommon-devel \
      libxml2-devel \
      libzstd-devel \
      make \
      mesa-libEGL-devel \
      mesa-libGL-devel \
      ncurses-devel \
      ninja-build \
      openCOLLADA-devel \
      openssl-devel \
      openvdb-devel \
      openxr-devel \
      patchelf \
      pugixml-devel \
      readline-devel \
      sqlite-devel \
      subversion \
      tbb-devel \
      tk-devel \
      wayland-devel \
      wayland-protocols-devel \
      yasm \
      zlib-devel \
      -y --setopt=install_weak_deps=False --allowerasing
  fi
  dnf clean all
INSTALL_PACKAGES

RUN <<'SETUP_USER_DEVELOPER'
  set -eu
  useradd --create-home --user-group --shell /bin/bash developer
  usermod --append --groups wheel developer
  mkdir -p /workspace
  chown developer:developer /workspace
SETUP_USER_DEVELOPER

USER developer
WORKDIR /home/developer

# "postCreateCommand" や "postStartCommand" でも使える環境変数を設定する。
# できれば "remoteEnv" で設定したいが、現在のJetBrains製品だと反映されないのでここで設定
ENV BLENDER_VRM_LOGGING_LEVEL_DEBUG=yes
ENV PATH=/home/developer/.cargo/bin:/home/developer/.local/bin:$PATH
ENV UV_LINK_MODE=copy

# JetBrains製品は自動で `~/.cache` フォルダを作成するが、それだとフォルダの権限がroot:rootになる。
# poetryなどがエラーになるため、あらかじめ作っておく。
RUN mkdir -p .cache

# https://github.com/denoland/deno/issues/25931#issuecomment-2406073767
RUN curl --fail --show-error --location https://deno.land/install.sh | sh -s -- --yes
# denoは.bashrcの最終行に改行を追加しないので自前で追加する。
RUN echo >>~/.bashrc

RUN curl --fail --show-error --location https://fnm.vercel.app/install | bash
