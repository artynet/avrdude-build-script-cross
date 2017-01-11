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

if [[ ! -f libftdi1-1.3.tar.bz2 ]] ;
then
	wget http://www.intra2net.com/en/developer/libftdi/download/libftdi1-1.3.tar.bz2
fi

tar xfv libftdi1-1.3.tar.bz2

# patching libfdti1

cd libftdi1-1.3
patch -p0 < ../libftdi1-patches/libftdi1-1.3-cmake-FindUSB1.patch
cd ..

mkdir -p avrdude-dist
cd avrdude-dist
PREFIX=`pwd`
cd -

mkdir -p libftdi1-build
cd libftdi1-build

CMAKEARGS="-DCMAKE_INSTALL_PREFIX=${PREFIX} \
	-DBUILD_TESTS:BOOL=off \
	-DFTDIPP:BOOL=off \
	-DPYTHON_BINDINGS:BOOL=off \
	-DEXAMPLES:BOOL=off \
	-DDOCUMENTATION:BOOL=off \
	-DFTDI_EEPROM:BOOL=off \
	-DLIBUSB_INCLUDE_DIR=${PREFIX}/include/libusb-1.0"

if [[ $CROSS_COMPILE != "" ]] ; then
  CMAKEARGS="$CMAKEARGS -DCMAKE_TOOLCHAIN_FILE=${PWD}/../cmakefiles/${TCCMAKE}.cmake"
fi

PKG_CONFIG_LIBDIR=\
"$PREFIX/lib/pkgconfig":\
"$PREFIX/lib64/pkgconfig" \
cmake \
	$CMAKEARGS \
  ../libftdi1-1.3

make && make install

cd -

rm -rf libftdi1-1.3 libftdi1-build
