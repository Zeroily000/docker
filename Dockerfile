FROM nvidia/cuda:12.6.2-cudnn-devel-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive

# General tools
RUN apt-get update && apt-get install -y \
    bash-completion \
    python3 \
    gcc \
    g++ \
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

# Upgrade make to 4.4
RUN apt-get update && apt-get install -y \
    wget
RUN wget https://ftp.wayne.edu/gnu/make/make-4.4.tar.gz; \
    tar -xvzf make-4.4.tar.gz make-4.4; \
    cd make-4.4; \
    ./configure; \
    make --no-print-directory -j`nproc --ignore=2`; \
    make --no-print-directory install
RUN rm -rf make-4.4/

# Upgrade GCC to 14.2
RUN apt-get update && apt-get install -y \
    git \
    libgmp-dev \
    libmpfr-dev \
    libmpc-dev \
    flex
RUN git clone --depth 1 --branch releases/gcc-14.2.0 git://gcc.gnu.org/git/gcc.git gcc-14.2; \
    cd gcc-14.2; mkdir objdir; cd objdir; \
    ../configure --disable-multilib; \
    make --no-print-directory -j`nproc --ignore=2`; \
    make --no-print-directory install
RUN rm -rf gcc-14.2/

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
