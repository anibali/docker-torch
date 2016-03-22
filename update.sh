#!/bin/bash -e

# Get latest commit hashes for Git repositories used in the image

export LATEST_TORCH_DISTRO_COMMIT=`git ls-remote -h https://github.com/torch/distro.git master | awk '{ print $1 }'`
export LATEST_TORCHVID_COMMIT=`git ls-remote -h https://github.com/anibali/torchvid.git master | awk '{ print $1 }'`
export LATEST_TORCH_HDF5_COMMIT=`git ls-remote -h https://github.com/deepmind/torch-hdf5.git master | awk '{ print $1 }'`

# Create Dockerfiles from template

template="Dockerfile.template"
shell_format='$BASE:$LATEST_TORCH_DISTRO_COMMIT:$LATEST_TORCHVID_COMMIT:$LATEST_TORCH_HDF5_COMMIT:$CUDA_ONLY_STEPS'

# CUDA-enabled

dest="cuda-7.5/Dockerfile"
mkdir -p "$(dirname "$dest")"
export BASE=nvidia/cuda:7.5

export CUDA_ONLY_STEPS='
# Install CuDNN with Torch bindings
COPY libcudnn.so.4 /lib/libcudnn.so.4
RUN luarocks install cudnn
'

envsubst $shell_format < $template > $dest

# No CUDA

dest="no-cuda/Dockerfile"
mkdir -p "$(dirname "$dest")"
export BASE=ubuntu:14.04
export CUDA_ONLY_STEPS=''
envsubst $shell_format < $template > $dest
