
# 
# Default dependencies for the runtime-package
# 

# Install 3rd-party runtime dependencies into runtime-component
# install(FILES ... COMPONENT runtime)


# 
# Full dependencies for self-contained packages
# 

if(OPTION_SELF_CONTAINED)

    # Install 3rd-party runtime dependencies into runtime-component
    # install(FILES ... COMPONENT runtime)

endif()



# Paths to executables
set(apps
    "\${CMAKE_INSTALL_PREFIX}/${INSTALL_BIN}/fibgui${CMAKE_EXECUTABLE_SUFFIX}"
)

# run Bundle utilities
install(CODE "
    include(\"${CMAKE_ROOT}/Modules/GetPrerequisites.cmake\")

    foreach(app ${apps})
        message(\"Dependencies for \${app}\")

        get_prerequisites(\${app} prereqs 1 1 \"\" \"\")
        foreach(lib \${prereqs})
            message(\"- \${lib}\")
        endforeach(lib)
    endforeach(app)
    "
    COMPONENT runtime
)
