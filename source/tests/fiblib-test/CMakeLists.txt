
set(target fiblib-test)
message(STATUS "Test ${target}")

include_directories(
    # e.g., ${TRDP_INCLUDE_DIR}
    ${CMAKE_SOURCE_DIR}/source/fiblib/include
)

add_executable(${target} 
    main.cpp
    fibonacci_test.cpp
)

target_link_libraries(${target} 
    ${GMOCK_LIBRARIES}
    ${GTEST_LIBRARIES}
    fiblib
)

set_target_properties(${target}
    PROPERTIES
    LINKER_LANGUAGE              CXX
    FOLDER                      "${IDE_FOLDER}"
    COMPILE_DEFINITIONS_DEBUG   "${DEFAULT_COMPILE_DEFS_DEBUG}"
    COMPILE_DEFINITIONS_RELEASE "${DEFAULT_COMPILE_DEFS_RELEASE}"
    COMPILE_FLAGS               "${DEFAULT_COMPILE_FLAGS}"
    LINK_FLAGS_DEBUG            "${DEFAULT_LINKER_FLAGS_DEBUG}"
    LINK_FLAGS_RELEASE          "${DEFAULT_LINKER_FLAGS_RELEASE}"
    DEBUG_POSTFIX               "d${DEBUG_POSTFIX}")
