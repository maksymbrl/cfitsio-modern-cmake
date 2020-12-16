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
# Allow @rpath token in target install name on Macs.
# See "cmake --help-policy CMP0042" for more information.
if(POLICY CMP0042)
  cmake_policy(SET CMP0042 NEW)
endif()
#==============================================================================
include(CheckLibraryExists)
include(CheckFunctionExists)
#==============================================================================
# Allow the developer to select if Dynamic or Static libraries are built
#option(BUILD_STATIC_LIBS "Build Static Libraries" OFF)
option(BUILD_SHARED_LIBS "Build Shared Libraries" ON)
option(USE_PTHREADS "Thread-safe build (using pthreads)" OFF)
# Allow cURL dependency to be disabled using "-DUSE_CURL=OFF":
option(USE_CURL "Build CFITSIO with cURL support." ON)
#==============================================================================
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake")
set(LIB_DESTINATION "${CMAKE_INSTALL_PREFIX}/lib${LIB_SUFFIX}")
set(INCLUDE_INSTALL_DIR "${CMAKE_INSTALL_PREFIX}/include/")
#==============================================================================
# Microsoft Visual Studio:
if(MSVC OR BORLAND)
    # Define
    add_definitions(-D_CRT_SECURE_NO_DEPRECATE)
    # Need an empty unistd.h in MSVC for flex-generated eval_l.c:
    file(WRITE ${CMAKE_SOURCE_DIR}/unistd.h "")
    include_directories(${CMAKE_SOURCE_DIR})
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

#add_subdirectory (src)

#if(BUILD_STATIC_LIBS)
#	set(LIB_TYPE STATIC)
if(BUILD_SHARED_LIBS)
  set(LIB_TYPE SHARED)
endif()


if(USE_PTHREADS)
	find_package(PTHREADS REQUIRED)
	#include_directories(${PTHREADS_INCLUDE_DIR})
	add_definitions(-D_REENTRANT)
endif()

# Math library (not available in MSVC or MINGW)
if(MSVC OR MINGW)
    set(M_LIB "")
	else()
    find_library(M_LIB m)
endif()

# Support for remote file drivers is not implemented for native Windows:
if(NOT MSVC)
	# Find library needed for gethostbyname:
	check_function_exists("gethostbyname" CMAKE_HAVE_GETHOSTBYNAME)
	if(NOT CMAKE_HAVE_GETHOSTBYNAME)
		 check_library_exists("nsl" "gethostbyname" "" CMAKE_HAVE_GETHOSTBYNAME)
	endif()

	# Find library needed for connect:
	check_function_exists("connect" CMAKE_HAVE_CONNECT)
	if(NOT CMAKE_HAVE_CONNECT)
		 check_library_exists("socket" "connect" "" CMAKE_HAVE_CONNECT)
	endif()

	# Define HAVE_NET_SERVICES if gethostbyname & connect were found:
	if(CMAKE_HAVE_GETHOSTBYNAME AND CMAKE_HAVE_CONNECT)
			add_definitions(-DHAVE_NET_SERVICES)
	endif ()

	# Find curl library, for HTTPS support:
	# making this as a requirement if user 
	# decides to compile CFITSIO with cURL. 
	if(USE_CURL)
		find_package(CURL REQUIRED)
			if(CURL_FOUND)
				#include_directories(${CURL_INCLUDE_DIRS})
				add_definitions(-DCFITSIO_HAVE_CURL)
			endif()
	endif()
endif()

