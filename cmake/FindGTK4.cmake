
# GTK4::GTK4
# GTK4_FOUND
# GTK4_INCLUDE_DIRS
# GTK4_LIBRARIES

include(FindPackageHandleStandardArgs)

find_package(PkgConfig QUIET)
pkg_check_modules(GTK4 QUIET IMPORTED_TARGET gtk4)

set(GTK4_FOUND OFF)

if(TARGET PkgConfig::GTK4)
  set(GTK4_FOUND ON)

  add_library(GTK4::GTK4 INTERFACE IMPORTED)

  set_target_properties(GTK4::GTK4 PROPERTIES
    INTERFACE_LINK_LIBRARIES PkgConfig::GTK4
  )

endif()

find_package_handle_standard_args(GTK4
  DEFAULT_MSG
  REQUIRED_VARS
    GTK4_FOUND
)
mark_as_advanced(GTK4_FOUND)
