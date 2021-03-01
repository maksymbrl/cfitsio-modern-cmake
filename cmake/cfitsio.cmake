#==============================================================================
# It is better to not use GLOB feature but explicitly put all sources...
#file(GLOB H_FILES "${CFITSIO_SRC_DIR}/*.h")
set(H_FILES
		${CFITSIO_SRC_DIR}/cfortran.h
		${CFITSIO_SRC_DIR}/drvrsmem.h
		${CFITSIO_SRC_DIR}/eval_tab.h
		${CFITSIO_SRC_DIR}/fitsio.h
		${CFITSIO_SRC_DIR}/fpack.h
		${CFITSIO_SRC_DIR}/grparser.h
		${CFITSIO_SRC_DIR}/region.h
		${CFITSIO_SRC_DIR}/drvrgsiftp.h
		${CFITSIO_SRC_DIR}/eval_defs.h
		${CFITSIO_SRC_DIR}/f77_wrap.h
		${CFITSIO_SRC_DIR}/fitsio2.h
		${CFITSIO_SRC_DIR}/group.h
		${CFITSIO_SRC_DIR}/longnam.h
		${CFITSIO_SRC_DIR}/simplerng.h
	)
# Adding CFitsIO source files
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
	# Adding Zlib source files
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
	# Adding Zlib headers
	set(H_FILES ${H_FILES}
			${ZLIB_SRC_DIR}/crc32.h
			${ZLIB_SRC_DIR}/inffast.h
			${ZLIB_SRC_DIR}/inflate.h
			${ZLIB_SRC_DIR}/trees.h
			${ZLIB_SRC_DIR}/zlib.h
			${ZLIB_SRC_DIR}/deflate.h
			${ZLIB_SRC_DIR}/inffixed.h
			${ZLIB_SRC_DIR}/inftrees.h
			${ZLIB_SRC_DIR}/zconf.h
			${ZLIB_SRC_DIR}/zutil.h
		)
endif()

#==============================================================================
add_library(${LIB_NAME} ${LIB_TYPE} ${H_FILES} ${SRC_FILES})
# Linking PThreads if it is present
if(Threads_FOUND)
	target_link_libraries(${LIB_NAME} Threads::Threads)
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
# Installing CFitsIO library into following destinations
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
