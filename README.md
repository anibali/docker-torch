### Torch Docker image

#### Building

Follow the instructions for
[NVIDIA/nvidia-docker](https://github.com/NVIDIA/nvidia-docker) to create
a Cuda devel image which is appropriate for your machine. Make sure that
you name the image "cuda" and base it on ubuntu-14.04.

Now you can build this Docker image.

```sh
docker build -t torch .
```

#### Usage

##### iTorch notebook

```sh
GPU=0 nvidia-docker run --rm -it -v /path/to/notebook:/root/notebook \
  -e JUPYTER_PASSWORD=my_password -p 8888:8888 torch
```

Replace `/path/to/notebook` with a directory on the host machine that you would
like to store your work in.

Point your web browser to [localhost:8888](http://localhost:8888) to start using
the iTorch notebook.
