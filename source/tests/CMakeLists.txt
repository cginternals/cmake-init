
#
# Configure test project and environment
#

# CMake version
cmake_minimum_required(VERSION 3.0 FATAL_ERROR)

# Meta information about the project
set(META_PROJECT_NAME "template")

# Declare project
project("${META_PROJECT_NAME}-tests" C CXX)

# Set policies
set_policy(CMP0054 NEW) # ENABLE CMP0054: Only interpret if() arguments as variables or keywords when unquoted.
set_policy(CMP0042 NEW) # ENABLE CMP0042: MACOSX_RPATH is enabled by default.
set_policy(CMP0063 NEW) # ENABLE CMP0063: Honor visibility properties for all target types.

# Compiler settings and options

if (EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/../../cmake")
    include(${CMAKE_CURRENT_SOURCE_DIR}/../../cmake/CompileOptions.cmake)
    include(${CMAKE_CURRENT_SOURCE_DIR}/../../cmake/Custom.cmake)
    list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../../cmake")
else()
    include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/CompileOptions.cmake)
    include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/Custom.cmake)
    list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
endif()

# Function: Build test and add command to execute it via target 'test'
function(add_test_without_ctest target)
    add_subdirectory(${target})
    
    if(NOT TARGET ${target})
        return()
    endif()
    
    add_dependencies(test ${target})
    add_custom_command(TARGET test POST_BUILD 
        COMMAND $<TARGET_FILE:${target}> --gtest_output=xml:gtests-${target}.xml
    )

    generate_coverage_report(${target})
endfunction()

find_package(googletest QUIET)

if (NOT TARGET googletest::googletest)
    message(STATUS "Tests skipped: googletest not found")
    return()
endif ()

# 
# Target 'test'
# 

if (${CMAKE_VERSION} VERSION_LESS "3.11")
    set_policy(CMP0037 OLD) # DISABLE CMP0037: Target names should be reserved and should match a validity pattern.
    add_custom_target(test)
    set_target_properties(test PROPERTIES EXCLUDE_FROM_DEFAULT_BUILD 1)
else ()
    if (NOT TARGET test)
        add_custom_target(test)
        set_target_properties(test PROPERTIES EXCLUDE_FROM_DEFAULT_BUILD 1)
    endif()
endif ()


# 
# Tests
# 

add_test_without_ctest(fiblib-test)
