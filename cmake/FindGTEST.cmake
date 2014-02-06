
# GTEST_FOUND
# GTEST_INCLUDE_DIR
# GTEST_LIBRARIES

find_path(GTEST_INCLUDE_DIR gtest/gtest.h
    $ENV{GTESTDIR}/include
    $ENV{GTEST_HOME}/include
    $ENV{GMOCKDIR}/gtest/include
    $ENV{GMOCK_HOME}/gtest/include
    $ENV{PROGRAMFILES}/GTEST/include
    /usr/include
    /usr/local/include
    /sw/include
    /opt/local/include
    DOC "The directory where gtest/gtest.h resides")

find_library(GTEST_LIBRARY
    NAMES gtest
    PATHS
    $ENV{GTESTDIR}/lib
    $ENV{GTEST_HOME}/lib
    $ENV{GTESTDIR}
    $ENV{GTEST_HOME}
    $ENV{GMOCKDIR}/gtest
    $ENV{GMOCK_HOME}/gtest
    /usr/lib64
    /usr/local/lib64
    /sw/lib64
    /opt/local/lib64
    /usr/lib
    /usr/local/lib
    /sw/lib
    /opt/local/lib
    DOC "The GTEST library")

find_library(GTEST_LIBRARY_DEBUG
    NAMES gtestd
    PATHS
    $ENV{GTESTDIR}/lib
    $ENV{GTEST_HOME}/lib
    $ENV{GTESTDIR}
    $ENV{GTEST_HOME}
    $ENV{GMOCKDIR}/gtest
    $ENV{GMOCK_HOME}/gtest
    /usr/lib64
    /usr/local/lib64
    /sw/lib64
    /opt/local/lib64
    /usr/lib
    /usr/local/lib
    /sw/lib
    /opt/local/lib
    DOC "The GTEST debug library")

if (GTEST_LIBRARY AND GTEST_LIBRARY_DEBUG)
	set(GTEST_LIBRARIES "optimized" ${GTEST_LIBRARY} "debug" ${GTEST_LIBRARY_DEBUG})
elseif (GTEST_LIBRARY)
	set(GTEST_LIBRARIES ${GTEST_LIBRARY})
elseif (GTEST_LIBRARY_DEBUG)
	set(GTEST_LIBRARIES ${GTEST_LIBRARY_DEBUG})
else ()
	set(GTEST_LIBRARIES "")
endif ()

find_package_handle_standard_args(GTEST REQUIRED_VARS GTEST_INCLUDE_DIR GTEST_LIBRARIES)
mark_as_advanced(GTEST_INCLUDE_DIR GTEST_LIBRARIES)
