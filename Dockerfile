FROM nvidia/cuda:12.8.0-cudnn-devel-ubuntu24.04

ENV DEBIAN_FRONTEND=noninteractive

# General tools
RUN apt-get update && apt-get install -y \
    bash-completion \
    python3 \
    gcc-14 \
    g++-14 \
    cmake \
    make \
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

# Create user with sudo privileges
RUN apt-get update && apt-get install -y \
    sudo
RUN useradd -ms /bin/bash user; \
    usermod -aG sudo user; \
    echo "%sudo ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER user
