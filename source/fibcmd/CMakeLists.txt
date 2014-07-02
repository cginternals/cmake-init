
set(target fibcmd)
message(STATUS "App ${target}")

#
# External libraries
#

# ...

#
# Includes
#

include_directories(
    # e.g., ${TRDP_INCLUDE_DIR}
)

include_directories(
    BEFORE
    ${CMAKE_SOURCE_DIR}/source/fiblib/include
)

#
# Libraries
#

set(libs
    # e.g., ${TRDP_LIBRARIES}
    fiblib
)

#
# Compiler definitions
#

if (OPTION_BUILD_STATIC)
    add_definitions("-D${META_PROJECT_NAME_UPPER}_STATIC")
endif()

#
# Sources
#

set(sources
    main.cpp
)

#
# Build executable
#

add_executable(${target} ${sources})

target_link_libraries(${target} ${libs})

set_target_properties(${target}
    PROPERTIES
    LINKER_LANGUAGE              CXX
    FOLDER                      "${IDE_FOLDER}"
    COMPILE_DEFINITIONS         "$<$<CONFIG:Debug>:DEFAULT_COMPILE_DEFS_DEBUG>"
                                "$<$<CONFIG:Release>:DEFAULT_COMPILE_DEFS_RELEASE>"
    COMPILE_FLAGS               "${DEFAULT_COMPILE_FLAGS}"
    LINK_FLAGS                  "$<$<CONFIG:Debug>:DEFAULT_LINKER_FLAGS_DEBUG>"
                                "$<$<CONFIG:Release>:DEFAULT_LINKER_FLAGS_RELEASE>"
    DEBUG_POSTFIX               "d${DEBUG_POSTFIX}")

#
# Deployment
#

install(TARGETS ${target}
    RUNTIME DESTINATION ${INSTALL_BIN}
#   LIBRARY DESTINATION ${INSTALL_SHARED}
#   ARCHIVE DESTINATION ${INSTALL_LIB}
)
