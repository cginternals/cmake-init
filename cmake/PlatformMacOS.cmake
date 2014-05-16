
#message(STATUS "XCODE VERSION :: ${XCODE_VERSION}")

# Check compiler and version
if ("${XCODE_VERSION}" VERSION_LESS "5")

    if ("${XCODE_VERSION}" VERSION_GREATER "0") 
        message(FATAL_ERROR "Insufficient XCode Version (upgrade to XCode 5.x or higher)!")
    else ()
        message (STATUS "Configuring for platform MacOS without XCode, using plain make.")
    endif ()

else ()

    message(STATUS "Configuring for platform MacOS with XCode Version 5+.")

    # The XCode generator seems to ignore the value in the CMAKE_BUILD_TYPE variable.
    # Instead, it uses the first value of the CMAKE_CONFIGURATION_TYPES list as build
    # type (cf. http://www.cmake.org/pipermail/cmake/2006-December/012288.html)
    # Therefore, we re-define the CMAKE_CONFIGURATION_TYPES here according to the value
    # in CMAKE_BUILD_TYPES.
    if ("${CMAKE_BUILD_TYPE}" STREQUAL "Release")
	set(CMAKE_CONFIGURATION_TYPES "Release;Debug")
    else ()
        set(CMAKE_CONFIGURATION_TYPES "Debug;Release")
    endif ()


endif()


# removed according to http://comments.gmane.org/gmane.editors.lyx.cvs/38306
#set(CMAKE_XCODE_ATTRIBUTE_GCC_VERSION "com.apple.compilers.llvm.clang.1_0")

set(CMAKE_XCODE_ATTRIBUTE_CLANG_CXX_LANGUAGE_STANDARD "c++11")
set(CMAKE_XCODE_ATTRIBUTE_CLANG_CXX_LIBRARY "libc++")

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -stdlib=libc++ -g -Wall")


set(MACOS_COMPILE_DEFS MAC_OS)
set(DEFAULT_COMPILE_DEFS_DEBUG   ${MACOS_COMPILE_DEFS} _DEBUG) # Debug build
set(DEFAULT_COMPILE_DEFS_RELEASE ${MACOS_COMPILE_DEFS} NDEBUG) # Release build

set(MACOS_COMPILE_FLAGS)
set(DEFAULT_COMPILE_FLAGS ${MACOS_COMPILE_FLAGS})
