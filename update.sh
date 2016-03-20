#!/bin/bash -e

# Get latest commit hashes for Git repositories used in the image

export LATEST_TORCH_DISTRO_COMMIT=`git ls-remote -h https://github.com/torch/distro.git master | awk '{ print $1 }'`
export LATEST_TORCHVID_COMMIT=`git ls-remote -h https://github.com/anibali/torchvid.git master | awk '{ print $1 }'`

# Create Dockerfiles from template

template="Dockerfile.template"
shell_format='$BASE:$LATEST_TORCH_DISTRO_COMMIT:$LATEST_TORCHVID_COMMIT:$CUDA_ONLY_STEPS'

# CUDA-enabled

dest="cuda-7.5/Dockerfile"
mkdir -p "$(dirname "$dest")"
export BASE=nvidia/cuda:7.5

export CUDA_ONLY_STEPS='
# Install CuDNN with Torch bindings
RUN echo "deb http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1404/x86_64 /" > /etc/apt/sources.list.d/nvidia-ml.list

ENV CUDNN_VERSION 4
LABEL com.nvidia.cudnn.version="4"

RUN apt-get update && apt-get install -y --no-install-recommends --force-yes \
            libcudnn4=4.0.7 && \
    rm -rf /var/lib/apt/lists/*
    
RUN luarocks install cudnn
'

envsubst $shell_format < $template > $dest

# No CUDA

dest="no-cuda/Dockerfile"
mkdir -p "$(dirname "$dest")"
export BASE=ubuntu:14.04
export CUDA_ONLY_STEPS=''
envsubst $shell_format < $template > $dest
