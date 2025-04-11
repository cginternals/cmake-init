
# googletest_FOUND
# Target googletest::googletest

include(FindPackageHandleStandardArgs)

find_package(PkgConfig)

# enable MSVC syntax if required
if("${CMAKE_CXX_COMPILER_ID}" MATCHES "MSVC")
    set(PKG_CONFIG_ARGN ${PKG_CONFIG_ARGN} "--msvc-syntax")
endif()

pkg_search_module(GMOCK QUIET gmock_main)

find_package_handle_standard_args(googletest REQUIRED_VARS GMOCK_CFLAGS GMOCK_LDFLAGS)
mark_as_advanced(GMOCK_CFLAGS GMOCK_LDFLAGS)

if (googletest_FOUND)
    # the linker flags aren't correct for use with target_link_libraries
    # example: /libpath:[path]/lib.lib;gmock_main.lib;gmock.lib;gtest.lib
    # note that the path arg falsely includes a .lib suffix
    # additionally, cmake expects linker flags to start with -
    # thus, the leading / has to be replaced
    # example result: -libpath:[path]/lib;gmock_main.lib;gmock.lib;gtest.lib
    if("${CMAKE_CXX_COMPILER_ID}" MATCHES "MSVC")
        string(REGEX REPLACE "(\\/)(libpath[^;]*)(\\.lib)" "-\\2" GMOCK_LDFLAGS "${GMOCK_LDFLAGS}")
    endif()
    
    # Create interface library to link against gmock
    add_library(googletest::googletest INTERFACE IMPORTED)

    target_link_libraries(googletest::googletest
        INTERFACE
        ${GMOCK_LDFLAGS}
    )

    target_compile_options(googletest::googletest
        INTERFACE
        ${GMOCK_CFLAGS}
    )
endif ()
