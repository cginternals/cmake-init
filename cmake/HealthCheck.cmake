
include(${CMAKE_CURRENT_LIST_DIR}/Cppcheck.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/ClangFormat.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/Uncrustify.cmake)

set(OPTION_CPPCHECK_ENABLED Off)
set(OPTION_CLANG_FORMAT_ENABLED Off)
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
    
    if (OPTION_CLANG_FORMAT_ENABLED)
        perform_clang_format(clang-format-${target} ${target} ${ARGN})
        add_dependencies(check-${target} clang-format-${target})
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

# Enable or disable clang-format for health checks
function(enable_clang_format status)
    set(OPTION_CLANG_FORMAT_ENABLED ${status} PARENT_SCOPE)
endfunction()

# Enable or disable uncrustify for health checks
function(enable_uncrustify status)
    set(OPTION_UNCRUSTIFY_ENABLED ${status} PARENT_SCOPE)
endfunction()