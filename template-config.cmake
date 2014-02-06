
# TEMPLATE_FOUND
# TEMPLATE_INCLUDE_DIR

# TEMPLATE_LIBRARY
# TEMPLATE_LIBRARY_DEBUG
# TEMPLATE_LIBRARIES

if(CMAKE_CURRENT_LIST_FILE)
	get_filename_component(TEMPLATE_DIR ${CMAKE_CURRENT_LIST_FILE} PATH)
endif()

file(TO_CMAKE_PATH "$ENV{PROGRAMFILES}" ENVPROGRAMFILES)
file(TO_CMAKE_PATH "$ENV{TEMPLATE_DIR}" ENVTEMPLATE_DIR)

find_path(TEMPLATE_INCLUDE_DIR template/template.h
	${ENVTEMPLATE_DIR}/include
	${TEMPLATE_DIR}/include
	${ENVPROGRAMFILES}/template/include
	/usr/include
	/usr/local/include
	/sw/include
	/opt/local/include
	DOC "The directory where fiblib/fiblib-api.h resides")

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

macro (find LIB_NAME)
	set(HINT_PATHS ${ARGN})

	if (${LIB_NAME} STREQUAL "template")
		set(LIB_NAME_UPPER TEMPLATE)
		set(LIBNAME template)
	else()
		string(TOUPPER TEMPLATE_${LIB_NAME} LIB_NAME_UPPER)
		set(LIBNAME template${LIB_NAME})
	endif()

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
endmacro()

find(template ${LIB_PATHS})
# find(...  ${LIB_PATHS})

find_package_handle_standard_args(TEMPLATE DEFAULT_MSG TEMPLATE_LIBRARIES TEMPLATE_INCLUDE_DIR)
mark_as_advanced(TEMPLATE_FOUND)
