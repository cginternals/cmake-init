
# TRDP_FOUND
# TRDP_INCLUDE_DIR
# TRDP_LIBRARY
# TRDP_BINARY  # for install target

find_path(TRDP_INCLUDE_DIR 3rdp/3rdp.h
    $ENV{TRDPDIR}/include
    $ENV{TRDP_HOME}/include
    $ENV{PROGRAMFILES}/TRDP/include
    /usr/include
    /usr/local/include
    /sw/include
    /opt/local/include
    DOC "The directory where 3rdp/3rdp.h resides")

find_library(TRDP_LIBRARY
    NAMES 3RDP 3rdp
    PATHS
    $ENV{TRDPDIR}/lib
    $ENV{TRDP_HOME}/lib
    /usr/lib64
    /usr/local/lib64
    /sw/lib64
    /opt/local/lib64
    /usr/lib
    /usr/local/lib
    /sw/lib
    /opt/local/lib
    DOC "The TRDP library")

if(WIN32)

    find_file(TRDP_BINARY
        NAMES 3rdp.dll
        PATHS
        $ENV{TRDPDIR}/bin
        $ENV{TRDP_HOME}/bin
        DOC "The TRDP binary")

endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(TRDP REQUIRED_VARS TRDP_INCLUDE_DIR TRDP_LIBRARY)
mark_as_advanced(TRDP_INCLUDE_DIR TRDP_LIBRARY)
