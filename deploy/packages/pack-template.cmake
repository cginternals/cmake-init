
# 
# Check if cpack is available
# 

if(NOT EXISTS "${CMAKE_ROOT}/Modules/CPack.cmake")
    return()
endif()


# 
# Package configuration
# 

# Output packages
if(OPTION_PORTABLE_INSTALL)
    # Create a relocatable installation without any dependencies
    set(OPTION_PACK_GENERATOR "ZIP;TGZ;STGZ" CACHE STRING "Package targets")
    set(OPTION_COMPONENT_INSTALL OFF)
else()
    # Create a system installation package
    if("${CMAKE_SYSTEM_NAME}" MATCHES "Windows")
        # Windows installer
        set(OPTION_PACK_GENERATOR "NSIS" CACHE STRING "Package targets")
    elseif("${CMAKE_SYSTEM_NAME}" MATCHES "Darwin")
        # MacOS X installer
        set(OPTION_PACK_GENERATOR "PackageMaker" CACHE STRING "Package targets")
    else()
        # Linux package
        set(OPTION_PACK_GENERATOR "DEB;RPM" CACHE STRING "Package targets")
    endif()

    # Install component-wise?
    if(OPTION_SELFCONTAINED_INSTALL)
        set(OPTION_COMPONENT_INSTALL OFF)
    else()
        set(OPTION_COMPONENT_INSTALL ON)
    endif()
endif()

# Components
set(CPACK_COMPONENTS_ALL runtime dev examples docs)

set(CPACK_COMPONENT_RUNTIME_DISPLAY_NAME "Template library")
set(CPACK_COMPONENT_RUNTIME_DESCRIPTION "Runtime components for template library")

set(CPACK_COMPONENT_DEV_DISPLAY_NAME "C/C++ development files")
set(CPACK_COMPONENT_DEV_DESCRIPTION "Development files for template library")
set(CPACK_COMPONENT_DEV_DEPENDS runtime)

set(CPACK_COMPONENT_EXAMPLES_DISPLAY_NAME "Example applications")
set(CPACK_COMPONENT_EXAMPLES_DESCRIPTION "Example applications for template library")
set(CPACK_COMPONENT_EXAMPLES_DEPENDS runtime)

set(CPACK_COMPONENT_DOCS_DISPLAY_NAME "Documentation")
set(CPACK_COMPONENT_DOCS_DESCRIPTION "Documentation of template library")


# 
# Initialize CPack
# 

# Reset CPack configuration
if(EXISTS "${CMAKE_ROOT}/Modules/CPack.cmake")
    set(CPACK_IGNORE_FILES "")
    set(CPACK_INSTALLED_DIRECTORIES "")
    set(CPACK_SOURCE_IGNORE_FILES "")
    set(CPACK_SOURCE_INSTALLED_DIRECTORIES "")
    set(CPACK_STRIP_FILES "")
    set(CPACK_SOURCE_TOPLEVEL_TAG "")
    set(CPACK_SOURCE_PACKAGE_FILE_NAME "")
endif()

# Find cpack executable
get_filename_component(CPACK_PATH ${CMAKE_COMMAND} PATH)
set(CPACK_COMMAND "${CPACK_PATH}/cpack")

# Set install prefix
if(OPTION_PORTABLE_INSTALL)
    set(CPACK_PACKAGING_INSTALL_PREFIX "")
else()
    set(CPACK_PACKAGING_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")
endif()

# Package project
set(project_name ${META_PROJECT_NAME})   # Name of package project
set(project_root ${META_PROJECT_NAME})   # Name of root project that is to be installed

# Package information
string(TOLOWER ${META_PROJECT_NAME} package_name)
set(package_description ${META_PROJECT_DESCRIPTION})
set(package_vendor      ${META_AUTHOR_ORGANIZATION})
set(package_maintainer  ${META_AUTHOR_MAINTAINER}) 

# Package specific options
set(CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/deploy/packages/${project_name})


# 
# Package information
# 

set(CPACK_PACKAGE_NAME                  "${package_name}")
set(CPACK_PACKAGE_VENDOR                "${package_vendor}")
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY   "${package_description}")
set(CPACK_PACKAGE_VERSION               "${META_VERSION}")
set(CPACK_PACKAGE_VERSION_MAJOR         "${META_VERSION_MAJOR}")
set(CPACK_PACKAGE_VERSION_MINOR         "${META_VERSION_MINOR}")
set(CPACK_PACKAGE_VERSION_PATCH         "${META_VERSION_PATCH}")
set(CPACK_RESOURCE_FILE_LICENSE         "${PROJECT_SOURCE_DIR}/LICENSE")
set(CPACK_RESOURCE_FILE_README          "${PROJECT_SOURCE_DIR}/README.md")
set(CPACK_RESOURCE_FILE_WELCOME         "${PROJECT_SOURCE_DIR}/README.md")
set(CPACK_PACKAGE_DESCRIPTION_FILE      "${PROJECT_SOURCE_DIR}/README.md")
set(CPACK_PACKAGE_ICON                  "${PROJECT_SOURCE_DIR}/packages/logo.bmp")
set(CPACK_PACKAGE_RELOCATABLE           OFF)


