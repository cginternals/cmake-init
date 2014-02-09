
# Generate meta-header
configure_file(template-version.h.in ${CMAKE_CURRENT_BINARY_DIR}/template-version.h)
# we do NOT want to deploy this header
#install(FILES ${CMAKE_CURRENT_BINARY_DIR}/template/template-version.h DESTINATION ${INSTALL_INCLUDE}/template)

# Install data files
install(DIRECTORY ${CMAKE_SOURCE_DIR}/data DESTINATION ${INSTALL_APPLICATIONS})


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
