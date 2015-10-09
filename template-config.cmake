
######
# This is the find-script for your project/library used by CMake if this project/libary is to be
# included in another project/library.
######

#
# Renaming TEMPLATE... -> <PROJECT_NAME>...
#
# TEMPLATE_DIR -> <PROJECT_NAME>_DIR
# TEMPLATE_FOUND -> <PROJECT_NAME>_FOUND
# TEMPLATE_LIBRARIES -> <PROJECT_NAME>_LIBRARIES
# TEMPLATE_INCLUDE_DIRS -> <PROJECT_NAME>_INCLUDE_DIRS

# TEMPLATE_FIBLIB_LIBRARY -> <PROJECT_NAME>_<...>_LIBRARY
# TEMPLATE_FIBLIB_LIBRARY_RELEASE -> <PROJECT_NAME>_<...>_LIBRARY_RELEASE
# TEMPLATE_FIBLIB_LIBRARY_DEBUG -> <PROJECT_NAME>_<...>_LIBRARY_DEBUG
# TEMPLATE_FIBLIB_INCLUDE_DIR -> <PROJECT_NAME>_<...>_INCLUDE_DIR

set(TEMPLATE_INCLUDE_DIRS "")
set(TEMPLATE_LIBRARIES "")

# Definition of function "find" with two mandatory arguments, "LIB_NAME" and "HEADER".
macro (find LIB_NAME HEADER)

    set(HINT_PATHS ${ARGN})

    if (${LIB_NAME} STREQUAL "template")
        set(LIB_NAME_UPPER TEMPLATE)
        set(LIBNAME template)
    else()
        string(TOUPPER TEMPLATE_${LIB_NAME} LIB_NAME_UPPER)
        set(LIBNAME ${LIB_NAME})
    endif()

    find_path(
	${LIB_NAME_UPPER}_INCLUDE_DIR
	${HEADER}
        ${ENV_TEMPLATE_DIR}/include
        ${ENV_TEMPLATE_DIR}/source/${LIB_NAME}/include
        ${TEMPLATE_DIR}/include
        ${TEMPLATE_DIR}/source/${LIB_NAME}/include
        ${ENV_PROGRAMFILES}/template/include
        /usr/include
        /usr/local/include
        /sw/include
        /opt/local/include
        DOC "The directory where ${HEADER} resides"
    )


    find_library(
	${LIB_NAME_UPPER}_LIBRARY_RELEASE
        NAMES ${LIBNAME}
        PATHS ${HINT_PATHS}
        DOC "The ${LIB_NAME} library"
    )
    find_library(
	${LIB_NAME_UPPER}_LIBRARY_DEBUG
        NAMES ${LIBNAME}d
        PATHS ${HINT_PATHS}
        DOC "The ${LIB_NAME} debug library"
    )
    

    if(${LIB_NAME_UPPER}_LIBRARY_RELEASE AND ${LIB_NAME_UPPER}_LIBRARY_DEBUG)
        set(${LIB_NAME_UPPER}_LIBRARY "optimized" ${${LIB_NAME_UPPER}_LIBRARY_RELEASE} "debug" ${${LIB_NAME_UPPER}_LIBRARY_DEBUG})
    elseif(${LIB_NAME_UPPER}_LIBRARY_RELEASE)
        set(${LIB_NAME_UPPER}_LIBRARY ${${LIB_NAME_UPPER}_LIBRARY_RELEASE})
    elseif(${LIB_NAME_UPPER}_LIBRARY_DEBUG)
        set(${LIB_NAME_UPPER}_LIBRARY ${${LIB_NAME_UPPER}_LIBRARY_DEBUG})
    endif()

    list(APPEND TEMPLATE_INCLUDE_DIRS ${${LIB_NAME_UPPER}_INCLUDE_DIR})
    list(APPEND TEMPLATE_LIBRARIES ${${LIB_NAME_UPPER}_LIBRARY})

    # DEBUG MESSAGES
    # message("${LIB_NAME_UPPER}_INCLUDE_DIR     = ${${LIB_NAME_UPPER}_INCLUDE_DIR}")
    # message("${LIB_NAME_UPPER}_LIBRARY_RELEASE = ${${LIB_NAME_UPPER}_LIBRARY_RELEASE}")
    # message("${LIB_NAME_UPPER}_LIBRARY_DEBUG   = ${${LIB_NAME_UPPER}_LIBRARY_DEBUG}")
    # message("${LIB_NAME_UPPER}_LIBRARY         = ${${LIB_NAME_UPPER}_LIBRARY}")

endmacro(find)


# load standard CMake arguments (c.f. http://stackoverflow.com/questions/7005782/cmake-include-findpackagehandlestandardargs-cmake)
include(FindPackageHandleStandardArgs)

if(CMAKE_CURRENT_LIST_FILE)
    get_filename_component(TEMPLATE_DIR ${CMAKE_CURRENT_LIST_FILE} PATH)
endif()

file(TO_CMAKE_PATH "$ENV{PROGRAMFILES}" ENV_PROGRAMFILES)
file(TO_CMAKE_PATH "$ENV{TEMPLATE_DIR}" ENV_TEMPLATE_DIR)

set(LIB_PATHS
    ${TEMPLATE_DIR}/build
    ${TEMPLATE_DIR}/build/Release
    ${TEMPLATE_DIR}/build/Debug
    ${TEMPLATE_DIR}/build-release
    ${TEMPLATE_DIR}/build-debug
    ${TEMPLATE_DIR}/lib
    ${ENV_TEMPLATE_DIR}/lib
    ${ENV_PROGRAMFILES}/template/lib
    /usr/lib
    /usr/local/lib
    /sw/lib
    /opt/local/lib
    /usr/lib64
    /usr/local/lib64
    /sw/lib64
    /opt/local/lib64
)

# Find libraries
find(fiblib fiblib/fiblib_api.h ${LIB_PATHS})

if(TEMPLATE_FIBLIB_LIBRARY)
  # add dependencies
endif()


# DEBUG
# message("TEMPLATE_INCLUDE_DIRS  = ${TEMPLATE_INCLUDE_DIRS}")
# message("TEMPLATE_LIBRARIES = ${TEMPLATE_LIBRARIES}")

find_package_handle_standard_args(TEMPLATE DEFAULT_MSG TEMPLATE_LIBRARIES TEMPLATE_INCLUDE_DIRS)
mark_as_advanced(TEMPLATE_FOUND)
