# Pull base image
FROM resin/rpi-raspbian:jessie
MAINTAINER Markus Fix <lispmeister@gmail.com>

ENV PONY_TAG='master'

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

# Build Pony dependencies
RUN mkdir -p /data/pony

# Build PCRE2
WORKDIR /data/pony
RUN git clone https://github.com/luvit/pcre2 /data/pony/pcre2
WORKDIR /data/pony/pcre2
RUN touch NEWS AUTHORS
RUN autoreconf -i
RUN ./configure
RUN make -j4
RUN make install

# Build LLVM 3.6
WORKDIR /data/pony
RUN wget http://llvm.org/releases/3.6.2/clang+llvm-3.6.2-armv7a-linux-gnueabihf.tar.xz
RUN unxz clang+llvm-3.6.2-armv7a-linux-gnueabihf.tar.xz
RUN tar xvf clang+llvm-3.6.2-armv7a-linux-gnueabihf.tar

# checkout pony project
WORKDIR /data/pony
RUN git clone https://github.com/Sendence/ponyc.git
WORKDIR ponyc

# switch to build tag
RUN git checkout $PONY_TAG
RUN git pull

# fix paths
ENV LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH"
ENV LD_LIBRARY_PATH="/data/pony/clang+llvm-3.6.2-armv7a-linux-gnueabihf/lib:$LD_LIBRARY_PATH"
ENV PATH="/data/pony/clang+llvm-3.6.2-armv7a-linux-gnueabihf/bin:$PATH"

# build pony
RUN make -j4
RUN make -j4 test
RUN make install

# cleanup
RUN rm -rf /data/pony

# Define working directory
WORKDIR /data

# Define default command
CMD ["bash"]

