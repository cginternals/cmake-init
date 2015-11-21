
# 
# CMake options
# 

# CMake version
cmake_minimum_required(VERSION 3.0 FATAL_ERROR)

# ENABLE CMP0028: Double colon in target name means ALIAS or IMPORTED target.
if (POLICY CMP0028)
    cmake_policy(SET CMP0028 NEW)
endif()

# Add include path to custom cmake modules
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

# Include cmake modules
include(GenerateExportHeader)
include(cmake/Custom.cmake)
#include(cmake/GitRevision.cmake)


# 
# Project description and (meta) information
# 

# Meta information about the project
set(META_PROJECT_NAME        "template")
set(META_PROJECT_DESCRIPTION "CMake Project Template")
set(META_VERSION_MAJOR       "2")
set(META_VERSION_MINOR       "0")
set(META_VERSION_PATCH       "0")
set(META_VERSION             "${META_VERSION_MAJOR}.${META_VERSION_MINOR}.${META_VERSION_PATCH}")
set(META_AUTHOR_ORGANIZATION "cginternals GmbH")
set(META_AUTHOR_DOMAIN       "https://github.com/cginternals/cmake-init/")
set(META_AUTHOR_MAINTAINER   "stefan.buschmann@cginternals.com")


# 
# Project configuration options
# 

# Project options
option(BUILD_SHARED_LIBS        "Build shared instead of static libraries."    ON)
option(OPTION_PORTABLE_INSTALL  "Install into a self-contained directory."    OFF)
option(OPTION_BUILD_TESTS       "Build tests (if gmock and gtest are found)."  ON)


# 
# Declare project
# 

# Limit supported configuration types
set(CMAKE_CONFIGURATION_TYPES "Debug;Release" CACHE STRING "Limited Configs" FORCE)

# Set output directories
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR})
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR})
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR})

# Generate folders for IDE targets (e.g., VisualStudio solutions)
set_property(GLOBAL PROPERTY USE_FOLDERS ON)
set(IDE_FOLDER "")  

# Declare project
project(${META_PROJECT_NAME} C CXX)


# 
# Platform and architecture setup
# 

# Architecture (32/64 bit)
set(X64 OFF)
if(CMAKE_SIZEOF_VOID_P EQUAL 8)
    set(X64 ON)
endif()

# Load configuration for the specific platform (compile flags, etc.)
#if(MSVC)
#    include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/PlatformWindowsMSVC.cmake)
#elseif(WIN32 AND CMAKE_COMPILER_IS_GNUCXX)
#    include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/PlatformWindowsGCC.cmake)
#elseif(APPLE)
#    include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/PlatformMacOS.cmake)
#elseif(UNIX)
#    include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/PlatformLinuxGCC.cmake)
#else()
#    message(WARNING "Unsupported platform/compiler combination")
#endif()


# 
# Deployment/installation setup
# 

set(project ${META_PROJECT_NAME})

if(WIN32)
    set(INSTALL_ROOT      ".")                      # C:\Programme\<project>
    set(INSTALL_DATA      "bin")                    # C:\Programme\<project>
    set(INSTALL_BIN       "bin")                    # C:\Programme\<project>
    set(INSTALL_SHARED    ".")                      # C:\Programme\<project>
    set(INSTALL_LIB       "lib")                    # C:\Programme\<project>\lib
    set(INSTALL_INCLUDE   "include")                # C:\Programme\<project>\include
    set(INSTALL_DOC       "doc")                    # C:\Programme\<project>\doc
    set(INSTALL_SHORTCUTS ".")                      # Not available under Windows
    set(INSTALL_ICONS     ".")                      # Not available under Windows
    set(INSTALL_INIT      ".")                      # Not available under Windows
else()
    set(INSTALL_ROOT      "share/${project}")       # /usr/[local]/share/<project>
    set(INSTALL_DATA      "share/${project}")       # /usr/[local]/share/<project>
    set(INSTALL_BIN       "bin")                    # /usr/[local]/bin
    set(INSTALL_SHARED    "lib")                    # /usr/[local]/lib
    set(INSTALL_LIB       "lib")                    # /usr/[local]/lib
    set(INSTALL_INCLUDE   "include")                # /usr/[local]/include
    set(INSTALL_DOC       "share/doc/${project}")   # /usr/[local]/share/doc/<project>
    set(INSTALL_SHORTCUTS "share/applications")     # /usr/[local]/share/applications
    set(INSTALL_ICONS     "share/pixmaps")          # /usr/[local]/share/pixmaps
    set(INSTALL_INIT      "/etc/init")              # /etc/init (upstart init scripts)

    # Adjust target paths for portable installs
    if(OPTION_PORTABLE_INSTALL)
        # Put binaries in root directory and keep data directory name
        set(INSTALL_ROOT ".")                       # /<INSTALL_PREFIX>
        set(INSTALL_DATA ".")                       # /<INSTALL_PREFIX>
        set(INSTALL_BIN ".")                        # /<INSTALL_PREFIX>

        # We have to change the RPATH of binaries to achieve a usable local install.
        # [TODO] For binaries, "$ORIGIN/lib" is right, so that libraries are found in ./lib.
        # However, I have not yet tested what happens when libraries use other libraries.
        # In that case, they might need the rpath $ORIGIN instead ...
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
        if (APPLE)
            set(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}/${INSTALL_LIB}") # Add rpath of project libraries
            set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)                       # Add rpaths of depending libraries
        endif()
    endif()
endif()


# 
# Deployment (global project files)
# 

# Install cmake find script for the project
install(FILES deploy/template-config.cmake DESTINATION ${INSTALL_ROOT})
install(FILES template-files.cmake         DESTINATION ${INSTALL_ROOT})

# Install the project meta files
install(FILES AUTHORS DESTINATION ${INSTALL_ROOT})
install(FILES LICENSE DESTINATION ${INSTALL_ROOT})

# Install runtime data
install(DIRECTORY ${CMAKE_SOURCE_DIR}/data DESTINATION ${INSTALL_DATA})

# Add a revision file containing the git-head tag for cpack and install. The function
# "create_revision_file (...)" is defined in cmake/GitRevision.cmake
#create_revision_file(${CMAKE_BINARY_DIR}/revision ${INSTALL_ROOT})


# 
# Project modules
# 

add_subdirectory(source)
add_subdirectory(docs)
add_subdirectory(deploy)
