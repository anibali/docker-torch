### Torch Docker image

Ubuntu 14.04 + Torch + CUDA (optional)

Can be used to:

* Run an iTorch notebook server
* Execute Torch scripts

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

If you are running Windows or OSX then you will find it difficult/impossible to
use GPU acceleration due to the fact that containers run in a virtual machine.
Use the image without CUDA on those platforms.

##### With CUDA

Firstly ensure that you have a supported NVIDIA graphics card with the
appropriate drivers and CUDA libraries installed.

Build the image using the following command:

```sh
docker build -t torch cuda-7.5
```

You will also need to install `nvidia-docker`, which we will use to start the
container with GPU access. This can be found at
[NVIDIA/nvidia-docker](https://github.com/NVIDIA/nvidia-docker).

##### Without CUDA

Build the image using the following command:

```sh
docker build -t torch no-cuda
```

#### Usage

##### iTorch notebook

```sh
NV_GPU=0 nvidia-docker run --rm -it --volume=/path/to/notebook:/root/notebook \
  --env=JUPYTER_PASSWORD=my_password --publish=8888:8888 torch
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

##### Running Torch scripts

It is also possible to run Torch programs inside a container using the `th`
command. For example, if you are within a directory containing some Torch
project with entrypoint `my-script.lua`, you could run it with the following
command:

```sh
NV_GPU=0 nvidia-docker run --rm -it --volume=$PWD:/root/notebook torch th my-script.lua
```

The important thing to remember is that the default working directory in the
container is `/root/notebook`. By creating a volume which maps the current
working directory to that location in the image, `th` is able to find and
run our script.

#### Custom iTorch notebook configuration

You can create a `notebook.json` config file to customise the editor. Some of the
options you can change are documented at
https://codemirror.net/doc/manual.html#config.

Let's say that you create the following file at `/path/to/notebook.json`:

```json
{
  "CodeCell": {
    "cm_config": {
      "lineNumbers": false,
      "indentUnit": 2,
      "tabSize": 2,
      "indentWithTabs": false,
      "smartIndent": true
    }
  }
}
```

Then, when running the container, pass the following option to mount the
configuration file into the container:

```sh
--volume=/path/to/notebook.json:/root/.jupyter/nbconfig/notebook.json
```

You should now notice that your notebooks are configured accordingly.
