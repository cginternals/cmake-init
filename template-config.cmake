
# TEMPLATE_FOUND
# TEMPLATE_INCLUDE_DIR

# TEMPLATE_LIBRARIES
# TEMPLATE_INCLUDES

# TEMPLATE_FIBLIB_INCLUDE_DIR
# TEMPLATE_FIBLIB_LIBRARY
# TEMPLATE_FIBLIB_LIBRARY_DEBUG
# TEMPLATE_FIBLIB_LIBRARIES


include(FindPackageHandleStandardArgs)

if(CMAKE_CURRENT_LIST_FILE)
    get_filename_component(TEMPLATE_DIR ${CMAKE_CURRENT_LIST_FILE} PATH)
endif()

file(TO_CMAKE_PATH "$ENV{PROGRAMFILES}" ENVPROGRAMFILES)
file(TO_CMAKE_PATH "$ENV{TEMPLATE_DIR}" ENVTEMPLATE_DIR)

set(LIB_PATHS   
    ${TEMPLATE_DIR}/build
    ${TEMPLATE_DIR}/build/Release
    ${TEMPLATE_DIR}/build/Debug
    ${TEMPLATE_DIR}/build-release
    ${TEMPLATE_DIR}/build-debug
    ${ENVTEMPLATE_DIR}/lib
    ${TEMPLATE_DIR}/lib
    ${ENVPROGRAMFILES}/glow/lib
    /usr/lib
    /usr/local/lib
    /sw/lib
    /opt/local/lib
    /usr/lib64
    /usr/local/lib64
    /sw/lib64
    /opt/local/lib64
)

macro (find LIB_NAME HEADER)
    set(HINT_PATHS ${ARGN})

    if (${LIB_NAME} STREQUAL "template")
        set(LIB_NAME_UPPER TEMPLATE)
        set(LIBNAME template)
    else()
        string(TOUPPER TEMPLATE_${LIB_NAME} LIB_NAME_UPPER)
        set(LIBNAME ${LIB_NAME})
    endif()

    find_path(${LIB_NAME_UPPER}_INCLUDE_DIR ${HEADER}
        ${ENVTEMPLATE_DIR}/include
        ${ENVTEMPLATE_DIR}/source/${LIB_NAME}/include
        ${TEMPLATE_DIR}/include
        ${TEMPLATE_DIR}/source/${LIB_NAME}/include
        ${ENVPROGRAMFILES}/template/include
        /usr/include
        /usr/local/include
        /sw/include
        /opt/local/include
        DOC "The directory where fiblib/fiblib-api.h resides")

    find_library(${LIB_NAME_UPPER}_LIBRARY
        NAMES ${LIBNAME}
        PATHS ${HINT_PATHS}
        DOC "The ${LIB_NAME} library")
    find_library(${LIB_NAME_UPPER}_LIBRARY_DEBUG
        NAMES ${LIBNAME}d
        PATHS ${HINT_PATHS}
        DOC "The ${LIB_NAME} debug library")
    
    if(${LIB_NAME_UPPER}_LIBRARY AND ${LIB_NAME_UPPER}_LIBRARY_DEBUG)
        set(${LIB_NAME_UPPER}_LIBRARIES "optimized" ${${LIB_NAME_UPPER}_LIBRARY} "debug" ${${LIB_NAME_UPPER}_LIBRARY_DEBUG})
    elseif(${LIB_NAME_UPPER}_LIBRARY)
        set(${LIB_NAME_UPPER}_LIBRARIES ${${LIB_NAME_UPPER}_LIBRARY})
    elseif(${LIB_NAME_UPPER}_LIBRARY_DEBUG)
        set(${LIB_NAME_UPPER}_LIBRARIES ${${LIB_NAME_UPPER}_LIBRARY_DEBUG})
    endif()

    set(TEMPLATE_INCLUDES  ${TEMPLATE_INCLUDES}  ${${LIB_NAME_UPPER}_INCLUDE_DIR})
    set(TEMPLATE_LIBRARIES ${TEMPLATE_LIBRARIES} ${${LIB_NAME_UPPER}_LIBRARIES})

    # DEBUG
    #message("${LIB_NAME_UPPER}_INCLUDE_DIR   = ${${LIB_NAME_UPPER}_INCLUDE_DIR}")
    #message("${LIB_NAME_UPPER}_LIBRARY       = ${${LIB_NAME_UPPER}_LIBRARY}")
    #message("${LIB_NAME_UPPER}_LIBRARY_DEBUG = ${${LIB_NAME_UPPER}_LIBRARY_DEBUG}")
    #message("${LIB_NAME_UPPER}_LIBRARIES     = ${${LIB_NAME_UPPER}_LIBRARIES}")

endmacro()


# Find libraries
find(fiblib fiblib/fiblib_api.h ${LIB_PATHS})


# DEBUG
#message("TEMPLATE_INCLUDES  = ${TEMPLATE_INCLUDES}")
#message("TEMPLATE_LIBRARIES = ${TEMPLATE_LIBRARIES}")

find_package_handle_standard_args(TEMPLATE DEFAULT_MSG TEMPLATE_LIBRARIES TEMPLATE_INCLUDES)
mark_as_advanced(TEMPLATE_FOUND)
