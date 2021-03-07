#FROM ubuntu:18.04
#FROM nvidia/cuda:9.0-base-ubuntu16.04
FROM tensorflow/tensorflow:1.9.0-devel-gpu

# Install dependencies.
# g++ (v. 5.4) does not work: https://github.com/tensorflow/tensorflow/issues/13308
RUN apt-get update && apt-get install -y \
    curl \
    zip \
    unzip \
    software-properties-common \
    pkg-config \
    g++-4.8 \
    zlib1g-dev \
    python \
    lua5.1 \
    liblua5.1-0-dev \
    libffi-dev \
    gettext \
    freeglut3 \
    libsdl2-dev \
    libosmesa6-dev \
    libglu1-mesa \
    libglu1-mesa-dev \
    python-dev \
    build-essential \
    git \
    python-setuptools \
    python-pip \
    libjpeg-dev

#######################Jsik option##########################
RUN apt-get install -y \
    vim \
    net-tools \
    openssh-server \
    screen

# Setting
RUN git clone https://github.com/jsikyoon/my_ubuntu_settings --branch indent2 && \
    cd my_ubuntu_settings && \
    ./setup.sh && \
    rm -rf /my_ubuntu_settings
############################################################

# Install bazel
RUN rm -rf /usr/local/bin/bazel && \
    rm -rf /usr/local/lib/bazel && \
    rm -rf /etc/bazel.bazelrc

RUN echo "deb [arch=amd64] http://storage.googleapis.com/bazel-apt stable jdk1.8" | \
    tee /etc/apt/sources.list.d/bazel.list && \
    curl https://bazel.build/bazel-release.pub.gpg | \
    apt-key add - && \
    apt-get update && apt-get install -y bazel=1.0.0

# Install TensorFlow and other dependencies
#RUN pip install numpy==1.13.3 markdown==2.6.8 tensorflow-gpu==1.9.0 dm-sonnet==1.23
RUN pip install dm-sonnet==1.23

# Build and install DeepMind Lab pip package.
# We explicitly set the Numpy path as shown here:
# https://github.com/deepmind/lab/blob/master/docs/users/build.md
RUN NP_INC="$(python -c 'import numpy as np; print(np.get_include())[5:]')" && \
    git clone https://github.com/jsikyoon/lab.git --branch jsik/dm_scalable_agent && \
    cd lab && \
    rm -rf bazel-* && \
    sed -i 's@hdrs = glob(\[@hdrs = glob(["'"$NP_INC"'/\*\*/*.h", @g' python.BUILD && \
    sed -i 's@includes = \[@includes = ["'"$NP_INC"'", @g' python.BUILD && \
    bazel build -c opt python/pip_package:build_pip_package && \
    pip install wheel && \
    ./bazel-bin/python/pip_package/build_pip_package /tmp/dmlab_pkg && \
    pip install /tmp/dmlab_pkg/DeepMind_Lab-1.0-py2-none-any.whl --force-reinstall

# Install dataset (from https://github.com/deepmind/lab/tree/master/data/brady_konkle_oliva2008)
RUN mkdir dataset && \
    cd dataset && \
    pip install Pillow && \
    curl https://bradylab.ucsd.edu/stimuli/ObjectsAll.zip -o ObjectsAll.zip -k && \
    unzip ObjectsAll.zip && \
    cd OBJECTSALL && \
    cp /root/lab/copy_imgs.py . && \
    python copy_imgs.py && \
    rm -rf __MACOSX OBJECTSALL ObjectsAll.zip && \
    echo Dataset directory: && \
    pwd

# Clone.
RUN git clone https://github.com/deepmind/scalable_agent.git
WORKDIR scalable_agent

# Build dynamic batching module.
RUN TF_INC="$(python -c 'import tensorflow as tf; print(tf.sysconfig.get_include())')" && \
    TF_LIB="$(python -c 'import tensorflow as tf; print(tf.sysconfig.get_lib())')" && \
    g++-4.8 -std=c++11 -shared batcher.cc -o batcher.so -fPIC -I $TF_INC -O2 -D_GLIBCXX_USE_CXX11_ABI=0 -L$TF_LIB -ltensorflow_framework

# Run tests.
RUN python py_process_test.py
#RUN python dynamic_batching_test.py
RUN python vtrace_test.py

# Run.
CMD ["sh", "-c", "python experiment.py --total_environment_frames=10000 --dataset_path=../dataset && python experiment.py --mode=test --test_num_episodes=5"]

# Docker commands:
#   docker rm scalable_agent -v
#   docker build -t scalable_agent .
#   docker run --name scalable_agent scalable_agent
