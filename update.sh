#!/bin/bash -e

# Get latest commit hashes for Git repositories used in the image

torch_distro_commit=`git ls-remote -h https://github.com/torch/distro.git master | awk '{ print $1 }'`
torchvid_commit=`git ls-remote -h https://github.com/anibali/torchvid.git master | awk '{ print $1 }'`

# Create Dockerfiles from template

template="Dockerfile.template"

dest="cuda-7.5/Dockerfile"
mkdir -p "$(dirname "$dest")"
( set -x && sed '
  s!{{BASE}}!nvidia/cuda:7.5!g;
  s!{{TORCH_DISTRO_COMMIT}}!'"$torch_distro_commit"'!g;
  s!{{TORCHVID_COMMIT}}!'"$torchvid_commit"'!g;
' "$template" > "$dest" )

dest="no-cuda/Dockerfile"
mkdir -p "$(dirname "$dest")"
( set -x && sed '
  s!{{BASE}}!ubuntu:14.04!g;
  s!{{TORCH_DISTRO_COMMIT}}!'"$torch_distro_commit"'!g;
  s!{{TORCHVID_COMMIT}}!'"$torchvid_commit"'!g;
' "$template" > "$dest" )
