#!/bin/bash -ex
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

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

./clean62.sh
rm -rf avrdude-dist

./libusb.build-univ.bash
./libelf-0.8.13.build-univ.bash
./libftdi1.build-univ.bash
./avrdude62.build-univ.bash

if [[ -f avrdude-dist/bin/avrdude ]] ;
then
	$HOST_NATIVE-strip --strip-all avrdude-dist/bin/avrdude_bin
	# mv avrdude-dist/bin/avrdude avrdude-dist/bin/avrdude_bin
	# cp launchers/avrdude.linux avrdude-dist/bin/avrdude
	chmod +x avrdude-dist/bin/avrdude
fi

# ARCH=`gcc -v 2>&1 | awk '/Target/ { print $2 }'`

rm -rf avrdude-6.2-arduino-$ARCHZIP
rm -f avrdude-6.2-arduino.org-$ARCHZIP.tar.bz2
mv avrdude-dist avrdude-6.2-arduino-$ARCHZIP
tar cfvj avrdude-6.2-arduino.org-$ARCHZIP.tar.bz2 avrdude-6.2-arduino-$ARCHZIP
