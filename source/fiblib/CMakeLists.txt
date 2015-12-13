
# 
# External dependencies
# 

# find_package(THIRDPARTY REQUIRED)


# 
# Library name and options
# 

# Target name
set(target fiblib)

# Exit here if required dependencies are not met
message(STATUS "Lib ${target}")

# Set API export file and macro
string(TOUPPER ${target} target_upper)
set(export_file  "include/${target}/${target}_api.h")
set(export_macro "${target_upper}_API")


# 
# Sources
# 

set(include_path "${CMAKE_CURRENT_SOURCE_DIR}/include/${target}")
set(source_path  "${CMAKE_CURRENT_SOURCE_DIR}/source")

set(headers
    ${include_path}/Fibonacci.h
)

set(sources
    ${source_path}/Fibonacci.cpp
)

# Group source files
set(header_group "Header Files (API)")
set(source_group "Source Files")
source_group_by_path(${include_path} "\\\\.h$|\\\\.hpp$" 
    ${header_group} ${headers})
source_group_by_path(${source_path}  "\\\\.cpp$|\\\\.c$|\\\\.h$|\\\\.hpp$" 
    ${source_group} ${sources})


# 
# Create library
# 

# Build library
add_library(${target}
    ${sources}
    ${headers}
)

# Create namespaced alias
add_library(${META_PROJECT_NAME}::${target} ALIAS ${target})

# Export library for downstream projects
export(TARGETS ${target} NAMESPACE ${META_PROJECT_NAME}:: FILE ${PROJECT_BINARY_DIR}/cmake/${target}/${target}-export.cmake)

# Create API export header
generate_export_header(${target}
    EXPORT_FILE_NAME  ${export_file}
    EXPORT_MACRO_NAME ${export_macro}
)


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
    PRIVATE    # Includes that are needed internally for this project
    ${PROJECT_BINARY_DIR}/source/include
    ${CMAKE_CURRENT_SOURCE_DIR}/include
    ${CMAKE_CURRENT_BINARY_DIR}/include

    PUBLIC     # Includes that are needed for this project AND for any downstream project using this library
    ${DEFAULT_INCLUDE_DIRECTORIES}

    INTERFACE  # Includes for downstream projects to use this project
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
    $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/include>
    $<INSTALL_INTERFACE:include>
)


# 
# Libraries
# 

target_link_libraries(${target}
    PRIVATE    # Libraries that are needed internally for this project

    PUBLIC     # Libraries that are needed for this project AND for any downstream project using this library
    ${DEFAULT_LIBRARIES}

    INTERFACE  # Libraries for downstream projects to use this library
)


# 
# Compile definitions
# 

target_compile_definitions(${target}
    PRIVATE    # Definitions that are needed internally for this project

    PUBLIC     # Definitions that are needed for this project AND for any downstream project using this library
    $<$<NOT:$<BOOL:${BUILD_SHARED_LIBS}>>:${target_upper}_STATIC_DEFINE>
    ${DEFAULT_COMPILE_DEFINITIONS}

    INTERFACE  # Definitions for downstream projects to use this library
)


# 
# Compile options
# 

target_compile_options(${target}
    PRIVATE    # Options that are needed internally for this project

    PUBLIC     # Options that are needed for this project AND for any downstream project using this library
    ${DEFAULT_COMPILE_OPTIONS}

    INTERFACE  # Options for downstream projects to use this library
)


# 
# Linker options
# 

target_link_libraries(${target}
    PRIVATE    # Options that are needed internally for this project

    PUBLIC     # Options that are needed for this project AND for any downstream project using this library
    ${DEFAULT_LINKER_OPTIONS}

    INTERFACE  # Options for downstream projects to use this library
)


# 
# Module information file
# 

# Set module information
set(MODULE_NAME        "${target}")
set(MODULE_VERSION     "${META_VERSION}")
set(MODULE_DESCRIPTION "${META_PROJECT_DESCRIPTION}")
set(MODULE_AUTHOR      "${META_AUTHOR_ORGANIZATION}")
set(MODULE_TYPE        "Plugin")

# Generate module-info for build tree
set(MODULE_DATA_DIR "${PROJECT_SOURCE_DIR}/data")
add_module_info(${target} "${CMAKE_CURRENT_SOURCE_DIR}/${target}-module.json.in")

# Generate module-info for installation
set(MODULE_DATA_DIR "${CMAKE_INSTALL_PREFIX}/${INSTALL_DATA}/data")
generate_module_info(
    "${CMAKE_CURRENT_SOURCE_DIR}/${target}-module.json.in"
    "${PROJECT_BINARY_DIR}/${target}-module.install.json")


# 
# Deployment
# 

# Library
install(TARGETS ${target}
    EXPORT  "${target}-export"            COMPONENT dev
    RUNTIME DESTINATION ${INSTALL_BIN}    COMPONENT runtime
    LIBRARY DESTINATION ${INSTALL_SHARED} COMPONENT runtime
    ARCHIVE DESTINATION ${INSTALL_LIB}    COMPONENT dev
)

# Header files
install(DIRECTORY
    ${CMAKE_CURRENT_SOURCE_DIR}/include/${target} DESTINATION ${INSTALL_INCLUDE}
    COMPONENT dev
)

# Generated header files
install(DIRECTORY
    ${CMAKE_CURRENT_BINARY_DIR}/include/${target} DESTINATION ${INSTALL_INCLUDE}
    COMPONENT dev
)

# CMake config
install(EXPORT ${target}-export
    NAMESPACE   ${META_PROJECT_NAME}::
    DESTINATION ${INSTALL_CMAKE}/${target}
    COMPONENT   dev
)
