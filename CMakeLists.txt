
# 
# CMake options
# 

# CMake version
cmake_minimum_required(VERSION 3.2 FATAL_ERROR)

# Include cmake modules
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
include(GenerateExportHeader)
include(ExternalProject)
include(cmake/Custom.cmake)
include(cmake/GetGitRevisionDescription.cmake)

# Set policies
set_policy(CMP0028 NEW) # ENABLE  CMP0028: Double colon in target name means ALIAS or IMPORTED target.
set_policy(CMP0054 NEW) # ENABLE  CMP0054: Only interpret if() arguments as variables or keywords when unquoted.
set_policy(CMP0042 OLD) # DISABLE CMP0042: MACOSX_RPATH is enabled by default.


# 
# Project description and (meta) information
# 

# Get git revision
get_git_head_revision(GIT_REFSPEC GIT_SHA1)
string(SUBSTRING "${GIT_SHA1}" 0 12 GIT_REV)

# Meta information about the project
set(META_PROJECT_NAME        "template")
set(META_PROJECT_DESCRIPTION "CMake Project Template")
set(META_AUTHOR_ORGANIZATION "CG Internals GmbH")
set(META_AUTHOR_DOMAIN       "https://github.com/cginternals/cmake-init/")
set(META_AUTHOR_MAINTAINER   "stefan.buschmann@cginternals.com")
set(META_VERSION_MAJOR       "1")
set(META_VERSION_MINOR       "0")
set(META_VERSION_PATCH       "0")
set(META_VERSION_REVISION    "${GIT_REV}")
set(META_VERSION             "${META_VERSION_MAJOR}.${META_VERSION_MINOR}.${META_VERSION_PATCH}")
set(META_NAME_VERSION        "${META_PROJECT_NAME} v${META_VERSION} (${META_VERSION_REVISION})")


# 
# Project configuration options
# 

# Project options
option(BUILD_SHARED_LIBS            "Build shared instead of static libraries."           ON)
option(OPTION_INSTALL               "Build project for installing/packaging."            OFF)
option(OPTION_PORTABLE_INSTALL      "Create a portable (relocatable) install."           OFF)
option(OPTION_SELFCONTAINED_INSTALL "Create a self-contained install with dependencies." OFF)
option(OPTION_BUILD_TESTS           "Build tests (if gmock and gtest are found)."         ON)
option(OPTION_BUILD_DOCS            "Build documentation."                               OFF)
option(OPTION_BUILD_EXAMPLES        "Build examples."                                    OFF)


# 
# Declare project
# 

# Generate folders for IDE targets (e.g., VisualStudio solutions)
set_property(GLOBAL PROPERTY USE_FOLDERS ON)
set(IDE_FOLDER "")  

# Declare project
project(${META_PROJECT_NAME} C CXX)

# Set output directories
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR})
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR})
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR})

# Create version file
file(WRITE "${PROJECT_BINARY_DIR}/VERSION" "${META_NAME_VERSION}")


# 
# Compiler settings and options
# 

include(cmake/CompileOptions.cmake)


# 
# Deployment/installation setup
# 

set(project ${META_PROJECT_NAME})

if("${CMAKE_SYSTEM_NAME}" MATCHES "Windows")
    set(INSTALL_ROOT      ".")                      # C:\Programme\<project>
    set(INSTALL_CMAKE     "cmake")                  # C:\Programme\<project>\cmake
    set(INSTALL_DATA      "bin")                    # C:\Programme\<project>\bin
    set(INSTALL_BIN       "bin")                    # C:\Programme\<project>\bin
    set(INSTALL_SHARED    ".")                      # C:\Programme\<project>
    set(INSTALL_LIB       "lib")                    # C:\Programme\<project>\lib
    set(INSTALL_INCLUDE   "include")                # C:\Programme\<project>\include
    set(INSTALL_DOC       "doc")                    # C:\Programme\<project>\doc
    set(INSTALL_SHORTCUTS ".")                      # Not available under Windows
    set(INSTALL_ICONS     ".")                      # Not available under Windows
    set(INSTALL_INIT      ".")                      # Not available under Windows
