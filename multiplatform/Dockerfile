FROM nvidia/cuda:11.4.2-devel-ubuntu20.04 as build

RUN mkdir -p /opt/build && mkdir -p /opt/dist

RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    ca-certificates curl

# install cmake
RUN cd /opt/build && \
    curl -LO https://github.com/Kitware/CMake/releases/download/v3.20.2/cmake-3.20.2-linux-x86_64.sh && \
    mkdir -p /opt/dist//usr/local && \
    /bin/bash cmake-3.20.2-linux-x86_64.sh --prefix=/opt/dist//usr/local --skip-license


FROM nvidia/cuda:11.4.2-devel-ubuntu20.04

COPY --from=build /opt/dist /

ARG DEBIAN_FRONTEND=noninteractive
ARG APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1

# install OS tools
RUN apt-get update -y && \
apt-get install -y --no-install-recommends -o=Dpkg::Use-Pty=0 \
build-essential \
pkg-config \
ca-certificates \
gnupg \
libarchive13 \
wget

# add apt repo public key
ARG url=https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS-2023.PUB
RUN wget $url
RUN file=$(basename "$url") && \
    apt-key add "$file" && \
    rm "$file"

# configure the repository
ARG repo=https://apt.repos.intel.com/oneapi
RUN echo "deb $repo all main" > /etc/apt/sources.list.d/oneAPI.list

# disable cert check
ARG disable_cert_check=
RUN if [ "$disable_cert_check" ] ; then echo "Acquire::https::Verify-Peer \"false\";\nAcquire::https::Verify-Host \"false\";" > /etc/apt/apt.conf.d/99-disable-cert-check ; fi

# install Intel(R) oneAPI Base Toolkit
RUN apt-get update -y && \
apt-get install -y --no-install-recommends -o=Dpkg::Use-Pty=0 \
intel-basekit-getting-started \
intel-oneapi-advisor \
intel-oneapi-ccl-devel \
intel-oneapi-common-licensing \
intel-oneapi-common-vars \
intel-oneapi-compiler-dpcpp-cpp \
intel-oneapi-dal-devel \
intel-oneapi-dev-utilities \
intel-oneapi-dnnl-devel \
intel-oneapi-dpcpp-debugger \
intel-oneapi-ipp-devel \
intel-oneapi-ippcp-devel \
intel-oneapi-libdpstd-devel \
intel-oneapi-mkl-devel \
intel-oneapi-onevpl-devel \
intel-oneapi-python \
intel-oneapi-tbb-devel \
intel-oneapi-vtune \
--

# install Intel GPU drivers
RUN echo 'deb [trusted=yes arch=amd64] https://repositories.intel.com/graphics/ubuntu bionic main' \
> /etc/apt/sources.list.d/intel-graphics.list

ARG url=https://repositories.intel.com/graphics/intel-graphics.key
RUN wget $url && file=$(basename "$url") && \
    file=$(basename "$url") && \
    apt-key add "$file" && \
    rm "$file"

RUN apt-get update -y && \
apt-get install -y --no-install-recommends -o=Dpkg::Use-Pty=0 \
intel-opencl \
intel-level-zero-gpu \
level-zero \
level-zero-devel

# install Intel(R) oneAPI HPC Toolkit
RUN apt-get update -y && \
apt-get install -y --no-install-recommends -o=Dpkg::Use-Pty=0 \
intel-hpckit-getting-started \
intel-oneapi-clck \
intel-oneapi-common-licensing \
intel-oneapi-common-vars \
intel-oneapi-compiler-dpcpp-cpp-and-cpp-classic \
intel-oneapi-compiler-fortran \
intel-oneapi-dev-utilities \
intel-oneapi-inspector \
intel-oneapi-itac \
intel-oneapi-mpi-devel \
--

RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    tmux vim htop sudo wget git file ssh libnuma-dev build-essential

RUN useradd -ms /bin/bash ubuntu &&\
    usermod -aG sudo ubuntu &&\
	echo 'ubuntu:ubuntu' | chpasswd

USER ubuntu
WORKDIR /home/ubuntu

# setvars.sh environment variables
RUN cd $HOME && \
env > default_env_vars; \
. /opt/intel/oneapi/setvars.sh; \
env > env_vars; \
diff default_env_vars env_vars \
| grep ">" | sed  s/..// \
| sort \
| sed 's/^/export /' | sed "s/=/='/" | sed "s/$/'/" \
>> $HOME/.oneapi_env_vars; \
# clean up
rm *env_vars; \
echo "ubuntu" | sudo -S rm -rf /var/lib/apt/lists/*

# Install UCX
RUN cd $HOME && \
mkdir -p pkg && cd pkg && \
wget "https://github.com/openucx/ucx/releases/download/v1.11.2/ucx-1.11.2.tar.gz" && \
tar -xf ucx-1.11.2.tar.gz && \
mkdir ucx-1.11.2-build && cd ucx-1.11.2-build && \
../ucx-1.11.2/configure && \
make -j 4 && \
echo "ubuntu" | sudo -S make install && \
cd .. && rm -rf *.tar.gz *-build ucx-1.11.2

# Install Open MPI
RUN cd $HOME && \
mkdir -p pkg && cd pkg && \
wget "https://download.open-mpi.org/release/open-mpi/v4.1/openmpi-4.1.1.tar.gz" && \
tar -xf openmpi-4.1.1.tar.gz && \
mkdir openmpi-4.1.1-build && cd openmpi-4.1.1-build && \
../openmpi-4.1.1/configure --with-ucx --enable-oshmem && \
make -j4 && \
echo "ubuntu" | sudo -S make install && \
cd .. && rm -rf *.tar.gz *-build openmpi-4.1.1

# Install GASNet-EX
RUN cd $HOME && \
mkdir -p pkg && cd pkg && \
wget "https://gasnet.lbl.gov/EX/GASNet-2021.9.0.tar.gz" && \
tar -xf GASNet-2021.9.0.tar.gz && \
mv GASNet-2021.9.0 GASNet-2021.9.0-source && \
mkdir GASNet-2021.9.0 && \
mkdir GASNet-2021.9.0-build && cd GASNet-2021.9.0-build && \
../GASNet-2021.9.0-source/configure --enable-ucx --prefix=$HOME/pkg/GASNet-2021.9.0 && \
make -j4 && \
echo "ubuntu" | sudo -S make install && \
cd .. && rm -rf *.tar.gz *-build *-source && \
echo "" >> $HOME/.bashrc && \
echo "export gasnet_prefix=$HOME/pkg/GASNet-2021.9.0" >> $HOME/.bashrc

ENTRYPOINT ["bash", "-c", "source /home/ubuntu/.oneapi_env_vars && \"$@\"", "bash"]
