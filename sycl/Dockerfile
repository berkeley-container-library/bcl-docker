FROM nvidia/cuda:11.4.3-devel-ubuntu20.04

# Update Container
RUN apt-get update -y
RUN apt-get upgrade -y

# Install GCC 11
RUN DEBIAN_FRONTEND=noninteractive TZ=America/Los_Angeles apt-get -y install tzdata
RUN apt-get install -y software-properties-common
RUN add-apt-repository -y ppa:ubuntu-toolchain-r/test
RUN apt-get update -y
RUN apt-get install -y gcc-11 g++11 libstdc++-11-dev

# Install Intel oneAPI
RUN apt-get install -y wget
RUN wget -O- https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB \
    | gpg --dearmor | tee /usr/share/keyrings/oneapi-archive-keyring.gpg > /dev/null
RUN echo "deb [signed-by=/usr/share/keyrings/oneapi-archive-keyring.gpg] https://apt.repos.intel.com/oneapi all main" \
    | tee /etc/apt/sources.list.d/oneAPI.list
RUN apt-get update -y
RUN apt-get install -y intel-basekit

# Install some user utilities
RUN apt-get install -y git htop vim tmux sudo

# Create User
RUN useradd -ms /bin/bash ubuntu && \
    usermod -aG sudo ubuntu && \
    echo 'ubuntu:ubuntu' | chpasswd

# Build and Install hipSYCL and Dependencies
# Install LLVM 13 (required by hipSYCL)
RUN cd $HOME                          && \
    wget https://apt.llvm.org/llvm.sh && \
    chmod +x llvm.sh                  && \
    ./llvm.sh 13                      && \
    apt-get install -y libclang-13-dev clang-tools-13 libomp-13-dev llvm-13-dev lld-13 libc++-13-dev && \
    rm llvm.sh

# Install Boost (required by hipSYCL)
RUN apt-get install -y libboost-all-dev

# Build and Install hipSYCL
USER ubuntu
WORKDIR /home/ubuntu
RUN cd $HOME      && \
    mkdir -p pkg  && \
    cd pkg        && \
    git clone --depth 1 https://github.com/illuhad/hipSYCL.git hipSYCL-source && \
    mkdir hipSYCL && \
    cd hipSYCL-source    && \
    mkdir build   && \
    cd build      && \
    cmake -DCMAKE_INSTALL_PREFIX=$HOME/pkg/hipSYCL .. && \
    make          && \
    make install  && \
    cd ../..         && \
    rm -rf hipSYCL-source

# Set ENV for hipSYCL
ENV PATH="${PATH}:/home/ubuntu/pkg/hipSYCL/bin"
ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/home/ubuntu/pkg/hipSYCL/lib"

