
# FFMPEG_FOUND
# FFMPEG_INCLUDE_DIR
# FFMPEG_LIBRARIES
# FFMPEG_BINARIES (win32 only)

# FFMPEG_AVCODEC_LIBRARY_RELEASE
# FFMPEG_AVCODEC_LIBRARY_DEBUG
# FFMPEG_AVCODEC_LIBRARIES
# FFMPEG_AVCODEC_BINARY (win32 only)

# FFMPEG_AVDEVICE_LIBRARY_RELEASE
# FFMPEG_AVDEVICE_LIBRARY_DEBUG
# FFMPEG_AVDEVICE_LIBRARIES
# FFMPEG_AVDEVICE_BINARY (win32 only)

# FFMPEG_AVFILTER_LIBRARY_RELEASE
# FFMPEG_AVFILTER_LIBRARY_DEBUG
# FFMPEG_AVFILTER_LIBRARIES
# FFMPEG_AVFILTER_BINARY (win32 only)

# FFMPEG_AVFORMAT_LIBRARY_RELEASE
# FFMPEG_AVFORMAT_LIBRARY_DEBUG
# FFMPEG_AVFORMAT_LIBRARIES
# FFMPEG_AVFORMAT_BINARY (win32 only)

# FFMPEG_AVUTIL_LIBRARY_RELEASE
# FFMPEG_AVUTIL_LIBRARY_DEBUG
# FFMPEG_AVUTIL_LIBRARIES
# FFMPEG_AVUTIL_BINARY (win32 only)

# FFMPEG_POSTPROC_LIBRARY_RELEASE
# FFMPEG_POSTPROC_LIBRARY_DEBUG
# FFMPEG_POSTPROC_LIBRARIES
# FFMPEG_POSTPROC_BINARY (win32 only)

# FFMPEG_SWRESAMPLE_LIBRARY_RELEASE
# FFMPEG_SWRESAMPLE_LIBRARY_DEBUG
# FFMPEG_SWRESAMPLE_LIBRARIES
# FFMPEG_SWRESAMPLE_BINARY (win32 only)

# FFMPEG_SWSCALE_LIBRARY_RELEASE
# FFMPEG_SWSCALE_LIBRARY_DEBUG
# FFMPEG_SWSCALE_LIBRARIES
# FFMPEG_SWSCALE_BINARY (win32 only)

include(FindPackageHandleStandardArgs)


set(FFMPEG_LIBRARIES "")
if(WIN32)
    set(FFMPEG_BINARIES "")
endif()


macro(find_component NAME)
    
    string(TOUPPER ${NAME} NAME_UPPER)

    # find release library
    find_library(FFMPEG_${NAME_UPPER}_LIBRARY_RELEASE NAMES ${NAME}
        
        HINTS
        ${FFMPEG_INCLUDE_DIR}/..
        
        PATHS
        $ENV{FFMPEG_DIR}
        /usr
        /usr/local
        /sw
        /opt/local

        PATH_SUFFIXES
        /lib
        /build/code
        /build-debug/code

        DOC "The ${NAME} library (release)")

    # find debug library
    find_library(FFMPEG_${NAME_UPPER}_LIBRARY_DEBUG NAMES "${NAME}d"
        
        HINTS
        ${FFMPEG_INCLUDE_DIR}/..

        PATHS
        $ENV{FFMPEG_DIR}
        /usr
        /usr/local
        /sw
        /opt/local

        PATH_SUFFIXES
        /lib
        /build/code
        /build-debug/code

        DOC "The ${NAME} library (debug)")

    set(FFMPEG_${NAME_UPPER}_LIBRARIES "")
    if(FFMPEG_${NAME_UPPER}_LIBRARY_RELEASE AND FFMPEG_${NAME_UPPER}_LIBRARY_DEBUG)
        set(FFMPEG_${NAME_UPPER}_LIBRARIES 
            optimized   ${FFMPEG_${NAME_UPPER}_LIBRARY_RELEASE}
            debug       ${FFMPEG_${NAME_UPPER}_LIBRARY_DEBUG})
    elseif(FFMPEG_${NAME_UPPER}_LIBRARY_RELEASE)
        set(FFMPEG_${NAME_UPPER}_LIBRARIES ${FFMPEG_${NAME_UPPER}_LIBRARY_RELEASE})
    elseif(FFMPEG_${NAME_UPPER}_LIBRARY_DEBUG)
        set(FFMPEG_${NAME_UPPER}_LIBRARIES ${FFMPEG_${NAME_UPPER}_LIBRARY_DEBUG})
    endif()
    list(APPEND FFMPEG_LIBRARIES ${FFMPEG_${NAME_UPPER}_LIBRARIES})

    # find DLL
    if(WIN32)
        
        # parse versio.h to find major version
        file(READ "${FFMPEG_INCLUDE_DIR}/lib${NAME}/version.h" content)
        string(REGEX MATCH ".*LIB${NAME_UPPER}_VERSION_MAJOR +([0-9]+).*" TMP ${content})
        set(DLL_VERSION ${CMAKE_MATCH_1})

        find_file(FFMPEG_${NAME_UPPER}_BINARY NAMES "${NAME}-${DLL_VERSION}.dll" "${NAME}.dll"

            HINTS
            ${FFMPEG_INCLUDE_DIR}/..
            
            PATHS
            $ENV{FFMPEG_DIR}
            $ENV{FFMPEG_BIN_DIR}

            PATH_SUFFIXES
            /bin

            DOC "The ${NAME} binary")

        list(APPEND FFMPEG_BINARIES ${FFMPEG_${NAME_UPPER}_BINARY})

    endif()

    find_package_handle_standard_args(FFMPEG_${NAME} DEFAULT_MSG FFMPEG_${NAME_UPPER}_LIBRARIES)
    
endmacro(find_component)


# find include path
find_path(FFMPEG_INCLUDE_DIR libavcodec/avcodec.h

    PATHS
    $ENV{FFMPEG_DIR}
    /usr
    /usr/local
    /sw
    /opt/local

    PATH_SUFFIXES
    /include

    DOC "The directory where libavcodec/avcodec.h resides")


# Load components
set(AVAILABLE_COMPONENTS avcodec avdevice avfilter avformat avutil postproc swresample swscale)
foreach(COMPONENT ${FFMPEG_FIND_COMPONENTS})
    list(FIND AVAILABLE_COMPONENTS ${COMPONENT} INDEX)
    if(INDEX EQUAL -1)
        message(FATAL_ERROR " Unknown component: ${COMPONENT}")
    endif()
    find_component(${COMPONENT})
endforeach(COMPONENT)


find_package_handle_standard_args(FFMPEG
    REQUIRED_VARS FFMPEG_LIBRARIES FFMPEG_INCLUDE_DIR
    HANDLE_COMPONENTS)
