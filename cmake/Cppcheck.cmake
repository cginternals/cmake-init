
# Function to register a target for cppcheck
function(perform_cppcheck check_target target)
    get_target_property(INCLUDES ${target} INCLUDE_DIRECTORIES)

    convert_includes(INCLUDES ${INCLUDES})

    add_custom_target(
        ${check_target}
        COMMAND
            cppcheck
                ${INCLUDES}
                --check-config
                --enable=warning,performance,portability,information,missingInclude
                --quiet
                --std=c++11
                --verbose
                --suppress=missingIncludeSystem
                ${ARGN}
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    )
endfunction()
