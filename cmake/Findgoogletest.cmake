
# googletest_FOUND
# Target googletest::googletest

include(FindPackageHandleStandardArgs)

find_package(PkgConfig)
pkg_search_module(GMOCK QUIET gmock_main)

find_package_handle_standard_args(googletest REQUIRED_VARS GMOCK_CFLAGS GMOCK_LDFLAGS)
mark_as_advanced(GMOCK_CFLAGS GMOCK_LDFLAGS)

if (googletest_FOUND)
    
    
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
