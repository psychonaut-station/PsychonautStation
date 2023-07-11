#!/usr/bin/env bash
set -euo pipefail

source dependencies.sh

sudo dpkg --add-architecture i386 

mkdir -p ~/tmp/glibc
cd ~/tmp/glibc
sudo apt-get install gawk bison -y
wget -c https://ftp.gnu.org/gnu/glibc/glibc-2.34.tar.gz
tar -zxvf glibc-2.34.tar.gz && cd glibc-2.34
mkdir glibc-build && cd glibc-build
../configure --prefix=/usr --disable-profile --enable-add-ons --with-headers=/usr/include
make 
sudo make install

sudo apt-get update || true
sudo apt-get install libgcc-s1:i386 g++-multilib zlib1g-dev:i386 libssl-dev:i386
sudo apt install -o APT::Immediate-Configure=false libssl1.1:i386

mkdir -p ~/.byond/bin
wget -nv -O ~/.byond/bin/librust_g.so "https://github.com/tgstation/rust-g/releases/download/$RUST_G_VERSION/librust_g.so"
chmod +x ~/.byond/bin/librust_g.so
ldd ~/.byond/bin/librust_g.so
