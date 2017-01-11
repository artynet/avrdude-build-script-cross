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

CURDIR=$PWD

mkdir -p avrdude-dist
cd avrdude-dist
PREFIX=`pwd`
cd -

# export PATH="$TOOLS_BIN_PATH:/opt/$HOST_NATIVE/bin:$PATH"

if [[ ! -f libelf-0.8.13.tar.gz  ]] ;
then
	wget http://www.mr511.de/software/libelf-0.8.13.tar.gz
fi

tar xfv libelf-0.8.13.tar.gz

mkdir -p libelf-build
cd libelf-build

CONFARGS=" --prefix=$PREFIX"

CFLAGS="-w -O2 $CFLAGS" CXXFLAGS="-w -O2 $CXXFLAGS" LDFLAGS="-s $LDFLAGS" ../libelf-0.8.13/configure $CONFARGS
make CC=${CROSS_COMPILE}gcc AR=${CROSS_COMPILE}ar RANLIB=${CROSS_COMPILE}ranlib \
	CXX=${CROSS_COMPILE}g++ LD=${CROSS_COMPILE}ld -j 1
make install

cd $CURDIR

rm -rf libelf-build libelf-0.8.13
