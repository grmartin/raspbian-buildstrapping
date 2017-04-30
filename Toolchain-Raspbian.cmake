set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_VERSION 1)

if (NOT XC_COMPILER_PREFIX)
    set(XC_COMPILER_PREFIX arm-linux-gnueabihf)
endif()

if (NOT XC_COMPILER_BIN_PATH)
    set(XC_COMPILER_BIN_PATH /usr/bin)
endif()

set(CMAKE_C_COMPILER
        ${XC_COMPILER_BIN_PATH}/${XC_COMPILER_PREFIX}-gcc)

set(CMAKE_CXX_COMPILER
        ${XC_COMPILER_BIN_PATH}/${XC_COMPILER_PREFIX}-g++)

# where is the target environment
set(CMAKE_FIND_ROOT_PATH
        ${XC_COMPILER_BIN_PATH})

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)


if (DEFINED "$ENV{PI_ROOT}") # We trust you know what you are doing
  set(PI_ROOT "$ENV{PI_ROOT}")
elseif (EXISTS "${CMAKE_CURRENT_LIST_DIR}/piroot/")
  set(PI_ROOT "${CMAKE_CURRENT_LIST_DIR}/piroot/")
elseif (EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/piroot/")
  set(PI_ROOT "${CMAKE_CURRENT_SOURCE_DIR}/piroot/")
endif()

if (PI_ROOT)
  set(CMAKE_SYSROOT "${PI_ROOT}")

  include_directories(BEFORE SYSTEM "${PI_ROOT}/usr/include")
  link_directories("${PI_ROOT}/usr/lib" "${PI_ROOT}/usr/lib/${XC_COMPILER_PREFIX}/")
endif()
