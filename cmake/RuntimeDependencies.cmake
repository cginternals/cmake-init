
include(GetPrerequisites)


# 
# Default dependencies for the runtime-package
# 

if(NOT OPTION_SELFCONTAINED_INSTALL)

    # Install 3rd-party runtime dependencies into runtime-component
    # install(FILES ... COMPONENT runtime)

endif()


# 
# Full dependencies for self-contained packages
# 

if(OPTION_SELFCONTAINED_INSTALL)

    # Install 3rd-party runtime dependencies into runtime-component
    # install(FILES ... COMPONENT runtime)

endif()
