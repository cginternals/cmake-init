
# This config script tries to locate a project in an installed location.


# Macro for loading a target configuration if it exists
macro(include_config_script PREFIX FILENAME)
    set(filename "${CMAKE_CURRENT_LIST_DIR}/${PREFIX}/${FILENAME}")
    if(EXISTS "${filename}")
        include("${filename}")
    endif()
endmacro()


# Find project in installed location

set(prefix "cmake")
include("${CMAKE_CURRENT_LIST_DIR}/template-files.cmake")
