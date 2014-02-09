
# Generate meta-header
configure_file(template-version.h.in ${CMAKE_CURRENT_BINARY_DIR}/template-version.h)

# We do NOT want to deploy this header (at least not for binary packages)
#install(FILES ${CMAKE_CURRENT_BINARY_DIR}/template/template-version.h DESTINATION ${INSTALL_INCLUDE}/template)


# Include directories
include_directories(
    ${CMAKE_CURRENT_BINARY_DIR}
)


# Libraries
set(IDE_FOLDER "")
add_subdirectory(fiblib)

# Applications
set(IDE_FOLDER "Applications")
add_subdirectory(fibcmd)

# Tests
add_subdirectory(tests)
