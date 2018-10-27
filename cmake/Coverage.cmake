
include(${CMAKE_CURRENT_LIST_DIR}/Gcov.cmake)

set(OPTION_COVERAGE_ENABLED OFF)

set(LCOV_EXCLUDE_COVERAGE
    ${LCOV_EXCLUDE_COVERAGE}
    "\"*/googletest/*\""
    "\"*v1*\""
    "\"/usr/*\""
)

# Function to register a target for enabled coverage report
function(generate_coverage_report target)
    if(NOT TARGET coverage)
        add_custom_target(coverage)
    
        set_target_properties(coverage
            PROPERTIES
            FOLDER "Maintenance"
            EXCLUDE_FROM_DEFAULT_BUILD 1
        )
    endif()
    
    if (${OPTION_COVERAGE_ENABLED})
        generate_lcov_report(coverage-${target} ${target} ${ARGN})
        add_dependencies(coverage coverage-${target})
    endif()
endfunction()

# Enable or disable coverage
function(enable_coverage status)
    if(NOT ${status})
        set(OPTION_COVERAGE_ENABLED ${status} PARENT_SCOPE)
        message(STATUS "Coverage lcov skipped: Manually disabled")
        
        return()
    endif()
    
    find_package(lcov)
    
    if(NOT lcov_FOUND)
        set(OPTION_COVERAGE_ENABLED OFF PARENT_SCOPE)
        message(STATUS "Coverage lcov skipped: lcov not found")
        
        return()
    endif()
    
    set(OPTION_COVERAGE_ENABLED ${status} PARENT_SCOPE)
    message(STATUS "Coverage report enabled")
endfunction()
