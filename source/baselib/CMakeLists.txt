
# 
# External dependencies
# 

# find_package(THIRDPARTY REQUIRED)


# 
# Library name and options
# 

# Target name
set(target baselib)
message(STATUS "Lib ${target}")

# Exit here if required dependencies are not met

# Export file and macro
string(TOUPPER ${target} target_upper)
set(export_file  "include/${target}/${target}_api.h")
set(export_macro "${target_upper}_API")


# 
# Sources
# 

set(include_path "${CMAKE_CURRENT_SOURCE_DIR}/include/${target}")
set(source_path  "${CMAKE_CURRENT_SOURCE_DIR}/source")

set(headers
    ${include_path}/baselib.h
)

set(sources
    ${source_path}/baselib.cpp
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
install(EXPORT ${target}-export NAMESPACE ${META_PROJECT_NAME}:: DESTINATION cmake/${target})
export (EXPORT ${target}-export NAMESPACE ${META_PROJECT_NAME}::)

# Create export header
generate_export_header(${target}
    EXPORT_FILE_NAME  ${export_file}
    EXPORT_MACRO_NAME ${export_macro}
)


# 
# Includes
# 

target_include_directories(${target}
    PUBLIC
    # Includes that are needed for this project AND for any downstream project using this library

    PRIVATE
    # Includes that are needed internally for this project
    ${PROJECT_BINARY_DIR}/source/include
    ${CMAKE_CURRENT_SOURCE_DIR}/include
    ${CMAKE_CURRENT_BINARY_DIR}/include

    INTERFACE
    # Includes for downstream projects to use this project
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
    $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/include>
    $<INSTALL_INTERFACE:include>
)


# 
# Libraries
# 

target_link_libraries(${target}
    PUBLIC
    # Libraries that are needed for this project AND for any downstream project using this library

    PRIVATE
    # Libraries that are needed internally for this project
#   ${THIRDPARTY_LIBRARY}

    INTERFACE
    # Libraries for downstream projects to use this library
)


# 
# Compile definitions
# 

target_compile_definitions(${target}
    PUBLIC
    # Definitions that are needed for this project AND for any downstream project using this library
    $<$<NOT:$<BOOL:${BUILD_SHARED_LIBS}>>:${target_upper}_STATIC_DEFINE>

    PRIVATE
    # Definitions that are needed internally for this project

    INTERFACE
    # Definitions for downstream projects to use this library
)


# 
# Compile options
# 

set_target_properties(${target}
    PROPERTIES
    POSITION_INDEPENDENT_CODE ON
)

target_compile_options(${target}
    PUBLIC
    # Options that are needed for this project AND for any downstream project using this library

    PRIVATE
    # Options that are needed internally for this project

    INTERFACE
    # Options for downstream projects to use this library
)


# 
# Deployment
# 

# Library
install(TARGETS ${target}
    EXPORT  ${target}-export
    RUNTIME DESTINATION ${INSTALL_BIN}
    LIBRARY DESTINATION ${INSTALL_SHARED}
    ARCHIVE DESTINATION ${INSTALL_LIB}
)

# Header files
install(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/include/${target} DESTINATION ${INSTALL_INCLUDE})

# Generated header files
install(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/include/${target} DESTINATION ${INSTALL_INCLUDE})
