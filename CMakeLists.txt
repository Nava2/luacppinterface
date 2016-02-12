cmake_minimum_required(VERSION 3.0)
project(luacpp)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/cmake)
include(cmake/common.cmake)

compiler_info()

if (NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE "Debug")
endif()

option(LUACPP_TEST "Build LuaCpp's tests" ON)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(LUACPP_SYSTEM_INCLUDE_DIRS  ${CMAKE_CURRENT_LIST_DIR}/lua/src
                                ${CMAKE_CURRENT_BINARY_DIR}/lua/ ) # lua.conf

include_directories(SYSTEM ${LUACPP_SYSTEM_INCLUDE_DIRS}) # lconf.h is here

add_subdirectory(lua/)
if(COMPILER_IS_CLANG OR COMPILER_IS_GCC)
    # Lua itself doesn't use the hardcore warnings, turn some off:
    set(LUA_COMPILE_DEFINITIONS -Wno-array-bounds)
    if(COMPILER_IS_CLANG)
        list(APPEND LUA_COMPILE_DEFINITIONS -Wno-parentheses-equality -Wno-empty-body)
    endif(COMPILER_IS_CLANG)
    
    target_compile_options(liblua   BEFORE PUBLIC ${LUA_COMPILE_DEFINITIONS})
    target_compile_options(lua      BEFORE PUBLIC ${LUA_COMPILE_DEFINITIONS})
    target_compile_options(luac     BEFORE PUBLIC ${LUA_COMPILE_DEFINITIONS})
endif()

set(libluacpp_SRCS  LuaCppInterface/luacoroutine.cpp
                    LuaCppInterface/luareference.cpp
                    LuaCppInterface/luacppinterface.cpp
                    LuaCppInterface/luatable.cpp
                    LuaCppInterface/luafunction.cpp)

if(COMPILER_IS_MSVC) # Link statically on windows :/
    add_library(libluacpp STATIC ${libluacpp_SRCS} )
else()
    add_library(libluacpp SHARED ${libluacpp_SRCS} )
endif()

set_target_properties(libluacpp PROPERTIES OUTPUT_NAME luacppinterface 
                                           CLEAN_DIRECT_OUTPUT 1 )
set_default_warnings(libluacpp)
target_link_libraries(libluacpp liblua)

if(COMPILER_IS_MSVC)
    target_compile_options(libluacpp PUBLIC /wd4514 /wd4548)
endif()

if(${CMAKE_BUILD_TYPE} STREQUAL "Release")
    if(COMPILER_IS_GCC OR COMPILER_IS_CLANG)
        target_compile_options(libluacpp PUBLIC -Wno-error=unused-variable)
    endif()
endif()

set(LUACPP_INCLUDE_DIRS ${CMAKE_CURRENT_LIST_DIR} ${LUACPP_SYSTEM_INCLUDE_DIRS})
set(LUACPP_LIBRARY_DIR ${CMAKE_CURRENT_BINARY_DIR})


if(LUACPP_TEST)
    enable_testing()

    add_subdirectory(tests/)
endif(LUACPP_TEST)

