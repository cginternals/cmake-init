

# Generate meta-header
configure_file(template-version.h.in ${CMAKE_CURRENT_BINARY_DIR}/template-version.h)
# we do NOT want to deploy this header
#install(FILES ${CMAKE_CURRENT_BINARY_DIR}/template/template-version.h DESTINATION ${INSTALL_INCLUDE}/template)

set(APPLICATION_FOLDER "Applications")

install(DIRECTORY ${CMAKE_SOURCE_DIR}/data DESTINATION ${INSTALL_APPLICATIONS})


# Include directories
include_directories(
    ${CMAKE_CURRENT_BINARY_DIR}
)

# LIBRARIES

add_subdirectory(fiblib)
# ...

# APPS

add_subdirectory(fibcmd)
# ...

# TESTS

add_subdirectory(tests)
