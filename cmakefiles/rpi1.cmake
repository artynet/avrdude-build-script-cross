# the name of the target operating system
SET(CMAKE_SYSTEM_NAME Linux)

# which compilers to use for C and C++
SET(CMAKE_C_COMPILER armv6-rpi-linux-gnueabi-gcc)
SET(CMAKE_CXX_COMPILER armv6-rpi-linux-gnueabi-g++)

# here is the target environment located
# SET(CMAKE_FIND_ROOT_PATH  /opt/armv6-rpi-linux-gnueabi/sysroot)

# adjust the default behaviour of the FIND_XXX() commands:
# search headers and libraries in the target environment, search
# programs in the host environment
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
