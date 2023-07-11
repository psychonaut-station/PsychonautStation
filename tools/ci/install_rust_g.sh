#!/usr/bin/env bash
set -euo pipefail

source dependencies.sh

sudo dpkg --add-architecture i386 

mkdir libc
sudo wget https://launchpad.net/ubuntu/+source/glibc/2.34-0ubuntu3/+build/22228180/+files/libc6-dev_2.34-0ubuntu3_i386.deb
sudo dpkg -x libc6-dev_2.34-0ubuntu3_i386.deb ~/libc/
sudo wget https://launchpad.net/ubuntu/+source/glibc/2.34-0ubuntu3/+build/22228180/+files/libc6_2.34-0ubuntu3_i386.deb
sudo dpkg -x libc6_2.34-0ubuntu3_i386.deb ~/libc/
export LD_LIBRARY_PATH=~/libc/usr/lib/i386-linux-gnu/${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}

sudo apt-get update || true
sudo apt-get install libgcc-s1:i386 g++-multilib zlib1g-dev:i386 libssl-dev:i386
wget http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.0g-2ubuntu4_i386.deb
# sudo dpkg -i ./libssl1.1_1.1.0g-2ubuntu4_i386.deb

mkdir -p ~/.byond/bin
wget -nv -O ~/.byond/bin/librust_g.so "https://github.com/tgstation/rust-g/releases/download/$RUST_G_VERSION/librust_g.so"
chmod +x ~/.byond/bin/librust_g.so
ldd ~/.byond/bin/librust_g.so