# 
# NSIS package
# 

# Fix icon path
if("${CMAKE_SYSTEM_NAME}" MATCHES "Windows" AND CPACK_PACKAGE_ICON)
    # NOTE: for using MUI (UN)WELCOME images we suggest to replace nsis defaults,
    # since there is currently no way to do so without manipulating the installer template (which we won't).
    # http://public.kitware.com/pipermail/cmake-developers/2013-January/006243.html

    # SO the following only works for the installer icon, not for the welcome image.

    # NSIS requires "\\" - escaped backslash to work properly. We probably won't rely on this feature, 
    # so just replacing / with \\ manually.

    #file(TO_NATIVE_PATH "${CPACK_PACKAGE_ICON}" CPACK_PACKAGE_ICON) 
    string(REGEX REPLACE "/" "\\\\\\\\" CPACK_PACKAGE_ICON "${CPACK_PACKAGE_ICON}")
endif()

# Fix installation path for x64 builds
if(X64)
    # http://public.kitware.com/Bug/view.php?id=9094
    set(CPACK_NSIS_INSTALL_ROOT "$PROGRAMFILES64")
endif()

# Package options
#set(CPACK_NSIS_DISPLAY_NAME "${package_name}-${META_VERSION}")
set(CPACK_NSIS_MUI_ICON      "${PROJECT_SOURCE_DIR}/packages/logo.ico")
set(CPACK_NSIS_MUI_UNIICON   "${PROJECT_SOURCE_DIR}/packages/logo.ico")

# Optional Preliminaries (i.e., silent Visual Studio Redistributable install)
if(NOT INSTALL_MSVC_REDIST_FILEPATH)
    set(INSTALL_MSVC_REDIST_FILEPATH "" CACHE FILEPATH "Visual C++ Redistributable Installer (note: manual match the selected generator)" FORCE)
endif()

