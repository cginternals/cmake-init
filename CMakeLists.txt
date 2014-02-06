cmake_minimum_required(VERSION 2.8.9 FATAL_ERROR)


# PROJECT DESCRIPTION

set(META_PROJECT_NAME        "template")
set(META_VERSION_MAJOR       "0")
set(META_VERSION_MINOR       "0")
set(META_VERSION_PATCH       "0")
set(META_VERSION             "${META_VERSION_MAJOR}.${META_VERSION_MINOR}.${META_VERSION_PATCH}")
set(META_AUTHOR_ORGANIZATION "hpicgs group")
set(META_AUTHOR_DOMAIN       "https://github.com/hpicgs/cmake-init/")


# OPTIONS

option(OPTION_LIMIT_CONFIGS  "Generate limited configs (Release; Debug)" ON)
option(OPTION_LOCAL_INSTALL  "Install to a local directory instead of the system" OFF)
option(OPTION_BUILD_STATIC   "Build static libraries" OFF)
option(OPTION_BUILD_TESTS    "Build test projects (if gmock and gtest are found)" ON)

# CMAKE CONFIGURATION

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

# Generate folders
set_property(GLOBAL PROPERTY USE_FOLDERS ON)

# Include custom cmake functions
include(cmake/Custom.cmake)


# PLATFORM AND ARCHITECTURE

# Architecture (32/64 bit)
set(X64 OFF)
if(CMAKE_SIZEOF_VOID_P EQUAL 8)
    set(X64 ON)
endif()


# Check for linux
#if(UNIX AND NOT APPLE)
#    set(LINUX 1)
#endif()


# Setup platform specifics (compile flags, etc., ...)
if(MSVC)

    message(STATUS "Configuring for platform Windows/MSVC.")
    include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/PlatformWindowsMSVC.cmake)

elseif(WIN32 AND CMAKE_COMPILER_IS_GNUCXX)

    message(STATUS "Configuring for platform Windows/GCC.")
    include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/PlatformWindowsGCC.cmake)

elseif(APPLE)

    message(STATUS "XCODE VERSION :: ${XCODE_VERSION}")
    
    if ("${XCODE_VERSION}")
	# check regex, it's just a quick-hack for now but should work if the
	# version string format returned by ${XCODE_VERSION} does not change.
	# required format is <MAJOR>.<MINOR>.<PATCH>
	string(REGEX REPLACE "^([0-9]+).*" "\\1" XCODE_MAJOR "${XCODE_VERSION}")
	string(LENGTH ${XCODE_MAJOR} XCODE_MAJOR_LENGTH)
	string(REGEX MATCH "[0-4]" XCODE_MAJOR_TO_OLD ${XCODE_MAJOR})
	
	if (NOT (${XCODE_MAJOR_LENGTH} EQUAL 1 AND "${XCODE_MAJOR_TO_OLD}" GREATER ""))
	    message(STATUS "Configuring for platform MacOS with XCode Version 5+.")
	    include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/PlatformMacOS.cmake)
	else ()
	    message (WARNING "Insufficient XCode Version (upgrade to XCode 5.x or higher)!")
	endif()
    else ()
	    message (STATUS "Configuring for platform MacOS without XCode, using plain make.")
	    include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/PlatformMacOS.cmake)
    endif()

elseif(UNIX AND CMAKE_COMPILER_IS_GNUCXX)

    message(STATUS "Configuring for platform Linux/GCC.")
    include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/PlatformLinuxGCC.cmake)

else()

    # Unsupported system/compiler
    message(WARNING "Unsupported platform/compiler combination")

endif()


# INSTALL
if(X64)
    # http://public.kitware.com/Bug/view.php?id=9094
    set(CPACK_NSIS_INSTALL_ROOT "$PROGRAMFILES64")
endif()

set(project ${META_PROJECT_NAME})
if(WIN32)
    set(INSTALL_BIN           ".")                      # C:\Programme\<project>
    set(INSTALL_SHARED        ".")                      # C:\Programme\<project>
    set(INSTALL_LIB           "lib")                    # C:\Programme\<project>\lib
    set(INSTALL_INCLUDE       "include")                # C:\Programme\<project>\include
    set(INSTALL_DOC           "doc")                    # C:\Programme\<project>\doc
    set(INSTALL_APPLICATIONS  ".")                      # Not available under Windows
    set(INSTALL_ICONS         ".")                      # Not available under Windows
    set(INSTALL_INIT          ".")                      # Not available under Windows
    set(INSTALL_DATA          ".")                      # C:\Programme\<project>
    set(INSTALL_EXAMPLES      ".")                      # C:\Programme\<project>
else()
    set(INSTALL_BIN           "bin")                    # /usr/[local]/bin
    set(INSTALL_SHARED        "lib")                    # /usr/[local]/lib
    set(INSTALL_LIB           "lib")                    # /usr/[local]/lib
    set(INSTALL_INCLUDE       "include")                # /usr/[local]/include
    set(INSTALL_DOC           "share/doc/${project}")   # /usr/[local]/share/doc/<project>
    set(INSTALL_APPLICATIONS  "share/applications")     # /usr/[local]/share/applications
    set(INSTALL_ICONS         "share/pixmaps")          # /usr/[local]/share/pixmaps
    set(INSTALL_INIT          "/etc/init")              # /etc/init (upstart init scripts)
    set(INSTALL_DATA          "share/${project}")       # /usr/[local]/share/<project>
    set(INSTALL_EXAMPLES      "share/${project}")       # /usr/[local]/share/<project>

    # Adjust target paths for Local installs
    if(OPTION_LOCAL_INSTALL)
        # Put binaries in root directory and keep data directory name
        set(INSTALL_BIN                       ".")           # /<INSTALL_PREFIX>
        set(INSTALL_DATA                      ".")           # /<INSTALL_PREFIX>

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

# GET REPOSITORY VERSION

# Add a revision file containing the git-head tag for cpack and install
include(GetGitRevisionDescription)
get_git_head_revision(GIT_REFSPEC GIT_SHA1)

# Generate a shorter, googlelike variation for rev
string(SUBSTRING ${GIT_SHA1} 0 12 GIT_REV)
file(WRITE ${CMAKE_BINARY_DIR}/revision ${GIT_REV})

# [TODO] Really?? Do we want this deployed?

install(FILES ${CMAKE_BINARY_DIR}/revision DESTINATION .)
install(FILES template-config.cmake DESTINATION ".")
install(FILES AUTHORS DESTINATION ".")
install(FILES LICENSE DESTINATION ".")

# [TODO] Deal with GIT-NOTFOUND

# GLOW DEPENDENCIES

if (OPTION_BUILD_STATIC)
    add_definitions("-DTEMPLATE_STATIC")
endif()

# PACKAGING

add_subdirectory(packages)

# DOXYGEN

add_subdirectory(docs)

# MODULES

add_subdirectory(source)
