# Pull base image
FROM resin/rpi-raspbian:jessie
MAINTAINER Markus Fix <lispmeister@gmail.com>

# Install build tools
RUN apt-get update
RUN apt-get install -y \
        libssl-dev automake autotools-dev \
        libtool build-essential \
        libncurses5 libncurses5-dev \
        xz-utils \
        git \
        wget \
        ca-certificates \
    --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

# Build Pony
ADD build.sh /usr/local/bin/build
RUN /usr/local/bin/build

# Define working directory
WORKDIR /data

# Define default command
CMD ["bash"]

