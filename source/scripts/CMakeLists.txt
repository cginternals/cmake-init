
#
# Add project health scripts as cmake targets
#

add_custom_target(
    check-template
    COMMAND ${CMAKE_COMMAND}
        -DPROJECT_SOURCE_DIR=${PROJECT_SOURCE_DIR}
        -DPROJECT_BINARY_DIR=${PROJECT_BINARY_DIR}
        -DAPPLIED_CMAKE_INIT_SHA=${META_CMAKE_INIT_SHA}
        -P ${PROJECT_SOURCE_DIR}/cmake/CheckTemplate.cmake
    WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
)
