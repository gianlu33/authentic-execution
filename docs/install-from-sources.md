# Install the Authentic Execution framework from sources

We provide instructions about how to install the Authentic Execution framework from sources. For each section, we specify which architectures need those dependencies - you can skip some sections if you don't need certain architectures.

For building the Docker images we wrote some scripts to install all of the components below, you might as well use them to automate this process. You can find the scripts in [this repository](https://github.com/gianlu33/reactive-tools-docker).

## Dependencies

### [SGX, native] Rust

The Rust programming language is used for developing the SGX and native modules and event manager. We recommend to install Rust using [rustup](https://www.rust-lang.org/tools/install).

### [SGX] Fortanix EDP

Fortanix EDP is a framework to build and run SGX applications written in Rust. The installation guide can be found [here](https://edp.fortanix.com/docs/installation/guide/). In the same website you can find some documentation about how EDP works.

**Note**: Clearly, your machine needs to support SGX to use Fortanix EDP. Most of the recent Intel processors support SGX (more info [here](https://www.intel.com/content/www/us/en/support/articles/000028173/processors.html) and [here](https://github.com/ayeks/SGX-hardware)), but you might need to enable it in the BIOS settings. Fortanix EDP is required also on the deployer's side to build SGX modules and for the Remote Attestation process, even though the nodes where the modules will run are located on another machine.

### [Sancus] Sancus toolchain

The Sancus toolchain is required to build Sancus modules. The main [Sancus repository](https://github.com/sancus-tee/sancus-main) contains instructions to automatically install all the dependencies and the toolchain.

**Note**: as pointed out in the README file in that repository, you might want to override the default security level and the Sancus key. The former specifies whether you want to use 64-bit or 128-bit encryption, while the latter defines the node key of the Sancus boards. For the demo in this repository, we used 128 bits of security and the default key `deadbeefcafebabec0defeeddefec8ed`.

### [all] Python 3 and pip

Python 3 was used to write the deployment tool of our work. We recommend Python 3.6 or above, as previous versions have not been tested.

In the most recent Linux distributions, Python 3 is already installed. Check with `python --version` or `python3 --version` which version you have. Otherwise, here you can find a [tutorial](https://docs.python-guide.org/starting/install3/linux/) to install it.

## Authentic Execution Framework

### [SGX, native] Event Manager, remote attestation apps

The Event Manager (EM) is the **untrusted** application that manages all the events that are exchanged between modules, and between a module and the deployer. It is also responsible of the loading process of the modules on the corresponding node.

The Remote Attestation process for SGX requires two apps, called `ra_sp` and `ra_client` that communicate with the SGX modules and handle all the steps involved in the process.

**Installation**

- Clone the [repository](https://github.com/gianlu33/rust-sgx-apps)
- Deployer (SGX & native): `make install`
- Deployer (only native): `make install_native` - this will not install `ra_sp` and `ra_client`, as you don't need them if you don't have SGX modules
- Nodes: `cargo install --debug --path event_manager` - this will only install the EM, the only application needed on the nodes. If a node is on the same machine as the deployer, you can skip this step, as the EM will be installed anyway with the previous commands

### [Sancus] Patched versions of sancus-compiler and sancus-support

We made some changes to the `sancus-compiler` and `sancus-support` repositories, but they haven't been pushed to the main repositories yet. For this reason, the previous installation of the Sancus toolchain is not complete.

The repositories can be found here: [sancus-compiler](https://github.com/gianlu33/sancus-compiler), [sancus-support](https://github.com/gianlu33/sancus-support)

**Installation** (the process is the same for each repository)

- Clone the repository
- Create and enter the `build` directory: `mkdir build && cd build`
- Run cmake: `cmake .. -DSECURITY=<security> -DMASTER_KEY=<key>`
  - `<security>` and `<key>` should be the same you chose when you installed the Sancus toolchain above
- Install: `make && sudo make install`

### [SGX, native] rust-sgx-gen

`rust-sgx-gen` is the code generator for SGX and native modules. It is a python module used by `reactive-tools`.

**Installation**

- Clone the [repository](https://github.com/gianlu33/rust-sgx-gen)
- Install with pip: `pip install .` (from the root directory of the repository)

### [all] reactive-net

`reactive-net` is a python module that contains utilities to send/receive events. It is used by both `reactive-uart2ip` and `reactive-tools`, therefore it is a required module.

**Installation**

- Clone the [repository](https://github.com/gianlu33/reactive-net)
- Install with pip: `pip install .` (from the root directory of the repository)

### [Sancus] reactive-uart2ip

`reactive-uart2ip` is a python application used to communicate with a Sancus board over the UART interface, using a TCP/IP stack. Every communication (event) sent by the deployer or other nodes is then intercepted by this application, the packet converted and sent to the UART interface. The opposite happens when the Sancus node wants to send events to others.

**Installation**

- Clone the [repository](https://github.com/gianlu33/reactive-uart2ip)
- Install with pip: `pip install .` (from the root directory of the repository)

### [all] reactive-tools

`reactive-tools` is the python module used for building, deploying and interacting with the distributed application we want to run.

 **Installation**

- Clone the [repository](https://github.com/gianlu33/reactive-tools)
- Install with pip: `pip install .` (from the root directory of the repository)
