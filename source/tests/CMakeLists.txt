
# 
# Setup test environment
# 

# DISABLE CMP0037: Target names should not be reserved and should match a validity pattern.
if(POLICY CMP0037)
    cmake_policy(SET CMP0037 OLD)
endif()

# Function: Build test and add command to execute it via target 'test'
function(add_test_without_ctest target)
    add_subdirectory(${target})
    add_dependencies(test ${target})
    add_custom_command(TARGET test POST_BUILD 
        COMMAND $<TARGET_FILE:${target}> --gtest_output=xml:gtests-${target}.xml)
endfunction()

# Download and build gmock
ExternalProject_Add(gmock
    URL             "http://googlemock.googlecode.com/files/gmock-1.7.0.zip"
    URL_HASH        "SHA1=f9d9dd882a25f4069ed9ee48e70aff1b53e3c5a5"
    PREFIX          "gmock"
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
    ${GMOCK_SOURCE_DIR}/gtest/include
    ${GMOCK_SOURCE_DIR}/include
)

target_link_libraries(gmock-dev
    INTERFACE
    ${GMOCK_BINARY_DIR}/${CMAKE_STATIC_LIBRARY_PREFIX}gmock${CMAKE_STATIC_LIBRARY_SUFFIX}
)


# 
# Target 'test'
# 

add_custom_target(test)
set_target_properties(test PROPERTIES EXCLUDE_FROM_DEFAULT_BUILD 1)


# 
# Tests
# 

add_test_without_ctest(fiblib-test)
