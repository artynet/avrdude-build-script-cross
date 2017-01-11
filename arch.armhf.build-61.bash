#!/bin/bash -ex

if [[ ! -d toolsdir  ]] ;
then
	echo "You must first build the tools: run tools.bash"
	exit 1
fi

[ -z ${1} ] && echo "insert platform ! (rpi1,rpi2 or rpi3)" && exit 0

export TCCMAKE=${1}

case $TCCMAKE in
    'rpi1')
        export ARCHZIP=armv6
        export HOST_NATIVE=armv6-rpi-linux-gnueabi
        ;;
    'rpi2')
        ARCHZIP=arm7vl
        export HOST_NATIVE=armv7-rpi2-linux-gnueabihf
        ;;
    'rpi3')
        ARCHZIP=armv8l
        export HOST_NATIVE=armv8-rpi3-linux-gnueabihf
        ;;
        *)
        echo ""
        echo "no arch supported"
        echo ""
        exit 0
        ;;
esac

cd toolsdir/bin
TOOLS_BIN_PATH=`pwd`
cd -

export ARCH=arm CROSS_COMPILE=$HOST_NATIVE-
export PATH="$TOOLS_BIN_PATH:/opt/$HOST_NATIVE/bin:$PATH"

./clean61.sh
rm -rf avrdude-dist

./libusb.build-univ.bash
./libelf-0.8.13.build-univ.bash
./libftdi1.build-univ.bash
# ./libftdi.build-univ.bash
./avrdude61.build-univ.bash

if [[ -f avrdude-dist/bin/avrdude ]] ;
then
	$HOST_NATIVE-strip --strip-all avrdude-dist/bin/avrdude_bin
	# mv avrdude-dist/bin/avrdude avrdude-dist/bin/avrdude_bin
	# cp launchers/avrdude.linux avrdude-dist/bin/avrdude
	chmod +x avrdude-dist/bin/avrdude
fi

# ARCH=`gcc -v 2>&1 | awk '/Target/ { print $2 }'`

rm -rf avrdude-6.1-arduino-$ARCHZIP
rm -f avrdude-6.1-arduino.org-$ARCHZIP.tar.bz2
mv avrdude-dist avrdude-6.1-arduino-$ARCHZIP
tar cfvj avrdude-6.1-arduino.org-$ARCHZIP.tar.bz2 avrdude-6.1-arduino-$ARCHZIP
