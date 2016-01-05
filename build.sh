#!/bin/sh

# Prepare build dir
mkdir -p /data/pony

# Build PCRE2
cd /data/pony
git clone https://github.com/luvit/pcre2 \
cd /data/pony/pcre2
touch NEWS AUTHORS
autoreconf -i
./configure
make
make install

# Build LLVM 3.6
cd /data/pony
wget http://llvm.org/releases/3.6.2/clang+llvm-3.6.2-armv7a-linux-gnueabihf.tar.xz
unxz clang+llvm-3.6.2-armv7a-linux-gnueabihf.tar.xz
tar xvf clang+llvm-3.6.2-armv7a-linux-gnueabihf.tar
export LD_LIBRARY_PATH="/data/pony/clang+llvm-3.6.2-armv7a-linux-gnueabihf/lib"
export LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH"
export PATH="/data/pony/clang+llvm-3.6.2-armv7a-linux-gnueabihf/bin:$PATH"

# And finally Pony itself:
cd /data/pony
git clone http://github.com/CausalityLtd/ponyc
cd ponyc
make -j4
make test
make install

# Cleanup
#rm -rf /data/pony
