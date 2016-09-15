FROM nvidia/cuda:7.5-cudnn5-devel

# Install dependencies for OpenBLAS, Jupyter, and Torch
RUN apt-get update \
 && apt-get install -y \
    build-essential git gfortran \
    python3 python3-setuptools python3-dev \
    cmake curl wget unzip libreadline-dev libjpeg-dev libpng-dev ncurses-dev \
    imagemagick gnuplot gnuplot-x11 libssl-dev libzmq3-dev graphviz

# Install OpenBLAS
RUN git clone https://github.com/xianyi/OpenBLAS.git /tmp/OpenBLAS \
 && cd /tmp/OpenBLAS \
 && [ $(getconf _NPROCESSORS_ONLN) = 1 ] && export USE_OPENMP=0 || export USE_OPENMP=1 \
 && make -j $(getconf _NPROCESSORS_ONLN) NO_AFFINITY=1 \
 && make install \
 && rm -rf /tmp/OpenBLAS

# Install Jupyter
RUN easy_install3 pip \
 && pip install 'notebook==4.2.1' jupyter

# Install Torch
ARG TORCH_DISTRO_COMMIT=ed547376d552346afc69a937c6b36cf9ea9d1135
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

# Install HDF5 and Lua bindings
RUN apt-get update \
 && apt-get install -y libhdf5-dev hdf5-tools
ARG TORCH_HDF5_COMMIT=639bb4e62417ac392bf31a53cdd495d19337642b
RUN git clone https://github.com/deepmind/torch-hdf5.git /tmp/torch-hdf5 \
 && cd /tmp/torch-hdf5 \
 && git checkout "$TORCH_HDF5_COMMIT" \
 && luarocks make hdf5-0-0.rockspec LIBHDF5_LIBDIR="/usr/lib/x86_64-linux-gnu/" \
 && rm -rf /tmp/torch-hdf5

# Install Moses for utilities
RUN luarocks install moses

# Install JSON parser
RUN luarocks install lua-cjson

# Install XML parser
RUN luarocks install luaxpath

# Install CSV parser
RUN luarocks install csv

# Install automatic differentiation library
RUN luarocks install autograd

# Install recurrent neural network modules
RUN luarocks install rnn

# Install unsupervised learning modules (includes PCA)
RUN luarocks install unsup

# Install HTTP client
RUN luarocks install httpclient

# Install Lua POSIX bindings
RUN unset LIBRARY_PATH && luarocks install luaposix

# Install random number generator which allows multiple RNG instances
RUN luarocks install lrandom

# Install iTorch
RUN luarocks install itorch

# Install helpers for loading datasets
RUN luarocks install dataload

# Install GraphicsMagick and Lua bindings
RUN apt-get update && apt-get install -y graphicsmagick libgraphicsmagick1-dev
RUN luarocks install graphicsmagick

# Install neural network analysis library
RUN luarocks install optnet

# Install GTK libraries
RUN apt-get update && apt-get install -y libgtk2.0-dev libcanberra-gtk-module

# Install OpenCV and Lua bindings
RUN cd /tmp \
 && wget https://github.com/Itseez/opencv/archive/3.1.0.zip \
 && unzip 3.1.0.zip \
 && mkdir opencv-3.1.0/build \
 && cd opencv-3.1.0/build \
 && cmake -D WITH_CUDA=off -D WITH_OPENCL=off -D BUILD_SHARED_LIBS=off \
      -D CMAKE_CXX_FLAGS=-fPIC -D WITH_QT=off -D WITH_VTK=off -D WITH_GTK=on \
      -D WITH_OPENGL=off -D CMAKE_BUILD_TYPE=RELEASE \
      -D CMAKE_INSTALL_PREFIX=/usr/local .. \
 && make -j $(getconf _NPROCESSORS_ONLN) \
 && make install \
 && rm -rf /tmp/3.1.0.zip /tmp/opencv-3.1.0
RUN luarocks install cv

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
ARG TORCHVID_COMMIT=bba69501c56bd0718d0e977aa24e702b5a44db71
RUN git clone https://github.com/anibali/torchvid.git /tmp/torchvid \
 && cd /tmp/torchvid \
 && git checkout "$TORCHVID_COMMIT" \
 && luarocks make rockspecs/torchvid-scm-0.rockspec \
 && rm -rf /tmp/torchvid

# Install Lua web server
RUN luarocks install lzlib ZLIB_LIBDIR=/lib/x86_64-linux-gnu
RUN luarocks install pegasus

# Install Base64 library
RUN luarocks install lbase64

# Install remote debugger for Lua
RUN luarocks install https://gist.githubusercontent.com/anibali/d8a54118680ec0c300680aa12cb25e9d/raw/34917d844a19a44f58c720f5e2563e7baef23029/mobdebug-scm-1.rockspec

# Install weight initialisation helper
RUN luarocks install nninit

# Install Torchnet framework
RUN luarocks install torchnet

# Install Spatial Transformer Network library
RUN luarocks install https://raw.githubusercontent.com/qassemoquab/stnbhwd/master/stnbhwd-scm-1.rockspec

# Install Stitch for executing and rendering markdown files with code in them
RUN cd /tmp \
 && pip install typing \
 && wget https://github.com/jgm/pandoc/releases/download/1.17.2/pandoc-1.17.2-1-amd64.deb \
 && dpkg -i pandoc-1.17.2-1-amd64.deb \
 && git clone https://github.com/pystitch/stitch.git \
 && cd stitch \
 && python3 setup.py install \
 && rm -rf /tmp/stitch
ENV LC_ALL=C.UTF-8

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set working dir
RUN mkdir /root/notebook
WORKDIR /root/notebook

# Jupyter config
RUN jupyter notebook --generate-config \
 && echo "\nimport os\nfrom IPython.lib import passwd\npassword = os.environ.get('JUPYTER_PASSWORD')\nif password:\n  c.NotebookApp.password = passwd(password)\n" \
    >> ~/.jupyter/jupyter_notebook_config.py
COPY notebook.json /root/.jupyter/nbconfig/

# Expose Jupyter port
EXPOSE 8888


# Install CuDNN with Torch bindings
RUN luarocks install https://raw.githubusercontent.com/soumith/cudnn.torch/R5/cudnn-scm-1.rockspec


CMD ["jupyter", "notebook", "--no-browser", "--ip=0.0.0.0"]
