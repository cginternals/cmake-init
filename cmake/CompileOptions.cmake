
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

if (PLATFORM_LINUX AND "${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
    set(DEFAULT_COMPILE_OPTIONS ${DEFAULT_COMPILE_OPTIONS}
        -Wall
        -Wextra
        -Wunused
        -Wpedantic
        
        -Wctor-dtor-privacy
        -Wdelete-non-virtual-dtor
        -Wnarrowing
        -Wnon-virtual-dtor
        -Wreorder
        -Weffc++
        -Wstrict-null-sentinel
        -Woverloaded-virtual
        -Wdouble-promotion
        -Wformat
        -Wignored-qualifiers
        -Wmain
        -Wmissing-braces
        -Wparentheses
        -Wsequence-point
        -Wreturn-type
        -Wreturn-local-addr
        -Wswitch
        -Wswitch-default
        -Wuninitialized
        -Wmaybe-uninitialized
        -Wfloat-equal
        -Wshadow
        -Wpointer-arith
        -Wtype-limits
        -Wcast-align
        -Wconversion
        -Wzero-as-null-pointer-constant
        -Wuseless-cast
        -Wempty-body
        -Wsign-compare
        -Wsign-conversion
        -Wfloat-conversion
        -Wsizeof-pointer-memaccess
        -Waddress
        -Wlogical-op
        -Wmissing-declarations
        -Wmissing-field-initializers
        -Wpadded
        -Wredundant-decls
        -Winline
        -Wlong-long
        -Wvector-operation-performance
        
        -Wno-pragmas
        -Wno-attributes
    )
    
    if (CMAKE_CXX_COMPILER_VERSION VERSION_GREATER 5.0)
        set(DEFAULT_COMPILE_OPTIONS ${DEFAULT_COMPILE_OPTIONS}
            -Wsuggest-attribute
            -Wsuggest-final-types
            -Wsuggest-final-methods
            -Wsuggest-override
            -Wbool-compare
            -Wcast-equal
            -Wsized-deallocation
            -Wlogical-not-parentheses
        )
    endif()
endif ()


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