if(EXISTS ${INSTALL_MSVC_REDIST_FILEPATH})
    get_filename_component(MSVC_REDIST_NAME ${INSTALL_MSVC_REDIST_FILEPATH} NAME)
    string(REGEX REPLACE "/" "\\\\\\\\" INSTALL_MSVC_REDIST_FILEPATH ${INSTALL_MSVC_REDIST_FILEPATH})
    list(APPEND CPACK_NSIS_EXTRA_INSTALL_COMMANDS "
        SetOutPath \\\"$TEMP\\\"
        File \\\"${INSTALL_MSVC_REDIST_FILEPATH}\\\"
        ExecWait '\\\"$TEMP\\\\${MSVC_REDIST_NAME} /quiet\\\"'
        Delete \\\"$TEMP\\\\${MSVC_REDIST_NAME}\\\"
        ")
endif()


# 
# Debian package
# 

set(CPACK_DEBIAN_PACKAGE_NAME           "${package_name}")
set(CPACK_DEBIAN_PACKAGE_VERSION        "${CPACK_PACKAGE_VERSION}")
set(CPACK_DEBIAN_PACKAGE_ARCHITECTURE   "all")
#set(CPACK_DEBIAN_PACKAGE_DEPENDS       "libc6 (>= 2.3.1-6), libgcc1 (>= 1:3.4.2-12)")
set(CPACK_DEBIAN_PACKAGE_MAINTAINER     "${package_maintainer}")
set(CPACK_DEBIAN_PACKAGE_DESCRIPTION    "${CPACK_PACKAGE_DESCRIPTION_SUMMARY}")
set(CPACK_DEBIAN_PACKAGE_SECTION        "devel")
set(CPACK_DEBIAN_PACKAGE_PRIORITY       "optional")
#set(CPACK_DEBIAN_PACKAGE_RECOMMENDS    "")
#set(CPACK_DEBIAN_PACKAGE_SUGGESTS      "")
set(CPACK_DEBIAN_PACKAGE_CONTROL_EXTRA  "")


# 
# RPM package
# 

set(CPACK_RPM_PACKAGE_NAME                            "${package_name}")
set(CPACK_RPM_PACKAGE_VERSION                         "${CPACK_PACKAGE_VERSION}")
set(CPACK_RPM_PACKAGE_RELEASE                         1)
set(CPACK_RPM_PACKAGE_ARCHITECTURE                    "x86_64")
set(CPACK_RPM_PACKAGE_REQUIRES                        "")
set(CPACK_RPM_PACKAGE_PROVIDES                        "")
set(CPACK_RPM_PACKAGE_VENDOR                          "${package_vendor}")
set(CPACK_RPM_PACKAGE_LICENSE                         "MIT")
set(CPACK_RPM_PACKAGE_SUMMARY                         "${CPACK_PACKAGE_DESCRIPTION_SUMMARY}")
set(CPACK_RPM_PACKAGE_DESCRIPTION                     "")
set(CPACK_RPM_PACKAGE_GROUP                           "unknown")
#set(CPACK_RPM_SPEC_INSTALL_POST                      "")
#set(CPACK_RPM_SPEC_MORE_DEFINE                       "")
#set(CPACK_RPM_USER_BINARY_SPECFILE                   "")
#set(CPACK_RPM_GENERATE_USER_BINARY_SPECFILE_TEMPLATE "")
#set(CPACK_RPM_<POST/PRE>_<UN>INSTALL_SCRIPT_FILE     "")
#set(CPACK_RPM_PACKAGE_DEBUG                          1)
set(CPACK_RPM_PACKAGE_RELOCATABLE                     OFF)


# 
# Execute CPack
# 

# Package name
set(CPACK_PACKAGE_FILE_NAME "${package_name}-${CPACK_PACKAGE_VERSION}")

# Install files
#set(CPACK_INSTALL_CMAKE_PROJECTS        "${PROJECT_BINARY_DIR};${project_root};ALL;/")
set(CPACK_PACKAGE_INSTALL_DIRECTORY     "${package_name}")
set(CPACK_PACKAGE_INSTALL_REGISTRY_KEY  "${package_name}")
set(CPACK_INCLUDE_TOPLEVEL_DIRECTORY           OFF)
set(CPACK_COMPONENT_INCLUDE_TOPLEVEL_DIRECTORY OFF)

# Set component installation mode
set(CPACK_DEB_COMPONENT_INSTALL         ${OPTION_COMPONENT_INSTALL})
set(CPACK_RPM_COMPONENT_INSTALL         ${OPTION_COMPONENT_INSTALL})
set(CPACK_ARCHIVE_COMPONENT_INSTALL     ${OPTION_COMPONENT_INSTALL})

# Set generator
set(CPACK_OUTPUT_CONFIG_FILE "${PROJECT_BINARY_DIR}/CPackConfig-${project_name}.cmake")
set(CPACK_GENERATOR ${OPTION_PACK_GENERATOR})

# CPack
if(NOT "${CMAKE_SYSTEM_NAME}" MATCHES "Windows")
    # Important: Must be set to install files to absolute path (e.g., /etc)
    # -> CPACK_[RPM_]PACKAGE_RELOCATABLE = OFF

    # But this breaks rpath on portable installs
    #set(CPACK_SET_DESTDIR ON)
endif()
set(CPack_CMake_INCLUDED FALSE)
include(CPack)


# 
# Package target
# 

# Create target
add_custom_target(
    pack-${project_name}
    COMMAND ${CPACK_COMMAND} --config ${PROJECT_BINARY_DIR}/CPackConfig-${project_name}.cmake
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
)
set_target_properties(pack-${project_name} PROPERTIES EXCLUDE_FROM_DEFAULT_BUILD 1)

# Set dependencies
add_dependencies(pack pack-${project_name})
if(MSVC)
    add_dependencies(pack-${project_name} ALL_BUILD)
endif()
