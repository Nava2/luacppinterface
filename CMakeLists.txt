
include(${CMAKE_SOURCE_DIR}/cmake/common.cmake)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(_LUACPP_INCLUDE_DIRS ${CMAKE_CURRENT_LIST_DIR}/../lua/src
                         ${CMAKE_CURRENT_BINARY_DIR}/../lua/ ) # lua.conf

include_directories(SYSTEM ${_LUACPP_INCLUDE_DIRS}) # lconf.h is here

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/cmake)

set(libluacpp_SRCS  LuaCppInterface/luacoroutine.cpp
                    LuaCppInterface/luareference.cpp
                    LuaCppInterface/luacppinterface.cpp
                    LuaCppInterface/luatable.cpp
                    LuaCppInterface/luafunction.cpp)

if(COMPILER_IS_MSVC)
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

if(${BUILD_TYPE} STREQUAL "release")
    if(COMPILER_IS_GCC OR COMPILER_IS_CLANG)
        target_compile_options(libluacpp PUBLIC -Wno-error=unused-variable)
    endif()
endif(${BUILD_TYPE} STREQUAL "release")


set(LUACPP_INCLUDE_DIRS ${CMAKE_CURRENT_LIST_DIR} ${_LUACPP_INCLUDE_DIRS} PARENT_SCOPE)
set(LUACPP_LIBRARY_DIR ${CMAKE_CURRENT_BINARY_DIR} PARENT_SCOPE)



