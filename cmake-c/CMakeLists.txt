# Basic Cross Compile Exe for RaspberryPi 3, targeting Raspbian and C99.
cmake_minimum_required(VERSION 3.7)
project(cmake_c)

include(../Toolchain-Raspbian.cmake)

set(CMAKE_C_STANDARD 99)

set(SOURCE_FILES main.c)
add_executable(cmake_c ${SOURCE_FILES})