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
	wget "http://www.mpich.org/static/downloads/3.3.1/mpich-3.3.1.tar.gz"&&\
	tar -xf mpich-3.3.1.tar.gz &&\
	mkdir mpich-3.3.1-build&&\
	mv mpich-3.3.1 mpich-3.3.1-source&&\
	mkdir mpich-3.3.1&&\
	cd mpich-3.3.1-build&&\
	../mpich-3.3.1-source/configure --prefix=$HOME/pkg/mpich-3.3.1 --disable-fortran --enable-g=debug --enable-error-checking=all --enable-error-messages=all&&\
	make -j&&\
	make install&&\
	cd ..&&\
	rm -rf mpich-3.3.1-source mpich-3.3.1-build mpich-3.3.1.tar.gz

ENV PATH=$PATH:/home/ubuntu/pkg/mpich-3.3.1/bin \
	LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/ubuntu/pkg/mpich-3.3.1/lib \
	MANPATH=$MANPATH:/home/ubuntu/pkg/mpich-3.3.1/share/man

RUN cd $HOME&&\
	cd pkg&&\
	wget "https://gasnet.lbl.gov/EX/GASNet-2019.3.0.tar.gz"&&\
	tar -xf GASNet-2019.3.0.tar.gz&&\
	mkdir GASNet-2019.3.0-build&&\
	mv GASNet-2019.3.0 GASNet-2019.3.0-source&&\
	mkdir GASNet-2019.3.0&&\
	cd GASNet-2019.3.0-build&&\
	../GASNet-2019.3.0-source/configure --prefix=$HOME/pkg/GASNet-2019.3.0 --enable-debug&&\
	make -j&&\
	make install&&\
	cd ..&&\
	rm -rf GASNet-2019.3.0-build GASNet-2019.3.0-source GASNet-2019.3.0.tar.gz

ENV PATH=$PATH:/home/ubuntu/pkg/GASNet-2019.3.0/bin \
    gasnet_prefix=/home/ubuntu/pkg/GASNet-2019.3.0

RUN cd $HOME&&\
	cd pkg&&\
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
	../SOS-1.4.3-source/configure --prefix=$HOME/pkg/SOS-1.4.3 --with-ofi=$HOME/pkg/libfabric-1.7.1 --disable-fortran --enable-pmi-simple --enable-error-checking --enable-debug&&\
	make -j&&\
	make install&&\
	cd ..&&\
	rm -rf SOS-1.4.3-build SOS-1.4.3-source v1.4.3.tar.gz

ENV PATH=$PATH:/home/ubuntu/pkg/SOS-1.4.3/bin \
	LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/ubuntu/pkg/SOS-1.4.3/lib \
	MANPATH=$MANPATH:/home/ubuntu/pkg/SOS-1.4.3/share/man

RUN cd $HOME&&\
	mkdir src&&\
	cd src&&\
	git clone https://github.com/berkeley-container-library/bcl.git