#==============================================================================
set(CFITSIO_SRC_DIR "${CMAKE_SOURCE_DIR}/cfitsio")
set(ZLIB_SRC_DIR "${CMAKE_SOURCE_DIR}/zlib")
file(GLOB H_FILES "*.h")
set(SRC_FILES
    ${CFITSIO_SRC_DIR}/buffers.c 
		${CFITSIO_SRC_DIR}/cfileio.c 
		${CFITSIO_SRC_DIR}/checksum.c
    ${CFITSIO_SRC_DIR}/drvrfile.c 
		${CFITSIO_SRC_DIR}/drvrmem.c 
		${CFITSIO_SRC_DIR}/drvrnet.c
    ${CFITSIO_SRC_DIR}/editcol.c 
		${CFITSIO_SRC_DIR}/edithdu.c 
		${CFITSIO_SRC_DIR}/eval_f.c 
		${CFITSIO_SRC_DIR}/eval_l.c 
		${CFITSIO_SRC_DIR}/eval_y.c
    ${CFITSIO_SRC_DIR}/f77_wrap1.c 
		${CFITSIO_SRC_DIR}/f77_wrap2.c 
		${CFITSIO_SRC_DIR}/f77_wrap3.c 
		${CFITSIO_SRC_DIR}/f77_wrap4.c
    ${CFITSIO_SRC_DIR}/fits_hcompress.c 
		${CFITSIO_SRC_DIR}/fits_hdecompress.c 
		${CFITSIO_SRC_DIR}/fitscore.c
    ${CFITSIO_SRC_DIR}/getcol.c 
		${CFITSIO_SRC_DIR}/getcolb.c 
		${CFITSIO_SRC_DIR}/getcold.c 
		${CFITSIO_SRC_DIR}/getcole.c 
		${CFITSIO_SRC_DIR}/getcoli.c 
		${CFITSIO_SRC_DIR}/getcolj.c 
		${CFITSIO_SRC_DIR}/getcolk.c
    ${CFITSIO_SRC_DIR}/getcoll.c 
		${CFITSIO_SRC_DIR}/getcols.c 
		${CFITSIO_SRC_DIR}/getcolsb.c 
		${CFITSIO_SRC_DIR}/getcolui.c 
		${CFITSIO_SRC_DIR}/getcoluj.c 
		${CFITSIO_SRC_DIR}/getcoluk.c
    ${CFITSIO_SRC_DIR}/getkey.c 
		${CFITSIO_SRC_DIR}/group.c 
		${CFITSIO_SRC_DIR}/grparser.c 
		${CFITSIO_SRC_DIR}/histo.c 
		${CFITSIO_SRC_DIR}/imcompress.c 
		${CFITSIO_SRC_DIR}/iraffits.c 
		${CFITSIO_SRC_DIR}/modkey.c
    ${CFITSIO_SRC_DIR}/pliocomp.c
    ${CFITSIO_SRC_DIR}/putcol.c 
		${CFITSIO_SRC_DIR}/putcolb.c 
		${CFITSIO_SRC_DIR}/putcold.c 
		${CFITSIO_SRC_DIR}/putcole.c 
		${CFITSIO_SRC_DIR}/putcoli.c 
		${CFITSIO_SRC_DIR}/putcolj.c 
		${CFITSIO_SRC_DIR}/putcolk.c
    ${CFITSIO_SRC_DIR}/putcoll.c 
		${CFITSIO_SRC_DIR}/putcols.c 
		${CFITSIO_SRC_DIR}/putcolsb.c 
		${CFITSIO_SRC_DIR}/putcolu.c 
		${CFITSIO_SRC_DIR}/putcolui.c 
		${CFITSIO_SRC_DIR}/putcoluj.c 
		${CFITSIO_SRC_DIR}/putcoluk.c
    ${CFITSIO_SRC_DIR}/putkey.c 
		${CFITSIO_SRC_DIR}/quantize.c 
		${CFITSIO_SRC_DIR}/region.c 
		${CFITSIO_SRC_DIR}/ricecomp.c 
		${CFITSIO_SRC_DIR}/scalnull.c 
		${CFITSIO_SRC_DIR}/simplerng.c 
		${CFITSIO_SRC_DIR}/swapproc.c
    ${CFITSIO_SRC_DIR}/wcssub.c 
		${CFITSIO_SRC_DIR}/wcsutil.c 
		${ZLIB_SRC_DIR}/zcompress.c 
		${ZLIB_SRC_DIR}/zuncompress.c
)

#==============================================================================
# For future modifications:

# drvrsmem.c is only usable if HAVE_SHMEM_SERVICES is defined:
#drvrsmem.c

# drvrgsiftp.c is only usable if HAVE_NET_SERVICES & HAVE_GSIFTP are defined:
#drvrgsiftp.c

