
set(target fibcmd)
message(STATUS "app ${target}")

add_executable(${target} 
    main.cpp
)

include_directories(
    # e.g., ${TRDP_INCLUDE_DIR}
    ${CMAKE_SOURCE_DIR}/source/fiblib/include
)

target_link_libraries(${target} 
    ${TRDP_LIBRARIES}
    fiblib
)

set_target_properties(${target}
    PROPERTIES
    LINKER_LANGUAGE CXX
    FOLDER ${TEMPLATE_APPS_FOLDER}
    COMPILE_DEFINITIONS_DEBUG   "${DEFAULT_COMPILE_DEFS_DEBUG}"
    COMPILE_DEFINITIONS_RELEASE "${DEFAULT_COMPILE_DEFS_RELEASE}"
    COMPILE_FLAGS               "${DEFAULT_COMPILE_FLAGS}"
    LINK_FLAGS_DEBUG            "${DEFAULT_LINKER_FLAGS_DEBUG}"
    LINK_FLAGS_RELEASE          "${DEFAULT_LINKER_FLAGS_RELEASE}"
    DEBUG_POSTFIX               "d${DEBUG_POSTFIX}")

install(TARGETS ${target}
    RUNTIME DESTINATION ${INSTALL_BIN}
#    LIBRARY DESTINATION ${INSTALL_SHARED}
#    ARCHIVE DESTINATION ${INSTALL_LIB}
)
