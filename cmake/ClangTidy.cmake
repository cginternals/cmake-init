
# Function to register a target for clang-tidy
function(perform_clang_tidy check_target target)
    set(clang_tidy_command "clang-tidy-3.8")
    
    get_target_property(INCLUDES ${target} INCLUDE_DIRECTORIES)

    convert_includes(INCLUDES ${INCLUDES})

    add_custom_target(
        ${check_target}
        COMMAND
            ${clang_tidy_command}
                ${ARGN}
                -checks=*
                -- ${INCLUDES}
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    )
endfunction()
