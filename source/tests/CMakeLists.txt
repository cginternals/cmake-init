
include(ExternalProject)


# Check if tests are enabled
if(NOT OPTION_BUILD_TESTS)
    return()
endif()

# This policy was introduced in 3.0.0 and does not allow targets named "test" or "help" ...
# Since we do not rely on cmake testing we stick to the old policy for now.
if(POLICY CMP0037)
    cmake_policy(SET CMP0037 OLD)
endif()

# Function: Build test and add command to execute it via target 'test'
function(add_test_without_ctest target)
    add_subdirectory(${target})
    add_dependencies(test ${target})
    add_custom_command(TARGET test POST_BUILD 
        COMMAND $<TARGET_FILE:${target}> --gtest_output=xml:gtests.xml)
endfunction()

# Download and build gmock
ExternalProject_Add(gmock
    URL             "http://googlemock.googlecode.com/files/gmock-1.7.0.zip"
    URL_HASH        "SHA1=f9d9dd882a25f4069ed9ee48e70aff1b53e3c5a5"
    INSTALL_COMMAND ""
)

ExternalProject_Get_Property(gmock source_dir)
set(GMOCK_SOURCE_DIR "${source_dir}")

ExternalProject_Get_Property(gmock binary_dir)
set(GMOCK_BINARY_DIR "${binary_dir}")

# Create interface library to link against gmock
add_library(gmock-dev INTERFACE)

target_include_directories(gmock-dev
    INTERFACE
    ${GMOCK_SOURCE_DIR}/include
)

target_link_libraries(gmock-dev
    INTERFACE
    ${GMOCK_BINARY_DIR}/${CMAKE_STATIC_LIBRARY_PREFIX}gmock${CMAKE_STATIC_LIBRARY_SUFFIX}
    pthread
)

# Download and build gtest
ExternalProject_Add(gtest
    URL             "http://googletest.googlecode.com/files/gtest-1.7.0.zip"
    URL_HASH        "SHA1=f85f6d2481e2c6c4a18539e391aa4ea8ab0394af"
    INSTALL_COMMAND ""
)

ExternalProject_Get_Property(gtest source_dir)
set(GTEST_SOURCE_DIR "${source_dir}")

ExternalProject_Get_Property(gtest binary_dir)
set(GTEST_BINARY_DIR "${binary_dir}")

# Create interface library to link against gtest
add_library(gtest-dev INTERFACE)

target_include_directories(gtest-dev
    INTERFACE
    ${GTEST_SOURCE_DIR}/include
)

target_link_libraries(gtest-dev
    INTERFACE
    ${GTEST_BINARY_DIR}/${CMAKE_STATIC_LIBRARY_PREFIX}gtest${CMAKE_STATIC_LIBRARY_SUFFIX}
    pthread
)

# Target 'test'
add_custom_target(test)
set_target_properties(test PROPERTIES EXCLUDE_FROM_DEFAULT_BUILD 1)

# Tests
add_test_without_ctest(fiblib-test)
