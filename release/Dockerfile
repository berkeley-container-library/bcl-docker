FROM ubuntu
MAINTAINER Benjamin Brock (brock@cs.berkeley.edu)

RUN apt-get update -y && apt-get dist-upgrade -y
RUN apt-get install tmux vim htop sudo wget libnuma-dev git -y
RUN apt-get install build-essential man-db manpages manpages-dev gcc-8 g++-8 -y
RUN useradd -m ubuntu
RUN usermod -aG sudo ubuntu
RUN chsh -s /bin/bash ubuntu
RUN echo 'ubuntu:ubuntu' | chpasswd

USER ubuntu
WORKDIR /home/ubuntu

RUN cd $HOME&&\
mkdir pkg&&\
cd pkg&&\
wget "https://github.com/openucx/ucx/releases/download/v1.5.1/ucx-1.5.1.tar.gz"&&\
tar -xf ucx-1.5.1.tar.gz&&\
mkdir ucx-1.5.1-build&&\
mv ucx-1.5.1 ucx-1.5.1-source&&\
mkdir ucx-1.5.1&&\
cd ucx-1.5.1-build&&\
../ucx-1.5.1-source/configure --prefix=$HOME/pkg/ucx-1.5.1&&\
make -j&&\
make install&&\
cd ..&&\
rm -rf ucx-1.5.1-source ucx-1.5.1-build ucx-1.5.1.tar.gz&&\
wget "https://download.open-mpi.org/release/open-mpi/v4.0/openmpi-4.0.1.tar.gz"&&\
tar -xf openmpi-4.0.1.tar.gz&&\
mkdir openmpi-4.0.1-build&&\
mv openmpi-4.0.1 openmpi-4.0.1-source&&\
mkdir openmpi-4.0.1&&\
cd openmpi-4.0.1-build&&\
../openmpi-4.0.1-source/configure --prefix=$HOME/pkg/openmpi-4.0.1 --with-ucx=$HOME/pkg/ucx-1.5.1&&\
make -j&&\
make install&&\
cd ..&&\
rm -rf openmpi-4.0.1-source openmpi-4.0.1-build openmpi-4.0.1.tar.gz&&\
echo "export PATH=\$PATH:$HOME/pkg/openmpi-4.0.1/bin\n" >> $HOME/.bashrc&&\
echo "export MANPATH=\$MANPATH:$HOME/pkg/openmpi-4.0.1/share/man\n" >> $HOME/.bashrc&&\
echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:$HOME/pkg/openmpi-4.0.1/lib\n" >> $HOME/.bashrc

RUN cd $HOME&&\
cd pkg&&\
export PATH=$PATH:$HOME/pkg/openmpi-4.0.1/bin&&\
export MANPATH=$MANPATH:$HOME/pkg/openmpi-4.0.1/share/man&&\
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOME/pkg/openmpi-4.0.1/lib&&\
wget "https://gasnet.lbl.gov/EX/GASNet-2019.3.0.tar.gz"&&\
tar -xf GASNet-2019.3.0.tar.gz&&\
mkdir GASNet-2019.3.0-build&&\
mv GASNet-2019.3.0 GASNet-2019.3.0-source&&\
mkdir GASNet-2019.3.0&&\
cd GASNet-2019.3.0-build&&\
../GASNet-2019.3.0-source/configure --prefix=$HOME/pkg/GASNet-2019.3.0&&\
make -j&&\
make install&&\
cd ..&&\
rm -rf GASNet-2019.3.0-build GASNet-2019.3.0-source GASNet-2019.3.0.tar.gz&&\
echo "export PATH=\$PATH:$HOME/pkg/GASNet-2019.3.0/bin\n" >> $HOME/.bashrc&&\
echo "export gasnet_prefix=\$PATH:$HOME/pkg/GASNet-2019.3.0\n" >> $HOME/.bashrc

RUN cd $HOME&&\
mkdir src&&\
cd src&&\
git clone https://github.com/berkeley-container-library/bcl.git
