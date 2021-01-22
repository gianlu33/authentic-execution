#!/bin/bash

set -e

function cleanup() {
  sudo rm -rf $tmp_dir
}

# create temp dir
tmp_dir=$(mktemp -d -t XXXXXXXXXX)

trap cleanup EXIT

cd $tmp_dir

### Install Rust ###

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

source $HOME/.cargo/env

### Install Fortanix EDP ###

rustup default nightly

rustup target add x86_64-fortanix-unknown-sgx --toolchain nightly

# SGX driver

echo "deb https://download.fortanix.com/linux/apt xenial main" | sudo tee -a /etc/apt/sources.list.d/fortanix.list >/dev/null

curl -sSL "https://download.fortanix.com/linux/apt/fortanix.gpg" | sudo -E apt-key add -

sudo apt-get update

sudo apt-get install -y intel-sgx-dkms

# AESM service

echo "deb https://download.01.org/intel-sgx/sgx_repo/ubuntu $(lsb_release -cs) main" | sudo tee -a /etc/apt/sources.list.d/intel-sgx.list >/dev/null

curl -sSL "https://download.01.org/intel-sgx/sgx_repo/ubuntu/intel-sgx-deb.key" | sudo -E apt-key add -

sudo apt-get update

sudo apt-get install -y libsgx-enclave-common

# Fortanix EDP utilities

sudo apt-get install -y pkg-config libssl-dev protobuf-compiler

cargo install fortanix-sgx-tools sgxs-tools

# Configure Cargo integration with Fortanix EDP
echo -e '[target.x86_64-fortanix-unknown-sgx]\nrunner = "ftxsgx-runner-cargo"' >> $HOME/.cargo/config
