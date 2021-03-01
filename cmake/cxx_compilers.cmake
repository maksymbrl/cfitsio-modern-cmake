# File contains compiler definitions, flags, etc.

# TODO: Check Makefile and add compielr flags for Intel, GNU GCC, PGI, Clang etc.
# Intel
if(CMAKE_CXX_COMPILER_ID MATCHES Intel)
	#string(APPEND CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE}" "-fpe0")
	set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE}")
endif()

message(STATUS ${CMAKE_CXX_COMPILER_ID})
message(${CMAKE_CXX_FLAGS_RELEASE})
message(${CMAKE_CXX_FLAGS_RELWITHDEBINFO})
message(${CMAKE_CXX_FLAGS_DEBUG})
message(${CMAKE_CXX_FLAGS_MINSIZEREL})
