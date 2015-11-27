
# 
# Identify platform
# 

if(WIN32 OR MINGW)
    set(PLATFORM_WINDOWS 1)
elseif(APPLE)
    set(PLATFORM_APPLE 1)
elseif(${CMAKE_SYSTEM_NAME} STREQUAL "Linux")
    set(PLATFORM_LINUX 1)
endif()
if(UNIX)
    set(PLATFORM_UNIX 1)
endif()


# 
# Platform and architecture setup
# 

# Architecture (32/64 bit)
set(X64 OFF)
if(CMAKE_SIZEOF_VOID_P EQUAL 8)
    set(X64 ON)
endif()


# 
# Project options
# 

set(DEFAULT_PROJECT_OPTIONS)


# 
# Include directories
# 
set(DEFAULT_INCLUDE_DIRECTORIES)



# 
# Libraries
# 

set(DEFAULT_LIBRARIES)


# 
# Compile definitions
# 

set(DEFAULT_COMPILE_DEFINITIONS)


# 
# Compile options
# 

set(DEFAULT_COMPILE_OPTIONS)


# 
# Linker options
# 

set(DEFAULT_LINKER_OPTIONS)

# Use pthreads on linux and mingw
if(PLATFORM_LINUX OR MINGW)
    set(DEFAULT_LINKER_OPTIONS
        -pthread
    )
endif()
