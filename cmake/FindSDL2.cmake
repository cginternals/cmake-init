
# SDL2::SDL2
# SDL2_FOUND
# SDL2_INCLUDE_DIRS
# SDL2_LIBRARIES

include(FindPackageHandleStandardArgs)

find_package(PkgConfig QUIET)
pkg_check_modules(SDL2 QUIET sdl2)

if(SDL2_FOUND)
  
    add_library(SDL2::SDL2 INTERFACE IMPORTED)

    set_target_properties(SDL2::SDL2 PROPERTIES
      INTERFACE_INCLUDE_DIRECTORIES "${SDL2_INCLUDE_DIRS}"
    )

    set_target_properties(SDL2::SDL2 PROPERTIES
      INTERFACE_LINK_LIBRARIES "${SDL2_LIBRARIES}"
    )
    
endif()

find_package_handle_standard_args(SDL2
  DEFAULT_MSG
  REQUIRED_VARS
    SDL2_INCLUDE_DIRS
    SDL2_LIBRARIES
)

mark_as_advanced(SDL2_FOUND SDL2_INCLUDE_DIRS SDL2_LIBRARIES)
