#!/bin/bash

set -e

function usage() {
  echo "usage: $0 [tee]"
  echo "tee: either 'sancus' or 'sgx' (optional)"
}

function install_sancus() {
  # install reactive-uart2ip
  git submodule update --init --recursive sancus/reactive-uart2ip
  pip3 install sancus/reactive-uart2ip
}

function install_sgx() {
  # install rust-sgx-gen
  git submodule update --init --recursive sgx/rust-sgx-gen
  pip3 install sgx/rust-sgx-gen

  # install apps
  git submodule update --init --recursive sgx/rust-sgx-apps
  ./sgx/rust-sgx-apps/install_all.sh
}

DIR=$(dirname "$0")

# go to the root folder
cd $DIR/..


# install reactive-net
git submodule update --init --recursive libs/reactive-net
pip3 install libs/reactive-net


# Install Sancus / SGX modules and apps based on the argument provided
if [ $# -eq 0 ]; then
  # install all
  install_sancus
  install_sgx
else
  if [ $1 == "sancus" ]; then
    # install only sancus apps
    install_sancus
  elif [ $1 == "sgx" ]; then
    # install only sgx apps
    install_sgx
  else
    usage
    exit
  fi
fi


# install reactive-tools
git submodule update --init --recursive reactive-tools
pip3 install reactive-tools/
