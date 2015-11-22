
# 
# External dependencies
# 

find_package(Qt5Core    5.1 QUIET)
find_package(Qt5Gui     5.1 QUIET)
find_package(Qt5Widgets 5.1 QUIET)

# Enable automoc
set(CMAKE_AUTOMOC ON)
set(AUTOMOC_MOC_OPTIONS PROPERTIES FOLDER CMakeAutomocTargets)
set_property(GLOBAL PROPERTY AUTOMOC_FOLDER CMakeAutomocTargets)

# ENABLE CMP0020: Automatically link Qt executables to qtmain target on Windows.
if (POLICY CMP0020)
    cmake_policy(SET CMP0020 NEW)
endif()


# 
# Executable name and options
# 

# Target name
set(target fibgui)
message(STATUS "App ${target}")

# Exit here if required dependencies are not met
if (NOT Qt5Core_FOUND)
    message("Example ${target} skipped: Qt5 not found")
    return()
endif()


# 
# Sources
# 

set(sources
    main.cpp
    MainWindow.cpp
    MainWindow.h
)


# 
# Create executable
# 

# Build executable
add_executable(${target}
    ${sources}
)

# Create namespaced alias
add_executable(${META_PROJECT_NAME}::${target} ALIAS ${target})


# 
# Includes
# 

target_include_directories(${target}
    PRIVATE
    ${PROJECT_BINARY_DIR}/source/include
)


# 
# Libraries
# 

target_link_libraries(${target}
    PRIVATE
    Qt5::Core
    Qt5::Gui
    Qt5::Widgets
    template::baselib
    template::fiblib
)


# 
# Compile definitions
# 

target_compile_definitions(${target}
    PRIVATE
)


# 
# Compile options
# 

# [TODO] Make this global or put it in every project
set_target_properties(${target}
    PROPERTIES
    POSITION_INDEPENDENT_CODE ON
    CXX_STANDARD              11
)

target_compile_options(${target}
    PRIVATE
)


# 
# Deployment
# 

# Executable
install(TARGETS ${target}
    RUNTIME DESTINATION ${INSTALL_BIN}
)
