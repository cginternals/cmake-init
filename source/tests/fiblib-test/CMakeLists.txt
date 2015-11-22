
# 
# Executable name and options
# 

# Target name
set(target fiblib-test)
message(STATUS "Test ${target}")


# 
# Sources
# 

set(sources
    main.cpp
    fibonacci_test.cpp
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
# Project options
# 

set_target_properties(${target}
    PROPERTIES
    FOLDER                     "${IDE_FOLDER}"
    DEBUG_POSTFIX              "d"
    CXX_STANDARD               11
    LINKER_LANGUAGE            CXX
    POSITION_INDEPENDENT_CODE  ON
)


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
    ${SYSTEM_LIBRARIES}
    template::fiblib
    gmock-dev
    gtest-dev
)


# 
# Compile definitions
# 

target_compile_definitions(${target}
    PRIVATE
    ${DEFAULT_COMPILE_DEFINITIONS}
)


# 
# Compile options
# 

target_compile_options(${target}
    PRIVATE
    ${DEFAULT_COMPILE_OPTIONS}
)
