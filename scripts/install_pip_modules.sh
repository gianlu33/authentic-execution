#!/bin/bash

set -e

function install_sancus() {
  # install reactive-uart2ip
  git submodule update --init --recursive sancus/reactive-uart2ip
  pip3 install sancus/reactive-uart2ip
}

function install_sgx() {
  # install rust-sgx-gen
  git submodule update --init --recursive sgx/rust-sgx-gen
  pip3 install sgx/rust-sgx-gen
}

DIR=$(dirname "$0")

# go to the root folder
cd $DIR/..


# install reactive-net
git submodule update --init --recursive libs/reactive-net
pip3 install libs/reactive-net


install_sancus
install_sgx


# install reactive-tools
git submodule update --init --recursive reactive-tools
pip3 install reactive-tools/
