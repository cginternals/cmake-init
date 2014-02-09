
# Check compiler and version
if ("${XCODE_VERSION}")
	# check regex, it's just a quick-hack for now but should work if the
	# version string format returned by ${XCODE_VERSION} does not change.
	# required format is <MAJOR>.<MINOR>.<PATCH>
	string(REGEX REPLACE "^([0-9]+).*" "\\1" XCODE_MAJOR "${XCODE_VERSION}")
	string(LENGTH ${XCODE_MAJOR} XCODE_MAJOR_LENGTH)
	string(REGEX MATCH "[0-4]" XCODE_MAJOR_TO_OLD ${XCODE_MAJOR})

	# Reject XCode < Version 5
	if (NOT (${XCODE_MAJOR_LENGTH} EQUAL 1 AND "${XCODE_MAJOR_TO_OLD}" GREATER ""))
	    message(STATUS "Configuring for platform MacOS with XCode Version 5+.")
	else ()
	    message(FATAL_ERROR "Insufficient XCode Version (upgrade to XCode 5.x or higher)!")
	endif()
else ()
    message (STATUS "Configuring for platform MacOS without XCode, using plain make.")
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
