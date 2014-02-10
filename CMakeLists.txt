
cmake_minimum_required(VERSION 2.8.9 FATAL_ERROR)


#
# Project description
#

set(META_PROJECT_NAME        "template")
set(META_VERSION_MAJOR       "0")
set(META_VERSION_MINOR       "0")
set(META_VERSION_PATCH       "0")
set(META_VERSION             "${META_VERSION_MAJOR}.${META_VERSION_MINOR}.${META_VERSION_PATCH}")
set(META_AUTHOR_ORGANIZATION "hpicgs group")
set(META_AUTHOR_DOMAIN       "https://github.com/hpicgs/cmake-init/")


#
# Options
#

option(OPTION_LIMIT_CONFIGS    "Generate limited configs (Release; Debug)" ON)
option(OPTION_PORTABLE_INSTALL "Install into a self-contained directory" OFF)
option(OPTION_BUILD_STATIC     "Build static libraries" OFF)
option(OPTION_BUILD_TESTS      "Build tests (if gmock and gtest are found)" ON)


#
# CMake configuration
#

# Include cmake modules from ./cmake
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_CURRENT_SOURCE_DIR}/cmake)

# Set output directories
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR})
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR})
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR})

# Set configuration types
if(OPTION_LIMIT_CONFIGS)
    set(CMAKE_CONFIGURATION_TYPES "Debug;Release" CACHE STRING "Limited Configs" FORCE)
endif()
if (${CMAKE_BUILD_TYPE})
    set (CMAKE_BUILD_TYPE "Debug" CACHE STRING "Use build type 'Debug' per default" FORCE)
endif()

# Project
project(${META_PROJECT_NAME} C CXX)

# Generate folders for IDE targets (e.g., VisualStudio solutions)
set_property(GLOBAL PROPERTY USE_FOLDERS ON)
set(IDE_FOLDER "")  # Put projects in root folder by default

# Include custom cmake functions
include(cmake/Custom.cmake)
include(cmake/GitRevision.cmake)


#
# Platform and architecture
#

# Architecture (32/64 bit)
set(X64 OFF)
if(CMAKE_SIZEOF_VOID_P EQUAL 8)
    set(X64 ON)
endif()

# Setup platform specifics (compile flags, etc., ...)
if(MSVC)
    include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/PlatformWindowsMSVC.cmake)
elseif(WIN32 AND CMAKE_COMPILER_IS_GNUCXX)
    include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/PlatformWindowsGCC.cmake)
elseif(APPLE)
    include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/PlatformMacOS.cmake)
elseif(UNIX AND CMAKE_COMPILER_IS_GNUCXX)
    include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/PlatformLinuxGCC.cmake)
else()
    message(WARNING "Unsupported platform/compiler combination")
endif()

# Installation paths
set(project ${META_PROJECT_NAME})
if(WIN32)
    set(INSTALL_ROOT          ".")                      # C:\Programme\<project>
    set(INSTALL_DATA          ".")                      # C:\Programme\<project>
    set(INSTALL_BIN           "bin")                    # C:\Programme\<project>
    set(INSTALL_SHARED        ".")                      # C:\Programme\<project>
    set(INSTALL_LIB           "lib")                    # C:\Programme\<project>\lib
    set(INSTALL_INCLUDE       "include")                # C:\Programme\<project>\include
    set(INSTALL_DOC           "doc")                    # C:\Programme\<project>\doc
    set(INSTALL_SHORTCUTS     ".")                      # Not available under Windows
    set(INSTALL_ICONS         ".")                      # Not available under Windows
    set(INSTALL_INIT          ".")                      # Not available under Windows
else()
    set(INSTALL_ROOT          "share/${project}")       # /usr/[local]/share/<project>
    set(INSTALL_DATA          "share/${project}")       # /usr/[local]/share/<project>
    set(INSTALL_BIN           "bin")                    # /usr/[local]/bin
    set(INSTALL_SHARED        "lib")                    # /usr/[local]/lib
    set(INSTALL_LIB           "lib")                    # /usr/[local]/lib
    set(INSTALL_INCLUDE       "include")                # /usr/[local]/include
    set(INSTALL_DOC           "share/doc/${project}")   # /usr/[local]/share/doc/<project>
    set(INSTALL_SHORTCUTS     "share/applications")     # /usr/[local]/share/applications
    set(INSTALL_ICONS         "share/pixmaps")          # /usr/[local]/share/pixmaps
    set(INSTALL_INIT          "/etc/init")              # /etc/init (upstart init scripts)

    # Adjust target paths for portable installs
    if(OPTION_PORTABLE_INSTALL)
        # Put binaries in root directory and keep data directory name
        set(INSTALL_ROOT                      ".")           # /<INSTALL_PREFIX>
        set(INSTALL_DATA                      ".")           # /<INSTALL_PREFIX>
        set(INSTALL_BIN                       ".")           # /<INSTALL_PREFIX>

        # We have to change the RPATH of binaries to achieve a usable local install.
        # [TODO] For binaries, "$ORIGIN/lib" is right, so that libraries are found in ./lib.
        #        However, I have not yet tested what happens when libraries use other libraries.
        #        In that case, they might need the rpath $ORIGIN instead ...
        set(CMAKE_SKIP_BUILD_RPATH            FALSE)         # Use automatic rpath for build
        set(CMAKE_BUILD_WITH_INSTALL_RPATH    FALSE)         # Use specific rpath for INSTALL
        set(CMAKE_INSTALL_RPATH_USE_LINK_PATH FALSE)         # NO automatic rpath for INSTALL
        set(CMAKE_INSTALL_RPATH               "$ORIGIN/lib") # Libraries are relative to binary
    endif()
endif()


#
# Global deployment
#

# Project meta files
install(FILES template-config.cmake DESTINATION ${INSTALL_ROOT})
install(FILES AUTHORS               DESTINATION ${INSTALL_ROOT})
install(FILES LICENSE               DESTINATION ${INSTALL_ROOT})

# Add a revision file containing the git-head tag for cpack and install
create_revision_file(${CMAKE_BINARY_DIR}/revision ${INSTALL_ROOT})

# Data files
install(DIRECTORY ${CMAKE_SOURCE_DIR}/data DESTINATION ${INSTALL_DATA})


#
# Include projects
#

add_subdirectory(source)
add_subdirectory(packages)
add_subdirectory(docs)
