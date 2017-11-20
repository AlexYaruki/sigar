cmake_minimum_required(VERSION 3.5)
project(sigar_jni)

# Path to main sigar library
link_directories(${CMAKE_SOURCE_DIR}/../../../build/build-src)

# Path to main sigar library headers
include_directories(${CMAKE_SOURCE_DIR}/../../../include)

set(LINK_LIBRARIES sigar)

find_package(JNI)
if(JNI_FOUND)
    include_directories("${JNI_INCLUDE_DIRS}")
    set(LINK_LIBRARIES ${LINK_LIBRARIES} ${JNI_LIBRARIES})
else()
    message(FATAL_ERROR "JNI not found")
endif()
include_directories(include)
set(SRCS src/javasigar.c)

set(LIBRARY_NAME "sigar")

if(CMAKE_SYSTEM_PROCESSOR STREQUAL "x86_64" OR CMAKE_SYSTEM_PROCESSOR STREQUAL "AMD64")
    set(LIBRARY_NAME "${LIBRARY_NAME}-amd64")
elseif(CMAKE_SYSTEM_PROCESSOR STREQUAL "armv7l")
    set(LIBRARY_NAME "${LIBRARY_NAME}-armv7")
else()
    message(FATAL_ERROR "Processor architecture not supported: ${CMAKE_SYSTEM_PROCESSOR}")
endif()

if(CMAKE_SYSTEM_NAME STREQUAL "Linux")
    set(LIBRARY_NAME "${LIBRARY_NAME}-linux")
    include_directories(${CMAKE_SOURCE_DIR}/../../../src/os/linux)
elseif(CMAKE_SYSTEM_NAME STREQUAL "Darwin")
    set(LIBRARY_NAME "${LIBRARY_NAME}-darwin")
    include_directories(${CMAKE_SOURCE_DIR}/../../../src/os/darwin)
elseif(CMAKE_SYSTEM_NAME STREQUAL "Windows")
    set(LIBRARY_NAME "${LIBRARY_NAME}-winnt")
    include_directories(${CMAKE_SOURCE_DIR}/../../../src/os/darwin)
else()
    message(FATAL_ERROR "Operating system not supported: ${CMAKE_SYSTEM_NAME}")
endif()

message(STATUS "Library name: ${LIBRARY_NAME}")

add_library(${LIBRARY_NAME} SHARED ${SRCS})
add_custom_command(TARGET ${LIBRARY_NAME} POST_BUILD COMMAND "${CMAKE_COMMAND}" "-E" "copy" "$<TARGET_FILE:${LIBRARY_NAME}>" "${CMAKE_SOURCE_DIR}/../src/main/resources/org/hyperic/sigar/$<TARGET_FILE_NAME:${LIBRARY_NAME}>")
target_link_libraries(${LIBRARY_NAME} ${LINK_LIBRARIES})
