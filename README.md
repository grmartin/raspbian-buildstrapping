# Debian > Raspbian Cross Compiling Kit

This repository contains everything you might need to get a CMake project off the ground and building for crosscompiling an application to run on Raspbian from a modern Debian dfevelopment machine.

## Files

- `install_prereqs.sh` - Install the necessary cross compiling tools from Apt.
- `Toolchain-Raspbian.cmake` - A CMake configuration that sets up our cross compiler toolchain.
- `cmake-c` - An example CMake C99 Project
- `cmake-cpp` - An example CMake C++11 Project
