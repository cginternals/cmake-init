
#mkdir build/coverage
#lcov -d build/source/tests/fiblib-test/CMakeFiles/fiblib-test.dir -c -o build/coverage/fiblib-test.info
#genhtml -o build/coverage/html build/coverage/fiblib-test.info


# Function to register a target for coverage
function(generate_lcov_report coverage_target target)
    if(NOT TARGET coverage-init)
        add_custom_target(
            coverage-init
            COMMAND
                ${lcov_EXECUTABLE}
                    --directory ${CMAKE_CURRENT_BINARY_DIR}
                    --zerocounters
                    -q
            WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        )

        add_custom_target(
            coverage-info
            COMMAND
                ${lcov_EXECUTABLE}
                    --directory ${CMAKE_CURRENT_BINARY_DIR}
                    --capture
                    --output-file ${CMAKE_CURRENT_BINARY_DIR}/coverage.info
                    -q
            WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
            BYPRODUCTS ${CMAKE_CURRENT_BINARY_DIR}/coverage.info
        )

        add_custom_target(
            coverage-clean
            COMMAND
                ${lcov_EXECUTABLE}
                    --directory ${CMAKE_CURRENT_BINARY_DIR}
                    --remove ${CMAKE_CURRENT_BINARY_DIR}/coverage.info
                    ${EXCLUDE_COVERAGE}
                    --output-file ${CMAKE_CURRENT_BINARY_DIR}/coverage-clean.info
                    -q
            WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
            DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/coverage.info
            BYPRODUCTS ${CMAKE_CURRENT_BINARY_DIR}/coverage-clean.info
        )

        add_custom_target(
            coverage-report
            COMMAND
                ${genhtml_EXECUTABLE}
                    --output-directory ${CMAKE_CURRENT_BINARY_DIR}/coverage 
                    --title "cmake-init test coverage"
                    --num-spaces 4 
                    ${CMAKE_CURRENT_BINARY_DIR}/coverage-clean.info
            WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
            DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/coverage-clean.info
        )

        add_dependencies(coverage coverage-report)
    endif()

    add_custom_target(${coverage_target}
        COMMAND $<TARGET_FILE:${target}> --gtest_output=xml:gtests-${target}.xml
        DEPENDS ${target}
    )
    add_dependencies(${coverage_target} coverage-init)
    add_dependencies(coverage-info ${coverage_target})

endfunction()
