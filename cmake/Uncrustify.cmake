
# Function to register a target for cppcheck
function(perform_uncrustify check_target target)
    add_custom_target(
        ${check_target}
    )
endfunction()
