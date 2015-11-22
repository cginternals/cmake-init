
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
    template::fiblib
    gmock-dev
    gtest-dev
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

set_target_properties(${target}
    PROPERTIES
    POSITION_INDEPENDENT_CODE ON
)

target_compile_options(${target}
    PRIVATE
)
