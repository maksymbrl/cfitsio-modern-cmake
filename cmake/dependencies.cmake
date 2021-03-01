#==============================================================================
# Description: This file contains instructions to look for CFitsIO dependencies
# according to user configuration.
#==============================================================================
# Looking for Posix Threads
#==============================================================================
if(USE_PTHREADS)
	find_package(Threads REQUIRED)
	add_definitions(-D_REENTRANT)
endif()
#==============================================================================
# Looking for Unix Math Library
#==============================================================================
# Note: Math library (not available in MSVC or MINGW)
if(MSVC OR MINGW)
    set(M_LIB "")
	else()
    find_library(M_LIB m)
endif()
#==============================================================================
# Looking for cURL
#==============================================================================
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
		# Note: It seems that if cURL is installed with CMake, 
		# the provided config file doesn't work properly, so it
		# is better to disable this feature and look for cURL as
		# if it was installed by configure.
		set(CURL_NO_CURL_CMAKE ON)
		find_package(CURL REQUIRED)
			if(CURL_FOUND)
				#include_directories(${CURL_INCLUDE_DIRS})
				add_definitions(-DCFITSIO_HAVE_CURL)
			endif()
	endif()
endif()
