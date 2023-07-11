#!/usr/bin/env bash
set -euo pipefail

source dependencies.sh

sudo dpkg --add-architecture i386 
sudo dpkg -x libc6-dev-x32_2.34-0ubuntu3_i386.deb /home/user/libc/
sudo dpkg -x libc6-x32_2.34-0ubuntu3_i386.deb /home/user/libc/
LD_LIBRARY_PATH=/home/user/libc/lib/x86_64-linux-gnu/

sudo apt-get update || true
sudo apt-get install libgcc-s1:i386 g++-multilib zlib1g-dev:i386 libssl-dev:i386
sudo apt install -o APT::Immediate-Configure=false libssl1.1:i386

mkdir -p ~/.byond/bin
wget -nv -O ~/.byond/bin/librust_g.so "https://github.com/tgstation/rust-g/releases/download/$RUST_G_VERSION/librust_g.so"
chmod +x ~/.byond/bin/librust_g.so
ldd ~/.byond/bin/librust_g.so
