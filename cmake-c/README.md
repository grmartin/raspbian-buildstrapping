# Simple CMake C Example

This is a simple example of how to get a CMake 3.7+ project off the ground and crosscompiling for Raspbian.

Simply Compile:

    cmake --build ./pi-build-strap/cmake-c/cmake-build-debug --target cmake_c -- -j 3
    Scanning dependencies of target cmake_c
    [ 50%] Building C object CMakeFiles/cmake_c.dir/main.c.o
    [100%] Linking C executable cmake_c
    [100%] Built target cmake_c

Verify the Output:

    grmartin@debian:pi-build-strap/cmake-c$ file cmake-build-debug/cmake_c
    cmake-build-debug/cmake_c: ELF 32-bit LSB shared object, ARM, EABI5
    version 1 (SYSV), dynamically linked, interpreter
    /lib/ld-linux-armhf.so.3, for GNU/Linux 3.2.0,
    BuildID[sha1]=910b8b4da246a1c223b47ba13f924be20d196e57, not stripped


Upload:

    grmartin@debian:pi-build-strap/cmake-c$ scp cmake-build-debug/cmake_c pi@192.168.0.117:/home/pi/
    Enter passphrase for key '/home/grmartin/.ssh/id_pi_key':
    cmake_c                                       100%   11KB 690.2KB/s   00:00

Execute:

    grmartin@debian:pi-build-strap/cmake-c$ ssh pi@192.168.0.117
    Enter passphrase for key '/home/grmartin/.ssh/id_pi_key':

    The programs included with the Debian GNU/Linux system are free software;
    the exact distribution terms for each program are described in the
    individual files in /usr/share/doc/*/copyright.

    Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
    permitted by applicable law.
    Last login: Thu Apr 20 12:07:03 2017 from 192.168.0.230
    pi@raspberrypi:~ $ ./cmake_c
    Hello from cmake-c!

