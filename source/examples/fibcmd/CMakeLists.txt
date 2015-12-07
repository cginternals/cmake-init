
# 
# External dependencies
# 

# find_package(THIRDPARTY REQUIRED)


# 
# Executable name and options
# 

# Target name
set(target fibcmd)

# Exit here if required dependencies are not met
message(STATUS "App ${target}")


# 
# Sources
# 

set(sources
    main.cpp
)


# 
# Create executable
# 

# Build executable
add_executable(${target}
    MACOSX_BUNDLE
    ${sources}
)

# Create namespaced alias
add_executable(${META_PROJECT_NAME}::${target} ALIAS ${target})


# 
# Project options
# 

set_target_properties(${target}
    PROPERTIES
    ${DEFAULT_PROJECT_OPTIONS}
    FOLDER                     "${IDE_FOLDER}"
    DEBUG_POSTFIX              "d"
    CXX_STANDARD               11
    LINKER_LANGUAGE            CXX
    POSITION_INDEPENDENT_CODE  ON
)


# 
# Include directories
# 

target_include_directories(${target}
    PRIVATE
    ${DEFAULT_INCLUDE_DIRECTORIES}
    ${PROJECT_BINARY_DIR}/source/include
)


# 
# Libraries
# 

target_link_libraries(${target}
    PRIVATE
    ${DEFAULT_LIBRARIES}
    template::baselib
    template::fiblib
)


# 
# Compile definitions
# 

target_compile_definitions(${target}
    PRIVATE
    ${DEFAULT_COMPILE_DEFINITIONS}
)


# 
# Compile options
# 

target_compile_options(${target}
    PRIVATE
    ${DEFAULT_COMPILE_OPTIONS}
)


# 
# Linker options
# 

target_link_libraries(${target}
    PRIVATE
    ${DEFAULT_LINKER_OPTIONS}
)


# 
# Deployment
# 

if(OPTION_INSTALL)

    # Executable
    install(TARGETS ${target}
        RUNTIME DESTINATION ${INSTALL_BIN} COMPONENT examples
        BUNDLE  DESTINATION ${INSTALL_BIN} COMPONENT examples
    )

endif()