# Only include zlib source files if we are building a shared library.
# Users will need to link their executable with zlib independently.
if(BUILD_SHARED_LIBS)
	set(SRC_FILES ${SRC_FILES}
			${ZLIB_SRC_DIR}/adler32.c 
			${ZLIB_SRC_DIR}/crc32.c 
			${ZLIB_SRC_DIR}/deflate.c 
			${ZLIB_SRC_DIR}/infback.c
			${ZLIB_SRC_DIR}/inffast.c 
			${ZLIB_SRC_DIR}/inflate.c 
			${ZLIB_SRC_DIR}/inftrees.c 
			${ZLIB_SRC_DIR}/trees.c
			${ZLIB_SRC_DIR}/uncompr.c 
			${ZLIB_SRC_DIR}/zutil.c
			)
endif()

#==============================================================================
add_library(${LIB_NAME} ${LIB_TYPE} ${H_FILES} ${SRC_FILES})
# Linking PThreads if it is present
if(PTHREADS_FOUND)
	target_include_directories(${LIB_NAME} PUBLIC ${PTHREADS_INCLUDE_DIR})
	target_link_libraries(${LIB_NAME} ${PTHREADS_LIBRARY})
endif()
target_link_libraries(${LIB_NAME} ${M_LIB})
# Linking cURL if it is present
if(CURL_FOUND)
	target_include_directories(${LIB_NAME} PUBLIC ${CURL_INCLUDE_DIRS})
	target_link_libraries(${LIB_NAME} ${CURL_LIBRARIES})
endif(CURL_FOUND)

set_target_properties(${LIB_NAME} 
	PROPERTIES VERSION ${${PROJECT_NAME}_VERSION} SOVERSION ${${PROJECT_NAME}_MAJOR_VERSION}
	)
install(TARGETS ${LIB_NAME} DESTINATION ${LIB_DESTINATION})
install(TARGETS ${LIB_NAME}
	RUNTIME DESTINATION bin
	LIBRARY DESTINATION lib
	ARCHIVE DESTINATION lib
	)
install(FILES ${H_FILES} DESTINATION ${INCLUDE_INSTALL_DIR} COMPONENT Devel)

#==============================================================================
# Only build test code and executables if building a shared library:
if(BUILD_SHARED_LIBS)

    enable_testing()

    add_executable(TestProg 
			${CFITSIO_SRC_DIR}/testprog.c
			)
    target_link_libraries(TestProg ${LIB_NAME})
    add_test(TestProg TestProg)
    # Copy testprog.tpt to build directory to allow quick test
    # of ./TestProg (or .\Release\TestProg.exe in MSVC):
		#file(COPY ${CMAKE_SOURCE_DIR}/testprog.tpt DESTINATION ${CMAKE_CURRENT_BINARY_DIR})
    file(COPY ${CFITSIO_SRC_DIR}/testprog.tpt DESTINATION ${CMAKE_CURRENT_BINARY_DIR})

    add_executable(cookbook 
			${CFITSIO_SRC_DIR}/cookbook.c
			)
    target_link_libraries(cookbook ${LIB_NAME})
    add_test(cookbook cookbook)

    add_executable(FPack 
			${CFITSIO_SRC_DIR}/fpack.c 
			${CFITSIO_SRC_DIR}/fpackutil.c
			)
    target_link_libraries(FPack ${LIB_NAME})

    add_executable(Funpack 
			${CFITSIO_SRC_DIR}/funpack.c 
			${CFITSIO_SRC_DIR}/fpackutil.c
			)
    target_link_libraries(Funpack ${LIB_NAME})

    add_executable(Fitscopy 
			${CFITSIO_SRC_DIR}/fitscopy.c
			)
    target_link_libraries(Fitscopy ${LIB_NAME})

    # To expand the command line arguments in Windows, see:
    # http://msdn.microsoft.com/en-us/library/8bch7bkk.aspx
    if(MSVC)
      set_target_properties(FPack Funpack PROPERTIES LINK_FLAGS "setargv.obj")
    endif(MSVC)

endif()

#==============================================================================
#configure_file(${CMAKE_CURRENT_SOURCE_DIR}/cfitsio.pc.cmake ${CMAKE_CURRENT_BINARY_DIR}/cfitsio.pc @ONLY)
configure_file(${CMAKE_SOURCE_DIR}/cfitsio.pc.cmake ${CMAKE_CURRENT_BINARY_DIR}/cfitsio.pc @ONLY)
install(FILES ${CMAKE_CURRENT_BINARY_DIR}/cfitsio.pc DESTINATION lib/pkgconfig/)
#==============================================================================
