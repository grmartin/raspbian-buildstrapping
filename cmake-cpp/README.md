# Simple CMake C++ Example

This is a simple example of how to get a CMake 3.7+ project off the ground and crosscompiling for Raspbian.

Simply Compile:

    cmake -DCMAKE_BUILD_TYPE=Debug -G "CodeBlocks - Unix Makefiles" ./pi-build-strap/cmake-cpp
    -- Configuring done
    -- Generating done
    -- Build files have been written to: /home/grmartin/Active/FOSS/pi-build-strap/cmake-cpp/cmake-build-debug

Verify the Output:

    grmartin@debian:pi-build-strap/cmake-cpp$ file cmake-build-debug/cmake_cpp
    cmake-build-debug/cmake_cpp: ELF 32-bit LSB shared object, ARM, EABI5 version 1 (SYSV),
    dynamically linked, interpreter /lib/ld-linux-armhf.so.3, for GNU/Linux 3.2.0,
    BuildID[sha1]=96175565449df258f2193adc80971bd099d060d0, not stripped

Upload:

    grmartin@debian:pi-build-strap/cmake-cpp$ scp cmake-build-debug/cmake_cpp pi@192.168.0.117:/home/pi/
    Enter passphrase for key '/home/grmartin/.ssh/id_pi_key':
    cmake_cpp                                     100%   28KB 180.2KB/s   00:00

Execute:

    grmartin@debian:pi-build-strap/cmake-cpp$ ssh pi@192.168.0.117
    Enter passphrase for key '/home/grmartin/.ssh/id_pi_key':

    The programs included with the Debian GNU/Linux system are free software;
    the exact distribution terms for each program are described in the
    individual files in /usr/share/doc/*/copyright.

    Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
    permitted by applicable law.
    Last login: Wed Apr 19 22:44:21 2017 from 192.168.0.106
    pi@raspberrypi:~ $ ./cmake_cpp
    Hello from make-cpp!
