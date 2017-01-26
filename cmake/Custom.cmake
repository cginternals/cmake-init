
# Set policy if policy is available
function(set_policy POL VAL)

    if(POLICY ${POL})
        cmake_policy(SET ${POL} ${VAL})
    endif()

endfunction(set_policy)


# Converts a list of include paths to their -I ... command line list
#
# Example:
# convert_includes(RESULT "include1;include2;include3")
# Result:
# -I include1 -I include2 -I include3
function(convert_includes var)
   set(listVar "")
   foreach(include ${ARGN})
      list(APPEND listVar "-I${include}")
   endforeach()
   set(${var} "${listVar}" PARENT_SCOPE)
endfunction()


# Define function "source_group_by_path with three mandatory arguments (PARENT_PATH, REGEX, GROUP, ...)
# to group source files in folders (e.g. for MSVC solutions).
#
# Example:
# source_group_by_path("${CMAKE_CURRENT_SOURCE_DIR}/src" "\\\\.h$|\\\\.inl$|\\\\.cpp$|\\\\.c$|\\\\.ui$|\\\\.qrc$" "Source Files" ${sources})
function(source_group_by_path PARENT_PATH REGEX GROUP)

    foreach (FILENAME ${ARGN})
        
        get_filename_component(FILEPATH "${FILENAME}" REALPATH)
        file(RELATIVE_PATH FILEPATH ${PARENT_PATH} ${FILEPATH})
        get_filename_component(FILEPATH "${FILEPATH}" DIRECTORY)

        string(REPLACE "/" "\\" FILEPATH "${FILEPATH}")

	source_group("${GROUP}\\${FILEPATH}" REGULAR_EXPRESSION "${REGEX}" FILES ${FILENAME})

    endforeach()

endfunction(source_group_by_path)


# Function that extract entries matching a given regex from a list.
# ${OUTPUT} will store the list of matching filenames.
function(list_extract OUTPUT REGEX)

    foreach(FILENAME ${ARGN})
        if(${FILENAME} MATCHES "${REGEX}")
            list(APPEND ${OUTPUT} ${FILENAME})
        endif()
    endforeach()

    set(${OUTPUT} ${${OUTPUT}} PARENT_SCOPE)

endfunction(list_extract)


# Function to register a target for cppcheck
function(enable_cppcheck target)
    if(NOT TARGET cppcheck-all)
        add_custom_target(cppcheck-all)
    endif()
    
    get_target_property(INCLUDES ${target} INCLUDE_DIRECTORIES)

    convert_includes(INCLUDES ${INCLUDES})

    add_custom_target(
        cppcheck-${target}
        COMMAND
            cppcheck
                ${INCLUDES}
                --check-config
                --enable=warning,performance,portability,information,missingInclude
                --quiet
                --std=c++11
                --verbose
                --suppress=missingIncludeSystem
                ${ARGN}
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    )
    
    add_dependencies(cppcheck-all cppcheck-${target})
endfunction()
