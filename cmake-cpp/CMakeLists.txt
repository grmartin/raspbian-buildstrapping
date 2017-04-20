# Basic Cross Compile Exe for RaspberryPi 3, targeting Raspbian and C++11.

cmake_minimum_required(VERSION 3.7)
project(cmake_cpp)

include(../Toolchain-Raspbian.cmake)

set(CMAKE_CXX_STANDARD 11)

set(SOURCE_FILES main.cpp)
add_executable(cmake_cpp ${SOURCE_FILES})