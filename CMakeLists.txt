#==============================================================================
# Revork of CFITSIO CMakeLists.txt with modern CMake practices.
# Modifications done by Maksym Brilenkov
#==============================================================================
# Ensure out-of-source build
if(${CMAKE_SOURCE_DIR} STREQUAL ${CMAKE_BINARY_DIR})
	message(FATAL_ERROR 
		"IN-SOURCE BUILDS ARE NOT ALLOWED! Please, create 'build' directory and run configuration from it."
		)
endif()
#==============================================================================
# Suppress warning about WIN32 no longer being defined on Cygwin:
set(CMAKE_LEGACY_CYGWIN_WIN32 0)
#==============================================================================
# Standard CMake definitions
cmake_minimum_required(VERSION 3.17)
project(CFITSIO
	DESCRIPTION "Library of C and Fortran subroutines for reading and writing data files in FITS data format."
	LANGUAGES C CXX
	)
#==============================================================================
# Define project version
set(${PROJECT_NAME}_MAJOR_VERSION 3)
set(${PROJECT_NAME}_MINOR_VERSION 49)
set(${PROJECT_NAME}_VERSION ${${PROJECT_NAME}_MAJOR_VERSION}.${${PROJECT_NAME}_MINOR_VERSION})
set(LIB_NAME cfitsio)
#==============================================================================
# Allow @rpath token in target install name on Macs.
# See "cmake --help-policy CMP0042" for more information.
if(POLICY CMP0042)
  cmake_policy(SET CMP0042 NEW)
endif()
#==============================================================================
include(CheckLibraryExists)
include(CheckFunctionExists)
#==============================================================================
# Setting CMake modules (aka cusom Find<LIBRARY>.cmake) location(s).
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake")
set(INCLUDE_INSTALL_DIR "${CMAKE_INSTALL_PREFIX}/include/")
# To increase readability, split this file and include necessary pieces.
include(instructions)
