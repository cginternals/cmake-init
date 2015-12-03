
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

if ("${CMAKE_CXX_COMPILER_ID}" MATCHES "MSVC")
    set(DEFAULT_COMPILE_OPTIONS ${DEFAULT_COMPILE_OPTIONS}
        /MP # -> build with multiple processes
        /nologo       # -> no compiler banner
        /Zc:wchar_t   # -> treat wchar_t as built-in type: yes
        /Zc:forScope  # -> force conformance in for loop scope: Yes
        /Gm           # -> enable minimal rebuild
        /fp:precise   # -> floating point model: precise
        /arch:SSE2    # -> enable enhanced instruction set: streaming simd extensions 2

        # /W4           # -> warning level 4
        /Wall         # -> enable all warnings
        
      # Disable the following warnings
      # /wd4273       # -> Two definitions in a file differ in their use of dllimport.
      # /wd4100       # -> 'identifier' : unreferenced formal parameter
      # /wd4127       # -> conditional expression is constant
      # /wd4251       # -> 'identifier' : class 'type' needs to have dll-interface to be used by clients of class 'type2'
      # /wd4267       # -> 'var' : conversion from 'size_t' to 'type', possible loss of data
        
        /vmg          # ->  to declare a pointer to a member of a class before defining the class. This need can arise if you define members in two different classes that reference each other.
        
        $<$<CONFIG:Debug>:   
            /RTC1         # -> Runtime error checks
            /RTCc
            /Od           # -> Optimization: none
            /GS           # -> buffer security check
            /GF-          # -> disable string pooling
            /Zi           # -> debug information format: program database
        >
        $<$<CONFIG:Release>: 
            /Ox           # -> optimization: full optimization
            /Ob2          # -> inline function expansion: any suitable
            /Oi           # -> enable intrinsic functions: yes
            /Ot           # -> favor size or speed: favor fast code
            /Oy           # -> omit frame pointers: yes
          # /Og           # -> use global optimization
          # /Gw           # -> whole program global optimization
          
            /GS-          # -> buffer security check: no 
            /GL           # -> whole program optimization: enable link-time code generation
            /GF           # -> enable string pooling
            /GR           # -> runtime type information          
        >
    )
endif ()

if ("${CMAKE_CXX_COMPILER_ID}" MATCHES "GNU") # GCC 4.7 and above
    set(DEFAULT_COMPILE_OPTIONS ${DEFAULT_COMPILE_OPTIONS}
        -Wall
        -Wextra
        -Wunused

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
        -Wempty-body
        -Wsign-compare
        -Wsign-conversion
        -Waddress
        -Wlogical-op
        -Wmissing-declarations
        -Wmissing-field-initializers
        -Wredundant-decls
        -Winline
        -Wlong-long
        -Wvector-operation-performance

        -Wno-pragmas
        -Wno-attributes
        
        $<$<VERSION_GREATER:$<CXX_COMPILER_VERSION>,4.8>:
            -Wpedantic
            -Wreturn-local-addr
            -Wuseless-cast
            -Wsizeof-pointer-memaccess
        >
        
        $<$<VERSION_GREATER:$<CXX_COMPILER_VERSION>,4.9>:
            -Wfloat-conversion
        >
        
        $<$<VERSION_GREATER:$<CXX_COMPILER_VERSION>,5.0>:
            -Wsuggest-final-types
            -Wsuggest-final-methods
            -Wsuggest-override
            -Wbool-compare
            -Wsized-deallocation
            -Wlogical-not-parentheses
        >
    )
endif ()

if ("${CMAKE_CXX_COMPILER_ID}" MATCHES "Clang") # Clang 3.4 and above
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
        -Woverloaded-virtual
        -Wformat
        -Wignored-qualifiers
        -Wmain
        -Wmissing-braces
        -Wparentheses
        -Wsequence-point
        -Wreturn-type
        -Wreturn-stack-address
        -Wswitch
        -Wswitch-default
        -Wuninitialized
        -Wfloat-equal
        -Wshadow
        -Wpointer-arith
        -Wtype-limits
        -Wcast-align
        -Wconversion
        -Wint-to-void-pointer-cast
        -Wempty-body
        -Wsign-compare
        -Wsign-conversion
        -Wsizeof-pointer-memaccess
        -Waddress
        -Wmissing-declarations
        -Wmissing-field-initializers
        -Wredundant-decls
        -Winline
        -Wlong-long
        -Wlogical-not-parentheses

        -Wno-attributes
        
        $<$<VERSION_GREATER:$<CXX_COMPILER_VERSION>,3.5>:
            -Wno-pragmas
            -Wfloat-conversion
        >
        
        $<$<PLATFORM_ID:"Darwin">:
            -pthread
        >
    )
endif ()


# 
# Linker options
# 

set(DEFAULT_LINKER_OPTIONS)

# Use pthreads on linux and mingw
if("${CMAKE_CXX_COMPILER_ID}" MATCHES "GNU" OR ("${CMAKE_CXX_COMPILER_ID}" MATCHES "Clang" AND "${CMAKE_SYSTEM_NAME}" MATCHES "Linux"))
    set(DEFAULT_LINKER_OPTIONS
        -pthread
    )
endif()
