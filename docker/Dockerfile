FROM ubuntu:20.04

RUN apt-get -qqy update \
  && DEBIAN_FRONTEND=noninteractive apt-get -qqy --no-install-recommends install \
    build-essential \
    ca-certificates \
    clang-8 \
    dirmngr \
    g++ \
    git \
    gpg-agent \
    libegl1 \
    libgl1 \
    libglvnd0 \
    libglx0 \
    libgtk-3-dev \
    libomp-dev \
    libpcl-dev \
    libssl-dev \
    libx11-6 \
    libxext6 \
    ninja-build \
    rsync \
    runit \
    software-properties-common \
    unzip \
    wget \
    xdg-user-dirs \
  && apt-get -qqy clean \
  && rm -rf /var/lib/apt/lists/*

ENV PATH "/usr/lib/llvm-8/bin:${PATH}"

RUN update-ca-certificates

RUN wget https://github.com/Kitware/CMake/releases/download/v3.22.1/cmake-3.22.1.tar.gz \
  && tar xzvf cmake-3.22.1.tar.gz \
  && cd cmake-3.22.1 \
  && ./bootstrap \
  && make \
  && make install \
  && cd - && rm -rf ./cmake-3.22.1

RUN git clone https://github.com/carla-simulator/carla.git \
  && cd carla \
  && git checkout 0.9.11 \
  && make setup \
  && make LibCarla

RUN apt-get -qqy update && \
    add-apt-repository ppa:deadsnakes/ppa -y && \
    apt-get -qqy install python3.8 python3-pip
RUN ln -s $(which python3) /usr/local/bin/python

COPY requirements.txt .
RUN python -m pip install --upgrade pip
RUN python -m pip install -r requirements.txt

ENV GDK_SYNCHRONIZE true
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES graphics,utility,compute

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 1AF1527DE64CB8D9 \
  && add-apt-repository "deb [arch=amd64] http://dist.carla.org/carla $(lsb_release -sc) main" \
  && apt-get -qqy install carla-simulator=0.9.11

RUN wget https://carla-releases.s3.eu-west-3.amazonaws.com/Linux/AdditionalMaps_0.9.11.tar.gz \
  && mv AdditionalMaps_0.9.11.tar.gz /opt/carla-simulator/ \
  && cd /opt/carla-simulator \
  && ./ImportAssets.sh

RUN wget https://gitlab.com/libeigen/eigen/-/archive/3.4.0/eigen-3.4.0.tar.gz \
  && mv ./eigen-3.4.0.tar.gz /usr/local/lib/ \
  && cd /usr/local/lib \
  && tar xzvf ./eigen-3.4.0.tar.gz \
  && rm ./eigen-3.4.0.tar.gz

RUN groupadd -r student && useradd -r -g student student

WORKDIR /workspace
ENTRYPOINT ["bash"]
