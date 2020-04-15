
# googletest_FOUND
# Target googletest::googletest

include(FindPackageHandleStandardArgs)

find_path(GOOGLETEST_PROJECT_DIR googletest/include/gtest/gtest.h
    PATHS
    $ENV{GOOGLETEST_DIR}
    /usr/src
    /usr/local/src

    PATH_SUFFIXES
    /googletest

    DOC "The directory where googletest/include/gtest/gtest.h resides")

find_package_handle_standard_args(googletest REQUIRED_VARS GOOGLETEST_PROJECT_DIR)
mark_as_advanced(GOOGLETEST_PROJECT_DIR)

if (googletest_FOUND)
    # Build gmock
    set(gmock_build_tests           OFF CACHE BOOL "")
    set(gtest_build_samples         OFF CACHE BOOL "")
    set(gtest_build_tests           OFF CACHE BOOL "")
    set(gtest_disable_pthreads      OFF CACHE BOOL "")
    set(gtest_force_shared_crt      ON  CACHE BOOL "")
    set(gtest_hide_internal_symbols OFF CACHE BOOL "")

    add_subdirectory("${GOOGLETEST_PROJECT_DIR}" "${PROJECT_BINARY_DIR}/googletest")
    
    # Create interface library to link against gmock
    add_library(googletest::googletest INTERFACE IMPORTED)

    target_include_directories(googletest::googletest
        SYSTEM INTERFACE
        ${GOOGLETEST_PROJECT_DIR}/googletest/include
        ${GOOGLETEST_PROJECT_DIR}/googlemock/include
    )

    target_link_libraries(googletest::googletest
        INTERFACE
        gmock
    )
endif ()
