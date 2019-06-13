FROM ubuntu:18.04
MAINTAINER Benjamin Brock (brock@cs.berkeley.edu)

RUN apt-get update -y && apt-get dist-upgrade -y &&\
    apt-get install tmux vim htop sudo wget libnuma-dev git autoconf libtool -y &&\
    apt-get install build-essential man-db manpages manpages-dev gcc-8 g++-8 -y &&\
    rm -rf /var/lib/apt/lists/*

# set up user
RUN useradd -ms /bin/bash ubuntu &&\
    usermod -aG sudo ubuntu &&\
	echo 'ubuntu:ubuntu' | chpasswd

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
	rm -rf openmpi-4.0.1-source openmpi-4.0.1-build openmpi-4.0.1.tar.gz

ENV PATH=$PATH:/home/ubuntu/pkg/openmpi-4.0.1/bin \
	MANPATH=$MANPATH:/home/ubuntu/pkg/openmpi-4.0.1/share/man \
	LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/ubuntu/pkg/openmpi-4.0.1/lib

RUN cd $HOME&&\
	cd pkg&&\
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
	rm -rf GASNet-2019.3.0-build GASNet-2019.3.0-source GASNet-2019.3.0.tar.gz

ENV PATH=$PATH:/home/ubuntu/pkg/GASNet-2019.3.0/bin \
    gasnet_prefix=/home/ubuntu/pkg/GASNet-2019.3.0

RUN cd $HOME&&\
	mkdir src&&\
	cd src&&\
	git clone https://github.com/berkeley-container-library/bcl.git
