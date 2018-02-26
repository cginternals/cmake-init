
# EGL::EGL
# EGL_FOUND
# EGL_INCLUDE_DIR
# EGL_LIBRARY

include(FindPackageHandleStandardArgs)

find_path(EGL_INCLUDE_DIR EGL/egl.h

    PATHS
    $ENV{EGL_DIR}
    /usr
    /usr/local
    /sw
    /opt/local

    PATH_SUFFIXES
    /include

    DOC "The directory where EGL/egl.h resides")

find_library(EGL_LIBRARY NAMES EGL

    PATHS
    $ENV{EGL_DIR}
    /usr
    /usr/local
    /sw
    /opt/local

    # authors prefered choice for development

    PATH_SUFFIXES
    /lib
    /lib64
    /lib/x86_64-linux-gnu

    DOC "The EGL library")

add_library(EGL::EGL SHARED IMPORTED)

set_target_properties(EGL::EGL PROPERTIES
  INTERFACE_INCLUDE_DIRECTORIES "${EGL_INCLUDE_DIR}"
  INTERFACE_LINK_LIBRARIES "${EGL_LIBRARY}"
)

set_property(TARGET EGL::EGL APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(EGL::EGL PROPERTIES
  IMPORTED_LOCATION_RELEASE "${EGL_LIBRARY}"
)

find_package_handle_standard_args(EGL REQUIRED_VARS EGL_INCLUDE_DIR EGL_LIBRARY)
mark_as_advanced(EGL_INCLUDE_DIR EGL_LIBRARY)

