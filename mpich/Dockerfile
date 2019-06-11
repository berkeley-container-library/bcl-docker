FROM ubuntu
MAINTAINER Benjamin Brock (brock@cs.berkeley.edu)

RUN apt-get update -y && apt-get dist-upgrade -y
RUN apt-get install tmux vim htop sudo wget libnuma-dev git autoconf libtool -y
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
wget "http://www.mpich.org/static/downloads/3.3.1/mpich-3.3.1.tar.gz"&&\
tar -xf mpich-3.3.1.tar.gz &&\
mkdir mpich-3.3.1-build&&\
mv mpich-3.3.1 mpich-3.3.1-source&&\
mkdir mpich-3.3.1&&\
cd mpich-3.3.1-build&&\
../mpich-3.3.1-source/configure --prefix=$HOME/pkg/mpich-3.3.1 --disable-fortran&&\
make -j&&\
make install&&\
cd ..&&\
rm -rf mpich-3.3.1-source mpich-3.3.1-build mpich-3.3.1.tar.gz&&\
echo "export PATH=\$PATH:$HOME/pkg/mpich-3.3.1/bin\n" >> $HOME/.bashrc&&\
echo "export MANPATH=\$MANPATH:$HOME/pkg/mpich-3.3.1/share/man\n" >> $HOME/.bashrc&&\
echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:$HOME/pkg/mpich-3.3.1/lib\n" >> $HOME/.bashrc

RUN cd $HOME&&\
cd pkg&&\
export PATH=$PATH:$HOME/pkg/mpich-3.3.1/bin&&\
export MANPATH=$MANPATH:$HOME/pkg/mpich-3.3.1/share/man&&\
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOME/pkg/mpich-3.3.1/lib&&\
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
echo "export gasnet_prefix=$HOME/pkg/GASNet-2019.3.0\n" >> $HOME/.bashrc

RUN cd $HOME&&\
cd pkg&&\
export PATH=$PATH:$HOME/pkg/mpich-3.3.1/bin&&\
export MANPATH=$MANPATH:$HOME/pkg/mpich-3.3.1/share/man&&\
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOME/pkg/mpich-3.3.1/lib&&\
wget "https://github.com/ofiwg/libfabric/archive/v1.7.1.tar.gz"&&\
tar -xf v1.7.1.tar.gz&&\
mv libfabric-1.7.1 libfabric-1.7.1-source&&\
mkdir libfabric-1.7.1-build&&\
mkdir libfabric-1.7.1&&\
cd libfabric-1.7.1-source&&\
./autogen.sh&&\
cd ../libfabric-1.7.1-build&&\
../libfabric-1.7.1-source/configure --prefix=$HOME/pkg/libfabric-1.7.1&&\
make -j&&\
make install&&\
cd ..&&\
rm -rf libfabric-1.7.1-build libfabric-1.7.1-source v1.7.1.tar.gz&&\
wget "https://github.com/Sandia-OpenSHMEM/SOS/archive/v1.4.3.tar.gz"&&\
tar -xf v1.4.3.tar.gz&&\
mv SOS-1.4.3 SOS-1.4.3-source&&\
mkdir SOS-1.4.3&&\
mkdir SOS-1.4.3-build&&\
cd SOS-1.4.3-source&&\
./autogen.sh&&\
cd ../SOS-1.4.3-build&&\
../SOS-1.4.3-source/configure --prefix=$HOME/pkg/SOS-1.4.3 --with-ofi=$HOME/pkg/libfabric-1.7.1 --disable-fortran --enable-pmi-simple&&\
make -j&&\
make install&&\
cd ..&&\
rm -rf SOS-1.4.3-build SOS-1.4.3-source v1.4.3.tar.gz&&\
echo "export PATH=\$PATH:$HOME/pkg/SOS-1.4.3/bin\n" >> $HOME/.bashrc&&\
echo "export MANPATH=\$MANPATH:$HOME/pkg/SOS-1.4.3/share/man\n" >> $HOME/.bashrc&&\
echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:$HOME/pkg/SOS-1.4.3/lib\n" >> $HOME/.bashrc

RUN cd $HOME&&\
mkdir src&&\
cd src&&\
git clone https://github.com/berkeley-container-library/bcl.git
