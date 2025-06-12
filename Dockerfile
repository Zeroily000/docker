FROM nvidia/cuda:12.8.0-cudnn-devel-ubuntu24.04

ENV DEBIAN_FRONTEND=noninteractive

# General tools
RUN apt-get update && apt-get install -y \
    bash-completion \
    python3 \
    gcc-14 \
    g++-14 \
    clang-19 \
    clang-tools-19 \
    cmake \
    make \
    ninja-build \
    gdb \
    lldb

# Setup GUI
RUN apt-get update && apt-get install -y \
    locales \
    libcanberra-gtk3-module \
    mesa-utils \
    x11-apps
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV NO_AT_BRIDGE=1

# Install Bazel 8.1.1
RUN apt-get update && apt-get install -y \
    wget
RUN wget https://github.com/bazelbuild/bazel/releases/download/8.1.1/bazel-8.1.1-linux-x86_64; \
    mv bazel-8.1.1-linux-x86_64 /usr/local/bin/bazel; \
    chmod 777 /usr/local/bin/bazel

# Install Buildifier 8.0.3
RUN apt-get update && apt-get install -y \
    wget
RUN wget https://github.com/bazelbuild/buildtools/releases/download/v8.0.3/buildifier-linux-amd64; \
    mv buildifier-linux-amd64 /usr/local/bin/buildifier; \
    chmod 777 /usr/local/bin/buildifier

# Install OpenCV 4.6.0
RUN apt-get update && apt-get install -y \
    libopencv-dev

# Install OpenGL
RUN apt-get update && apt-get install -y \
    libgl-dev \
    libx11-dev

# Upgrade CMake to 3.30.5
RUN apt-get update && apt-get install -y \
    git \
    libssl-dev
RUN git clone --depth 1 --branch v3.30.5 https://github.com/Kitware/CMake.git cmake-3.30.5; \
    cd cmake-3.30.5; \
    ./bootstrap; \
    make -j`nproc --ignore=2`;\
    make install
RUN rm -rf /cmake-3.30.5

# Create user with sudo privileges
ARG UID=1000
ARG GID=1000
ARG USERNAME=user
RUN groupadd -g ${GID} ${USERNAME}; \
    useradd -m -u ${UID} -g ${GID} -s /bin/bash ${USERNAME}
RUN apt-get update && apt-get install -y \
    sudo
RUN usermod -aG sudo ${USERNAME}; \
    echo "%sudo ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER ${USERNAME}
