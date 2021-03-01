#==============================================================================
# Description: This file contains General instructions on how to build cfitsio 
# project.
#==============================================================================
# Setting project configuration -- variable is empty by default
# - "Debug" builds library/executable w/o optimization and w/ debug symbols;
# - "Release" builds library/executable w/ optimization and w/o debug symbols;
# - "RelWithDebInfo" builds library/executable w/ less aggressive optimizations and w/ debug symbols;
# - "MinSizeRel" builds library/executable w/ optimizations that do not increase object code size.
if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release
    CACHE STRING
    "Specifies the Build type. Available options are: Release, Debug, RelWithDebInfo, MinSizeRel. Default: Release." FORCE
		)
endif()
#==============================================================================
# PROJECT OPTIONS AND VARIABLES
#==============================================================================
# Allow the developer to select if Dynamic or Static libraries are built
option(BUILD_SHARED_LIBS "Build Shared Libraries." ON)
if(BUILD_SHARED_LIBS)
  set(LIB_TYPE SHARED)
endif()
option(USE_PTHREADS "Thread-safe build (using PThreads)" ON)
# Allow cURL dependency to be enabled/disabled using "-DUSE_CURL=ON/OFF":
option(USE_CURL "Build CFITSIO with cURL support." ON)
# Looking for libraries (Unix Math, cURL, Threads)
include(dependencies)
# Setting directories for source files.
set(CFITSIO_SRC_DIR "${CMAKE_SOURCE_DIR}/cfitsio")
set(ZLIB_SRC_DIR "${CMAKE_SOURCE_DIR}/zlib")
#==============================================================================
# COMPILER SPECIFICATION
#==============================================================================
# Setting the -fPIC flag globally
set(CMAKE_POSITION_INDEPENDENT_CODE ON)
# Including informations about compilers
include(cc_compilers)
include(cxx_compilers)
# TODO: Put this into *_compilers.cmake <= or maybe put it inside cfitsio.cmake ?
# Microsoft Visual Studio:
if(MSVC OR BORLAND)
    # Define
    add_definitions(-D_CRT_SECURE_NO_DEPRECATE)
    # Need an empty unistd.h in MSVC for flex-generated eval_l.c:
    file(WRITE ${CFITSIO_SRC_DIR}/unistd.h "")
    include_directories(${CFITSIO_SRC_DIR})
endif()

if(BORLAND)
    # Suppress spurious Borland compiler warnings about "Suspicious
    # pointer arithmetic", "Possibly incorrect assignment", and
    # "Comparing signed and unsigned values".
    add_definitions(-w-spa)
    add_definitions(-w-pia)
    add_definitions(-w-csu)
endif()
#==============================================================================
# Including CFitsIO source files and other instructions on how to build the project
include(cfitsio)
