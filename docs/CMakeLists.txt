
# Check if documenation is enabled
if(NOT OPTION_BUILD_DOCS)
    return()
endif()

# Target 'docs'
add_custom_target(docs)
set_target_properties(docs PROPERTIES EXCLUDE_FROM_DEFAULT_BUILD 1)

# Documentation
add_subdirectory(api-docs)
add_subdirectory(manual)
