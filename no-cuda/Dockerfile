FROM ubuntu:14.04

# Install OpenBLAS
RUN apt-get update \
 && apt-get install -y build-essential git gfortran
RUN git clone https://github.com/xianyi/OpenBLAS.git /tmp/OpenBLAS \
 && cd /tmp/OpenBLAS \
 && [ $(getconf _NPROCESSORS_ONLN) = 1 ] && export USE_OPENMP=0 || export USE_OPENMP=1 \
 && make NO_AFFINITY=1 \
 && make install \
 && rm -rf /tmp/OpenBLAS

# Install Python, Jupyter and build tools
RUN apt-get update \
 && apt-get install -y python3 python3-setuptools python3-dev
RUN easy_install3 pip \
 && pip install 'notebook>=4.1.0' jupyter

# Install Torch
RUN apt-get update \
 && apt-get install -y cmake curl unzip libreadline-dev libjpeg-dev \
    libpng-dev ncurses-dev imagemagick gnuplot gnuplot-x11 libssl-dev \
    libzmq3-dev graphviz
ARG TORCH_DISTRO_COMMIT=4b1fe0f64391a1073abc7603cf54f6c6000707fc
RUN git clone https://github.com/torch/distro.git ~/torch --recursive \
 && cd ~/torch \
 && git checkout "$TORCH_DISTRO_COMMIT" \
 && ./install.sh

# Export environment variables manually
ENV LUA_PATH='/root/.luarocks/share/lua/5.1/?.lua;/root/.luarocks/share/lua/5.1/?/init.lua;/root/torch/install/share/lua/5.1/?.lua;/root/torch/install/share/lua/5.1/?/init.lua;./?.lua;/root/torch/install/share/luajit-2.1.0-alpha/?.lua;/usr/local/share/lua/5.1/?.lua;/usr/local/share/lua/5.1/?/init.lua' \
    LUA_CPATH='/root/.luarocks/lib/lua/5.1/?.so;/root/torch/install/lib/lua/5.1/?.so;./?.so;/usr/local/lib/lua/5.1/?.so;/usr/local/lib/lua/5.1/loadall.so' \
    PATH=/root/torch/install/bin:$PATH \
    LD_LIBRARY_PATH=/root/torch/install/lib:$LD_LIBRARY_PATH \
    DYLD_LIBRARY_PATH=/root/torch/install/lib:$DYLD_LIBRARY_PATH

# Install Moses for utilities
RUN luarocks install moses

# Install CSV parser
RUN luarocks install csv

# Install torch-autograd, rnn and unsup
RUN luarocks install autograd
RUN luarocks install rnn
RUN luarocks install unsup

# Install HTTP client
RUN luarocks install httpclient

# Install FFmpeg and Lua bindings
RUN echo "deb http://ppa.launchpad.net/kirillshkrogalev/ffmpeg-next/ubuntu trusty main" \
    > /etc/apt/sources.list.d/ffmpeg.list \
 && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 8EFE5982
RUN apt-get update \
 && apt-get install -y \
    libavformat-ffmpeg-dev \
    libavcodec-ffmpeg-dev \
    libavutil-ffmpeg-dev \
    libavfilter-ffmpeg-dev \
    ffmpeg \
    pkg-config

ARG TORCHVID_COMMIT=38410a689061508be0a5887ad150ef9c9d6afb47
RUN git clone https://github.com/anibali/torchvid.git /tmp/torchvid \
 && cd /tmp/torchvid \
 && git checkout "$TORCHVID_COMMIT" \
 && luarocks make rockspecs/torchvid-scm-0.rockspec \
 && rm -rf /tmp/torchvid

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set working dir
VOLUME /root/notebook
WORKDIR /root/notebook

# Jupyter config
RUN jupyter notebook --generate-config \
 && echo "\nimport os\nfrom IPython.lib import passwd\npassword = os.environ.get('JUPYTER_PASSWORD')\nif password:\n  c.NotebookApp.password = passwd(password)\n" \
    >> ~/.jupyter/jupyter_notebook_config.py
COPY notebook.json /root/.jupyter/nbconfig/

# Expose Jupyter port
EXPOSE 8888

CMD ["jupyter", "notebook", "--no-browser", "--ip=0.0.0.0"]
