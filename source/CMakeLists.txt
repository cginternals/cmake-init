
# 
# Configuration for all sub-projects
# 

# Generate version-header
string(TOUPPER ${META_PROJECT_NAME} META_PROJECT_NAME_UPPER)
configure_file(version.h.in ${CMAKE_CURRENT_BINARY_DIR}/include/${META_PROJECT_NAME}/${META_PROJECT_NAME}-version.h)

# Include files from the binary directory (e.g., auto-generated headers)
include_directories(
    ${CMAKE_CURRENT_BINARY_DIR}
)


# 
# Sub-projects
# 

# Libraries
set(IDE_FOLDER "")
add_subdirectory(baselib)
add_subdirectory(fiblib)

# Applications
set(IDE_FOLDER "Applications")
add_subdirectory(fibcmd)

# Tests
set(IDE_FOLDER "Tests")
#add_subdirectory(tests)


# 
# Deployment
# 

# Deploy generated headers
install(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/include/${META_PROJECT_NAME} DESTINATION include)
