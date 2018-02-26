
# GLESv2::GLESv2
# GLESv2_FOUND
# GLESv2_INCLUDE_DIR
# GLESv2_LIBRARY

include(FindPackageHandleStandardArgs)

find_path(GLESv2_INCLUDE_DIR GLES2/gl2.h

    PATHS
    $ENV{GLESv2_DIR}
    /usr
    /usr/local
    /sw
    /opt/local

    PATH_SUFFIXES
    /include

    DOC "The directory where GLESv2/GLESv2.h resides")

find_library(GLESv2_LIBRARY NAMES GLESv2

    PATHS
    $ENV{GLESv2_DIR}
    /usr
    /usr/local
    /sw
    /opt/local

    # authors prefered choice for development

    PATH_SUFFIXES
    /lib
    /lib64
    /lib/x86_64-linux-gnu

    DOC "The GLESv2 library")

add_library(GLESv2::GLESv2 SHARED IMPORTED)

set_target_properties(GLESv2::GLESv2 PROPERTIES
  INTERFACE_INCLUDE_DIRECTORIES "${GLESv2_INCLUDE_DIR}"
  INTERFACE_LINK_LIBRARIES "${GLESv2_LIBRARY}"
)

set_property(TARGET GLESv2::GLESv2 APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(GLESv2::GLESv2 PROPERTIES
  IMPORTED_LOCATION_RELEASE "${GLESv2_LIBRARY}"
)

find_package_handle_standard_args(GLESv2 REQUIRED_VARS GLESv2_INCLUDE_DIR GLESv2_LIBRARY)
mark_as_advanced(GLESv2_INCLUDE_DIR GLESv2_LIBRARY)

