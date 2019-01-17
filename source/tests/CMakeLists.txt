
#
# Configure test project and environment
#

# CMake version
cmake_minimum_required(VERSION 3.0 FATAL_ERROR)

# Meta information about the project
set(META_PROJECT_NAME "template")

# Declare project
project("${META_PROJECT_NAME}-tests" C CXX)


# Compiler settings and options

if (EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/../../cmake")
    include(${CMAKE_CURRENT_SOURCE_DIR}/../../cmake/CompileOptions.cmake)
    include(${CMAKE_CURRENT_SOURCE_DIR}/../../cmake/Custom.cmake)
    include(${CMAKE_CURRENT_SOURCE_DIR}/../../cmake/Coverage.cmake)
    include(${CMAKE_CURRENT_SOURCE_DIR}/../../cmake/DownloadProject.cmake)
    list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../../cmake")
else()
    include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/CompileOptions.cmake)
    include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/Custom.cmake)
    include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/Coverage.cmake)
    include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/DownloadProject.cmake)
    list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
endif()

# Set policies
set_policy(CMP0054 NEW) # ENABLE  CMP0054: Only interpret if() arguments as variables or keywords when unquoted.
set_policy(CMP0042 NEW) # ENABLE  CMP0042: MACOSX_RPATH is enabled by default.
set_policy(CMP0063 NEW) # ENABLE  CMP0063: Honor visibility properties for all target types.
set_policy(CMP0037 OLD) # DISABLE CMP0037: Target names should not be reserved and should match a validity pattern.


# Download gtest/gmock (only once at configure time)
download_project(PROJ                googletest
                 SOURCE_DIR          ${CMAKE_CURRENT_LIST_DIR}/googletest-src
                 GIT_REPOSITORY      https://github.com/google/googletest.git
                 GIT_TAG             master
)

# Build gtest/gmock
set(INSTALL_GTEST               OFF CACHE BOOL "")
set(gmock_build_tests           OFF CACHE BOOL "")
set(gtest_build_samples         OFF CACHE BOOL "")
set(gtest_build_tests           OFF CACHE BOOL "")
set(gtest_disable_pthreads      OFF CACHE BOOL "")
set(gtest_force_shared_crt      ON  CACHE BOOL "")
set(gtest_hide_internal_symbols OFF CACHE BOOL "")
add_subdirectory(${googletest_SOURCE_DIR})

# configure gtest/gmock targets
foreach(target gtest gtest_main gmock gmock_main)
    set_target_properties(${target} PROPERTIES
        FOLDER "${IDE_FOLDER}"
        RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}
        LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}
        ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}
        PDB_OUTPUT_DIRECTORY     ${CMAKE_BINARY_DIR}
    )
endforeach()


#
# Target 'test'
#

add_custom_target(test)
set_target_properties(test PROPERTIES EXCLUDE_FROM_DEFAULT_BUILD 1)

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

#
# Tests
#

add_test_without_ctest(fiblib-test)
