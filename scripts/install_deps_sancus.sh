#!/bin/bash

set -e

function cleanup() {
  sudo rm -rf $tmp_dir
}

# create temp dir
tmp_dir=$(mktemp -d -t XXXXXXXXXX)

trap cleanup EXIT

cd $tmp_dir


### Install prerequisites ###

sudo add-apt-repository universe
sudo apt-get update
sudo apt-get install -y make


### Install Sancus toolchain ###

git clone https://github.com/sancus-pma/sancus-main.git
cd sancus-main

sudo make install_deps

make

# Install Sancus with 64 bits of security and SANCUS_KEY=deadbeefcafebabe
sudo make install

# add python library to PYTHONPATH
if [[ $PYTHONPATH != */usr/local/share/sancus-compiler/python/lib/* ]]; then
  echo "export PYTHONPATH=\$PYTHONPATH:/usr/local/share/sancus-compiler/python/lib/" >> $HOME/.profile
fi
