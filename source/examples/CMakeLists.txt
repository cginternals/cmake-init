
# Example applications
if(NOT OPTION_BUILD_EXAMPLES)
    return()
endif()

add_subdirectory(fibcmd)
add_subdirectory(fibgui)
