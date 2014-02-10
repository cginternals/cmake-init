
# Macro: Build test and add command to execute it via target 'test'
macro(add_test_without_ctest target)

    add_subdirectory(${target})

    add_dependencies(test ${target})
    add_custom_command(TARGET test POST_BUILD 
        COMMAND cmake -E echo
        COMMAND cmake -E echo run $<TARGET_FILE:${target}>:
        COMMAND $<TARGET_FILE:${target}>)

endmacro()

# Design decision: tests are enabled by default. If the required components are not found,
# tests are disabled and a warning is printed, but configuration is still valid.
if(OPTION_BUILD_TESTS)
    find_package(GMOCK)
    find_package(GTEST)
    if(NOT GMOCK_FOUND OR NOT GTEST_FOUND)
        message(STATUS "Disabled tests (missing gmock and/or gtest)")
    endif()
endif()

# Check if tests are enabled
if(OPTION_BUILD_TESTS AND GMOCK_FOUND AND GTEST_FOUND)

    # Include gmock and gtest
    include_directories(
        ${GMOCK_INCLUDE_DIR}
        ${GTEST_INCLUDE_DIR}
    )

    # Target 'test'
    add_custom_target(test)
    set_target_properties(test PROPERTIES EXCLUDE_FROM_DEFAULT_BUILD 1)

    # Tests
    set(IDE_FOLDER "Tests")
    add_test_without_ctest(fiblib-test)

endif()
