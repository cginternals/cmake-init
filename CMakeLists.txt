cmake_minimum_required(VERSION 2.8.9 FATAL_ERROR)

project(SimpleProject C CXX)
set(target simple)

find_package(template)

include_directories(
    ${TEMPLATE_INCLUDES}
    ${CMAKE_SOURCE_DIR}/source
)

set(libs
    ${TEMPLATE_LIBRARIES}
)

set(SOURCE "${CMAKE_SOURCE_DIR}/source")
set(sources
    ${SOURCE}/main.cpp
)

add_executable(${target} ${sources})

target_link_libraries(${target} ${libs})
