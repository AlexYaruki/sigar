cmake_minimum_required(VERSION 3.5)
project(sigar_jni)

link_directories(${CMAKE_SOURCE_DIR}/../../../build-src)
include_directories(${CMAKE_SOURCE_DIR}/../../../include)
set(LINK_LIBRARIES sigar_static)
find_package(JNI)
if(JNI_FOUND)
    string(REPLACE ";" " " JNI_HEADER_DIRS ${JNI_INCLUDE_DIRS})
    include_directories("/opt/jdk8/include")
    include_directories("/opt/jdk8/include/linux")
    message(STATUS "JNI: ${JNI_INCLUDE_DIRS}")
    set(LINK_LIBRARIES ${LINK_LIBRARIES} ${JNI_LIBRARIES})
else()
    message(FATAL_ERROR "JNI not found")
endif()
include_directories(include)
set(SRCS src/javasigar.c)

message(STATUS "Library architecture: ${CMAKE_LIBRARY_ARCHITECTURE}")
message(STATUS "System processor: ${CMAKE_SYSTEM_PROCESSOR}")
message(STATUS "System name: ${CMAKE_SYSTEM_NAME}")

set(LIBRARY_NAME "sigar")

if(CMAKE_SYSTEM_PROCESSOR STREQUAL "x86_64")
    set(LIBRARY_NAME "${LIBRARY_NAME}-amd64")
endif()

if(CMAKE_SYSTEM_NAME STREQUAL "Linux")
    set(LIBRARY_NAME "${LIBRARY_NAME}-linux")
    include_directories(${CMAKE_SOURCE_DIR}/../../../src/os/linux)
endif()

message(STATUS "Library name: ${LIBRARY_NAME}")

add_library(${LIBRARY_NAME} SHARED ${SRCS})
target_link_libraries(${LIBRARY_NAME} ${LINK_LIBRARIES})
