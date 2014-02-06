
# GMOCK_FOUND
# GMOCK_INCLUDE_DIR
# GMOCK_LIBRARIES

find_path(GMOCK_INCLUDE_DIR gmock/gmock.h
    $ENV{GMOCKDIR}/include
    $ENV{GMOCK_HOME}/include
    $ENV{PROGRAMFILES}/GMOCK/include
    /usr/include
    /usr/local/include
    /sw/include
    /opt/local/include
    DOC "The directory where GMOCK/GMOCK.h resides")

find_library(GMOCK_LIBRARY
    NAMES gmock
    PATHS
    $ENV{GMOCKDIR}/lib
    $ENV{GMOCK_HOME}/lib
    $ENV{GMOCKDIR}
    $ENV{GMOCK_HOME}
    /usr/lib64
    /usr/local/lib64
    /sw/lib64
    /opt/local/lib64
    /usr/lib
    /usr/local/lib
    /sw/lib
    /opt/local/lib
    DOC "The GMOCK library")

find_library(GMOCK_LIBRARY_DEBUG
    NAMES gmockd
    PATHS
    $ENV{GMOCKDIR}/lib
    $ENV{GMOCK_HOME}/lib
    $ENV{GMOCKDIR}
    $ENV{GMOCK_HOME}
    /usr/lib64
    /usr/local/lib64
    /sw/lib64
    /opt/local/lib64
    /usr/lib
    /usr/local/lib
    /sw/lib
    /opt/local/lib
    DOC "The GMOCK debug library")

if (GMOCK_LIBRARY AND GMOCK_LIBRARY_DEBUG)
	set(GMOCK_LIBRARIES "optimized" ${GMOCK_LIBRARY} "debug" ${GMOCK_LIBRARY_DEBUG})
elseif (GMOCK_LIBRARY)
	set(GMOCK_LIBRARIES ${GMOCK_LIBRARY})
elseif (GMOCK_LIBRARY_DEBUG)
	set(GMOCK_LIBRARIES ${GMOCK_LIBRARY_DEBUG})
else ()
	set(GMOCK_LIBRARIES "")
endif ()

find_package_handle_standard_args(GMOCK REQUIRED_VARS GMOCK_INCLUDE_DIR GMOCK_LIBRARIES)
mark_as_advanced(GMOCK_INCLUDE_DIR GMOCK_LIBRARIES)
