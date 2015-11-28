
# 
# Configuration for all sub-projects
# 

# Get project name in upper case
string(TOUPPER ${META_PROJECT_NAME} META_PROJECT_NAME_UPPER)

# Determine data path
if(OPTION_INSTALL)
    if(OPTION_PORTABLE_INSTALL)
        # Configure project to be run from a portable location
        set(DATA_PATH "data")
    else()
        # Configure project to be run from an installed location
        set(DATA_PATH "${CMAKE_INSTALL_PREFIX}/${INSTALL_DATA}/data")
    endif()
else()
    # Configure project to be run from the source tree
    set(DATA_PATH "${CMAKE_SOURCE_DIR}/data")
endif()
message(STATUS "Using data path '${DATA_PATH}'")

# Generate version-header
configure_file(version.h.in ${CMAKE_CURRENT_BINARY_DIR}/include/${META_PROJECT_NAME}/${META_PROJECT_NAME}-version.h)

# Generate meta-header
configure_file(meta.h.in ${CMAKE_CURRENT_BINARY_DIR}/include/${META_PROJECT_NAME}/${META_PROJECT_NAME}-meta.h)


# 
# Sub-projects
# 

# Libraries
set(IDE_FOLDER "")
add_subdirectory(baselib)
add_subdirectory(fiblib)

# Examples
set(IDE_FOLDER "Examples")
add_subdirectory(examples)

# Tests
set(IDE_FOLDER "Tests")
add_subdirectory(tests)


# 
# Deployment
# 

# Deploy generated headers
install(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/include/${META_PROJECT_NAME} DESTINATION include)