else()
    # Unix (Linux or OS X)
    if(OPTION_PORTABLE_INSTALL)
        # Install into a single directory, assuming it is not in the system PATH
        set(INSTALL_ROOT      ".")                      # /<INSTALL_PREFIX>
        set(INSTALL_CMAKE     "cmake")                  # /<INSTALL_PREFIX>/cmake
        set(INSTALL_DATA      ".")                      # /<INSTALL_PREFIX>
        set(INSTALL_BIN       ".")                      # /<INSTALL_PREFIX>
        set(INSTALL_SHARED    "lib")                    # /<INSTALL_PREFIX>/lib
        set(INSTALL_LIB       "lib")                    # /<INSTALL_PREFIX>/lib
        set(INSTALL_INCLUDE   "include")                # /<INSTALL_PREFIX>/include
        set(INSTALL_DOC       "doc")                    # /<INSTALL_PREFIX>/doc
        set(INSTALL_SHORTCUTS "misc")                   # /<INSTALL_PREFIX>/misc
        set(INSTALL_ICONS     "misc")                   # /<INSTALL_PREFIX>/misc
        set(INSTALL_INIT      "misc")                   # /<INSTALL_PREFIX>/misc

        # We have to change the RPATH of binaries to achieve a usable install.
        set(CMAKE_SKIP_BUILD_RPATH FALSE)            # Use automatic rpath for build
        set(CMAKE_BUILD_WITH_INSTALL_RPATH FALSE)    # Use specific rpath for INSTALL
        set(CMAKE_INSTALL_RPATH_USE_LINK_PATH FALSE) # NO automatic rpath for INSTALL

        # Libraries are relative to binary
        if (APPLE)
            set(CMAKE_INSTALL_RPATH "@executable_path/${INSTALL_LIB}")
        else()
            set(CMAKE_INSTALL_RPATH "$ORIGIN/${INSTALL_LIB}")       
        endif()
    else()
        # Install into the system (/usr/bin or /usr/local/bin)
        set(INSTALL_ROOT      "share/${project}")       # /usr/[local]/share/<project>
        set(INSTALL_CMAKE     "share/${project}/cmake") # /usr/[local]/share/<project>
        set(INSTALL_DATA      "share/${project}")       # /usr/[local]/share/<project>
        set(INSTALL_BIN       "bin")                    # /usr/[local]/bin
        set(INSTALL_SHARED    "lib")                    # /usr/[local]/lib
        set(INSTALL_LIB       "lib")                    # /usr/[local]/lib
        set(INSTALL_INCLUDE   "include")                # /usr/[local]/include
        set(INSTALL_DOC       "share/doc/${project}")   # /usr/[local]/share/doc/<project>
        set(INSTALL_SHORTCUTS "share/applications")     # /usr/[local]/share/applications
        set(INSTALL_ICONS     "share/pixmaps")          # /usr/[local]/share/pixmaps
        set(INSTALL_INIT      "/etc/init")              # /etc/init (upstart init scripts)

        if (APPLE)
            set(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}/${INSTALL_LIB}") # Add rpath of project libraries
            set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)                       # Add rpaths of depending libraries
        endif()
    endif()
endif()


# 
# Deployment (global project files)
# 

if(OPTION_INSTALL)

    # Install version file
    install(FILES "${PROJECT_BINARY_DIR}/VERSION" DESTINATION ${INSTALL_ROOT} COMPONENT runtime)

    # Install cmake find script for the project
    install(FILES ${META_PROJECT_NAME}-config.cmake DESTINATION ${INSTALL_ROOT} COMPONENT dev)

    # Install the project meta files
    install(FILES AUTHORS   DESTINATION ${INSTALL_ROOT} COMPONENT runtime)
    install(FILES LICENSE   DESTINATION ${INSTALL_ROOT} COMPONENT runtime)
    install(FILES README.md DESTINATION ${INSTALL_ROOT} COMPONENT runtime)

    # Install runtime data
    install(DIRECTORY ${PROJECT_SOURCE_DIR}/data DESTINATION ${INSTALL_DATA} COMPONENT runtime)

endif()


# 
# Project modules
# 

add_subdirectory(source)
add_subdirectory(docs)
add_subdirectory(deploy)
