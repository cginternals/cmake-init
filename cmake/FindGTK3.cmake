
# GTK3::GTK3
# GTK3_FOUND
# GTK3_INCLUDE_DIRS
# GTK3_LIBRARIES

include(FindPackageHandleStandardArgs)

find_package(PkgConfig QUIET)
pkg_check_modules(GTK3 QUIET gtk+-3.0)

if(GTK3_FOUND) 
    
    add_library(GTK3::GTK3 INTERFACE IMPORTED)

    set_target_properties(GTK3::GTK3 PROPERTIES
      INTERFACE_INCLUDE_DIRECTORIES "${GTK3_INCLUDE_DIRS}"
    )

    set_target_properties(GTK3::GTK3 PROPERTIES
      INTERFACE_LINK_LIBRARIES "${GTK3_LIBRARIES}"
    )
    
endif()

find_package_handle_standard_args(GTK3
  DEFAULT_MSG
  REQUIRED_VARS
    GTK3_FOUND
)

mark_as_advanced(GTK3_FOUND GTK3_INCLUDE_DIRS GTK3_LIBRARIES)
