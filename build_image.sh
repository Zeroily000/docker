#!/bin/bash

docker build \
  --platform linux/amd64 \
  --build-arg UID=$(id -u) \
  --build-arg GID=$(id -g) \
  --build-arg USERNAME=$(whoami) \
  -t general:0.2.0 \
  "$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"
