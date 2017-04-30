# Basic Cross Compile Exe for RaspberryPi 3, targeting Raspbian and c++98 linked to a Library (Mongo).
cmake_minimum_required(VERSION 3.7)
project(cmake_cpp_lib)

include(../Toolchain-Raspbian.cmake)

# Presently supports: 98, 11 or 14. https://cmake.org/cmake/help/v3.1/prop_tgt/CXX_STANDARD.html
set(CMAKE_CXX_STANDARD 98)

# Personally, i find this useful for debugging. Enable or disable at your pleasure.
# set(CMAKE_VERBOSE_MAKEFILE "ON")

# The mongo library we are using isnt compiled for C++ '11. If we dont set the standard back as we do in CMAKE_CXX_STANDARD and define this, you may see the following:
#   _ZTVN5mongo18AssertionExceptionE[_ZTVN5mongo18AssertionExceptionE]+0x20): undefined reference to `mongo::DBException::toString[abi:cxx11]() const'
#   This is the linker putting you on notice that you are using CXX11 abi exceptions but the library youre invoking (in this case mongo) isnt.
add_definitions(-D_GLIBCXX_USE_CXX11_ABI=0)

link_libraries(mongoclient boost_system boost_thread boost_regex boost_filesystem boost_program_options boost_exception pthread ssl crypto)

set(SOURCE_FILES main.cpp)
add_executable(cmake_cpp_lib ${SOURCE_FILES})