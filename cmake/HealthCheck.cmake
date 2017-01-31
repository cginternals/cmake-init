
include(${CMAKE_CURRENT_LIST_DIR}/Cppcheck.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/ClangTidy.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/Uncrustify.cmake)

set(OPTION_CPPCHECK_ENABLED Off)
set(OPTION_CLANG_TIDY_ENABLED Off)
set(OPTION_UNCRUSTIFY_ENABLED Off)

# Function to register a target for enabled health checks
function(perform_health_checks target)
    if(NOT TARGET check-all)
        add_custom_target(check-all)
    endif()
    
    add_custom_target(check-${target})
    
    if (OPTION_CPPCHECK_ENABLED)
        perform_cppcheck(cppcheck-${target} ${target} ${ARGN})
        add_dependencies(check-${target} cppcheck-${target})
    endif()
    
    if (OPTION_CLANG_TIDY_ENABLED)
        perform_clang_tidy(clang-tidy-${target} ${target} ${ARGN})
        add_dependencies(check-${target} clang-tidy-${target})
    endif()
    
    if (OPTION_UNCRUSTIFY_ENABLED)
        perform_uncrustify(uncrustify-${target} ${target} ${ARGN})
        add_dependencies(check-${target} uncrustify-${target})
    endif()
    
    add_dependencies(check-all check-${target})
endfunction()

# Enable or disable cppcheck for health checks
function(enable_cppcheck status)
    set(OPTION_CPPCHECK_ENABLED ${status} PARENT_SCOPE)
endfunction()

# Enable or disable clang-tidy for health checks
function(enable_clang_tidy status)
    set(OPTION_CLANG_TIDY_ENABLED ${status} PARENT_SCOPE)
    
    if(${CMAKE_VERSION} VERSION_GREATER "3.5" AND NOT CMAKE_EXPORT_COMPILE_COMMANDS)
        message(STATUS "clang-tidy makes use of the compile commands database. Make sure to configure CMake with -DCMAKE_EXPORT_COMPILE_COMMANDS=ON")
    endif()
endfunction()

# Enable or disable uncrustify for health checks
function(enable_uncrustify status)
    set(OPTION_UNCRUSTIFY_ENABLED ${status} PARENT_SCOPE)
endfunction()