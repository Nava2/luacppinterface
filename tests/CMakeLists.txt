
include_directories(${CMAKE_SOURCE_DIR}/LuaCppInterface)
include_directories(SYSTEM ${LUACPP_SYSTEM_INCLUDE_DIRS})

set(CATCH_HPP_URL "https://raw.githubusercontent.com/philsquared/Catch/master/single_include/catch.hpp")
set(CATCH_HPP ${CMAKE_CURRENT_BINARY_DIR}/include/catch.hpp)

get_filename_component(CATCH_HPP_DIR ${CATCH_HPP} DIRECTORY CACHE)

if(VERBOSE)
    message(STATUS "Downloading <catch.hpp> -> ${CATCH_HPP_DIR}")
endif(VERBOSE)

file(DOWNLOAD ${CATCH_HPP_URL} ${CATCH_HPP} SHOW_PROGRESS)
include_directories(SYSTEM ${CMAKE_CURRENT_BINARY_DIR}/include)

set(tests   testluacpp.cpp
            testbadcppuserdata.cpp
            testcreate.cpp
            testfunction.cpp
            testfunctionparams.cpp
            testfunctionparamsreturn.cpp
            testfunctionreturn.cpp
            testgetsetfunction.cpp
            testgetsetinsidetable.cpp
            testgetsetinteger.cpp
            testgetsetstring.cpp
            testgetsettable.cpp
            testgettypeofvalueat.cpp
            testinvalidscript.cpp
            testpassingfunction.cpp
            testregistry.cpp
            testreturnfromnative.cpp
            testreturnfromscript.cpp
            testreturnfromyieldingfunction.cpp
            testreturntablefromlua.cpp
            testreturntablefromnative.cpp
            testscriptexception.cpp
            testtable.cpp
            testtableforeachintegerkey.cpp
            testtableforeachstringkey.cpp
            testuserdataconstructor.cpp
            testuserdata.cpp
            testuserdatadispose.cpp
            testuserdatamethod.cpp
)

set(test_exes )
foreach(test ${tests})

    get_filename_component(test_name ${test} NAME_WE)

    add_executable(${test_name} ${test})
    target_link_libraries(${test_name} libluacpp liblua)
    add_dependencies(${test_name} libluacpp liblua)

    add_test(NAME ${test_name}
             COMMAND ${test_name}
             WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR})
    set_default_warnings(${test_name})
    link_directories(${LUACPP_LIBRARY_DIR})

    list(APPEND test_exes ${test_name})

endforeach()

add_custom_target(tests COMMAND ${CMAKE_CTEST_COMMAND} 
                        DEPENDS ${test_exes})

# Demos:
set(demos demonstration1.cpp
          demonstration2.cpp
          demonstration3.cpp
          demonstration4.cpp )
foreach(demo ${demos})

    get_filename_component(demo_name ${demo} NAME_WE)

    add_executable(${demo_name} ${demo})
    target_link_libraries(${demo_name} libluacpp liblua)
    add_dependencies(${demo_name} libluacpp liblua)

    set_default_warnings(${demo_name})
    link_directories(${LUACPP_LIBRARY_DIR})

    if(COMPILER_IS_CLANG)
        target_compile_options(${demo_name} PUBLIC -Wno-unused-variable)
    endif()
endforeach()