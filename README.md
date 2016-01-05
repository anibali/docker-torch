### Torch Docker image

Ubuntu 14.04 + Torch + CUDA (optional)

#### Requirements

In order to use this image you must have Docker Engine installed. Instructions
for setting up Docker Engine are
[available on the Docker website](https://docs.docker.com/engine/installation/).

#### Building

This image can be built on top of multiple different base images derived from
Ubuntu 14.04. Which base you choose depends on whether you have an NVIDIA
graphics card which supports CUDA and you want to use GPU acceleration or not.

If you are running Ubuntu, you can install proprietary NVIDIA drivers
[from the PPA](https://launchpad.net/~graphics-drivers/+archive/ubuntu/ppa)
and CUDA [from the NVIDIA website](https://developer.nvidia.com/cuda-downloads).
These are only required if you want to use GPU acceleration

If you are running Windows or OSX then, then you will find it
difficult/impossible to use GPU acceleration due to the fact that containers run
in a virtual machine. Use the image without CUDA on those platforms.

##### With CUDA

Firstly ensure that you have a supported NVIDIA graphics card with the
appropriate drivers and CUDA libraries installed.

Build the image using the following command:

```sh
docker build -t torch cuda-7.5
```

You will also need to download the `nvidia-docker` wrapper script to start the
container later. This can be found at
[NVIDIA/nvidia-docker](https://github.com/NVIDIA/nvidia-docker) and should
be made executable and added to your system path.

##### Without CUDA

Build the image using the following command:

```sh
docker build -t torch no-cuda
```

#### Usage

##### iTorch notebook

```sh
GPU=0 nvidia-docker run --rm -it -v /path/to/notebook:/root/notebook \
  -e JUPYTER_PASSWORD=my_password -p 8888:8888 torch
```

If not using the CUDA base, this command should be modified slightly to use
the `docker` command directly instead of the wrapper script:

```sh
docker run ...
```

Replace `/path/to/notebook` with a directory on the host machine that you would
like to store your work in.

Point your web browser to [localhost:8888](http://localhost:8888) to start using
the iTorch notebook.
