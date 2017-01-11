#!/bin/bash -ex

mkdir -p toolsdir/bin
cd toolsdir
TOOLS_PATH=`pwd`
cd bin
TOOLS_BIN_PATH=`pwd`
cd ../../

export PATH="$TOOLS_BIN_PATH:$PATH"

if [ -z "$MAKE_JOBS" ]; then
	MAKE_JOBS="2"
fi

if [[ ! -f autoconf-2.69.tar.xz  ]] ;
then
	wget http://mirror.switch.ch/ftp/mirror/gnu/autoconf/autoconf-2.69.tar.xz
fi

tar xvf autoconf-2.69.tar.xz

cd autoconf-2.69

CONFARGS="--prefix=$TOOLS_PATH"

./configure $CONFARGS

nice -n 10 make -j $MAKE_JOBS

make install

cd -

if [[ ! -f automake-1.15.tar.gz  ]] ;
then
	wget https://ftp.gnu.org/gnu/automake/automake-1.15.tar.gz
fi

tar xfv automake-1.15.tar.gz

cd automake-1.15

# ./bootstrap

CONFARGS="--prefix=$TOOLS_PATH"

./configure $CONFARGS

nice -n 10 make -j $MAKE_JOBS

make install

cd -

rm -rf autoconf-2.69 automake-1.15
