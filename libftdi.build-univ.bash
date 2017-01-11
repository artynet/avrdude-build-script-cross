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

if [[ ! -f libftdi-0.20.tar.gz ]] ;
then
	wget http://www.intra2net.com/en/developer/libftdi/download/libftdi-0.20.tar.gz
fi

tar xfv libftdi-0.20.tar.gz

# patching libfdti1

cd libftdi-0.20
patch -p0 < ../libftdi-patches/libftdi-0.20-cmake-FindUSB.patch
cd ..

mkdir -p avrdude-dist
cd avrdude-dist
PREFIX=`pwd`
cd -

mkdir -p libftdi-build
cd libftdi-build

PKG_CONFIG_LIBDIR=\
"$PREFIX/lib/pkgconfig":\
"$PREFIX/lib64/pkgconfig" \
cmake \
  -DCMAKE_INSTALL_PREFIX="${PREFIX}" \
  -DBUILD_TESTS:BOOL=off \
  -DFTDIPP:BOOL=off \
  -DPYTHON_BINDINGS:BOOL=off \
  -DEXAMPLES:BOOL=off \
  -DDOCUMENTATION:BOOL=off \
  -DFTDI_EEPROM:BOOL=off \
  -DLIBUSB_INCLUDE_DIR=${PREFIX}/include/ \
  -DCMAKE_TOOLCHAIN_FILE=${PWD}/../cmakefiles/${TCCMAKE}.cmake \
  ../libftdi-0.20

make && make install

cd -

rm -rf libftdi-0.20 libftdi-build
