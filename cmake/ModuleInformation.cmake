
# Add build step to target that creates a module information file alongside a library
function(add_module_info TARGET INFILE)

    add_custom_target("${TARGET}-modinfo" ALL
        COMMAND ${CMAKE_COMMAND}
                "-DMODULE_INFILE=${INFILE}"
                "-DMODULE_OUTFILE=$<TARGET_FILE_DIR:${TARGET}>/${TARGET}-module.json"
                "-DMODULE_NAME=${MODULE_NAME}"
                "-DMODULE_VERSION=${MODULE_VERSION}"
                "-DMODULE_DESCRIPTION=${MODULE_DESCRIPTION}"
                "-DMODULE_AUTHOR=${MODULE_AUTHOR}"
                "-DMODULE_TYPE=${MODULE_TYPE}"
                "-DMODULE_DATA_DIR=${MODULE_DATA_DIR}"
                -P "${PROJECT_SOURCE_DIR}/cmake/ConfigureModule.cmake"
        DEPENDS "${PROJECT_SOURCE_DIR}/cmake/ConfigureModule.cmake" "${INFILE}"
        COMMENT "Configuring ${TARGET}-module.json"
        VERBATIM)

endfunction(add_module_info)


# Generate module information file at configure-time, usually used for installation
function(generate_module_info INFILE OUTFILE)

    configure_file("${INFILE}" "${OUTFILE}")

endfunction(generate_module_info)
