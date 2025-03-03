FROM nvidia/cuda:12.6.2-cudnn-devel-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive

# General tools
RUN apt-get update && apt-get install -y \
    bash-completion \
    python3 \
    gcc \
    g++ \
    make \
    ninja-build \
    cmake \
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

# Install OpenCV 4.11.0
RUN apt-get update && apt-get install -y \
    git \
    libgtk2.0-dev \
    libcanberra-gtk-module \
    pkg-config
RUN git clone --depth 1 --branch 4.11.0 https://github.com/opencv/opencv.git opencv-4.11.0; \
    git clone --depth 1 --branch 4.11.0 https://github.com/opencv/opencv_contrib.git opencv_contrib-4.11.0; \
    cmake \
        -G Ninja \
        -D WITH_CUDA=ON \
        -D OPENCV_EXTRA_MODULES_PATH=/opencv_contrib-4.11.0/modules \
        -S /opencv-4.11.0 \
        -B /opencv-4.11.0/build; \
    cmake \
        --build /opencv-4.11.0/build \
        -- -j`nproc --ignore=2`; \
    cmake \
        --build /opencv-4.11.0/build \
        --target install
RUN rm -rf /opencv-4.11.0; \
    rm -rf opencv_contrib-4.11.0

# Install Bazel
RUN apt-get update && apt-get install -y \
    wget
RUN wget https://github.com/bazelbuild/bazel/releases/download/8.1.1/bazel-8.1.1-linux-x86_64; \
    mv bazel-8.1.1-linux-x86_64 /usr/local/bin/bazel-8.1.1; \
    ln -s /usr/local/bin/bazel-8.1.1 /usr/local/bin/bazel

# Install Buildifier
RUN apt-get update && apt-get install -y \
    wget
RUN wget https://github.com/bazelbuild/buildtools/releases/download/v8.0.3/buildifier-linux-amd64; \
    mv buildifier-linux-amd64 /usr/local/bin/buildifier-8.0.3; \
    ln -s /usr/local/bin/buildifier-8.0.3 /usr/local/bin/buildifier

# Create user with sudo privileges
RUN apt-get update && apt-get install -y \
    sudo
RUN useradd -ms /bin/bash user; \
    usermod -aG sudo user; \
    echo "%sudo ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER user
