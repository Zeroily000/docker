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

# Install Bazel
RUN apt-get update && apt-get install -y \
    wget
RUN wget https://github.com/bazelbuild/bazel/releases/download/8.1.1/bazel-8.1.1-linux-x86_64; \
    mv bazel-8.1.1-linux-x86_64 /usr/local/bin/bazel; \
    chmod 777 /usr/local/bin/bazel

# Install Buildifier
RUN apt-get update && apt-get install -y \
    wget
RUN wget https://github.com/bazelbuild/buildtools/releases/download/v8.0.3/buildifier-linux-amd64; \
    mv buildifier-linux-amd64 /usr/local/bin/buildifier; \
    chmod 777 /usr/local/bin/buildifier

# Install OpenCV 4.11.0
RUN apt-get update && apt-get install -y \
    git \
    python3-numpy \
    libopenjpip-server \
    libopenjpip-dec-server \
    libopenjp2-tools \
    libva-dev \
    libavif-dev \
    libgtk2.0-dev \
    libgtk-3-dev \
    libvtk9-dev \
    libcanberra-gtk-module \
    libgflags-dev \
    libgoogle-glog-dev \
    pkg-config
RUN git clone --depth 1 --branch 4.11.0 https://github.com/opencv/opencv.git opencv-4.11.0; \
    git clone --depth 1 --branch 4.11.0 https://github.com/opencv/opencv_contrib.git opencv_contrib-4.11.0; \
    cmake \
        -D OPENCV_EXTRA_MODULES_PATH=/opencv_contrib-4.11.0/modules \
        -D C_STANDARD=23 \
        -D CMAKE_CXX_STANDARD=23 \
        -D CMAKE_C_COMPILER=/usr/bin/gcc-14 \
        -D CMAKE_CXX_COMPILER=/usr/bin/g++-14 \
        -D WITH_VTK=ON \
        -D WITH_CUDA=ON \
        -D WITH_NVCUVID=OFF \
        -D WITH_NVCUVENC=OFF \
        -D BUILD_JAVA=OFF \
        -D BUILD_TESTS=OFF \
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

# Create user with sudo privileges
RUN apt-get update && apt-get install -y \
    sudo
RUN useradd -ms /bin/bash user; \
    usermod -aG sudo user; \
    echo "%sudo ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER user
