
# 
# Setup test environment
# 

# Check if tests are enabled
if(NOT OPTION_BUILD_TESTS)
    return()
endif()

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

# Build gmock
set(gmock_build_tests           OFF CACHE BOOL "")
set(gtest_build_samples         OFF CACHE BOOL "")
set(gtest_build_tests           OFF CACHE BOOL "")
set(gtest_disable_pthreads      OFF CACHE BOOL "")
set(gtest_force_shared_crt      OFF CACHE BOOL "")
set(gtest_hide_internal_symbols ON CACHE BOOL "")
add_subdirectory(googletest)

set(GMOCK_INCLUDE_DIRECTORIES
    ${PROJECT_SOURCE_DIR}/source/tests/googletest/googletest/include
    ${PROJECT_SOURCE_DIR}/source/tests/googletest/googlemock/include
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
