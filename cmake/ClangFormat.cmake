
# Function to register a target for cppcheck
function(perform_clang_format check_target target)
    add_custom_target(
        ${check_target}
    )
endfunction()
