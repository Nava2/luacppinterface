
set(CMAKE_CXX_STANDARD 11)

# Configure the compiler:
if (APPLE)
    set(CMAKE_MACOSX_RPATH true)
endif(APPLE)

# Macro that sets the default warnings for the library code.
# These warnings are high, so it is not recommended to apply these to any external target
# TODO: Make this operate at the `target` level
macro(set_default_warnings target)
    if(NOT MSVC)
        target_compile_options(${target} PUBLIC -Wall -Werror -pedantic)

        if(COMPILER_IS_GCC)

        elseif(COMPILER_IS_CLANG)

        endif()
    else()
        target_compile_options(${target} PUBLIC /W2 /WX /wd4996 )
    endif()
endmacro(set_default_warnings)

# Reads information for the compiler in an easier to consume format
macro(compiler_info)
    # Taken from: OpenImageIO/oiio https://github.com/OpenImageIO/oiio/blob/master/CMakeLists.txt
    # Figure out which compiler we're using, for tricky cases
    if(CMAKE_CXX_COMPILER_ID MATCHES "Clang" OR CMAKE_CXX_COMPILER MATCHES "[Cc]lang")
        # If using any flavor of clang, set CMAKE_COMPILER_IS_CLANG. If it's
        # Apple's variety, set CMAKE_COMPILER_IS_APPLECLANG and
        # APPLECLANG_VERSION_STRING, otherwise for generic clang set
        # CLANG_VERSION_STRING.
        set(COMPILER_IS_CLANG 1)
        set(COMPILER_ID "clang")

        execute_process(COMMAND ${CMAKE_CXX_COMPILER} --version OUTPUT_VARIABLE clang_full_version_string)
        if(clang_full_version_string MATCHES "Apple")
            # Apple is special
            string(REGEX REPLACE ".* version ([0-9]+\\.[0-9]+).*" "\\1" CLANG_VERSION_STRING ${clang_full_version_string})
            set(COMPILER_ID "apple-clang")
        else()
            string(REGEX REPLACE ".* version ([0-9]+\\.[0-9]+).*" "\\1" CLANG_VERSION_STRING ${clang_full_version_string})
        endif()

        set(COMPILER_VERSION_STRING ${CLANG_VERSION_STRING})
    elseif(CMAKE_CXX_COMPILER_ID MATCHES "Intel")
        # Intel compiler 
        set(COMPILER_IS_INTEL 1)
        set(COMPILER_ID "intel")

        set(COMPILER_VERSION_STRING "unknown")
    elseif(CMAKE_COMPILER_IS_GNUCC AND UNIX)
        # GCC
        execute_process(COMMAND ${CMAKE_CXX_COMPILER} -dumpversion
                                 OUTPUT_VARIABLE GCC_VERSION_STRING
                                 OUTPUT_STRIP_TRAILING_WHITESPACE)

        set(COMPILER_IS_GCC 1)
        set(COMPILER_ID "gcc")
        
        set(COMPILER_VERSION_STRING ${GCC_VERSION_STRING})
    elseif(MSVC)
        set(COMPILER_IS_MSVC 1)
        set(COMPILER_ID "msvc")

        string(REGEX REPLACE "([0-9][0-9])([0-9][0-9])" "\\1.\\2" MSVC_VERSION_STRING ${MSVC_VERSION})

        set(COMPILER_VERSION_STRING ${MSVC_VERSION_STRING})
    endif()
    
    set(COMPILER_VERSION_STRING_LONG ${COMPILER_ID}-${COMPILER_VERSION_STRING})

    if(VERBOSE)
        message(STATUS "Found Compiler Information:")
        message(STATUS "    CMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}")
        message(STATUS "    CMAKE_CXX_COMPILER_ID=${CMAKE_CXX_COMPILER_ID}")
        message(STATUS "    COMPILER_VERSION_STRING=${COMPILER_VERSION_STRING}")
        message(STATUS "    COMPILER_VERSION_STRING_LONG=${COMPILER_VERSION_STRING_LONG}")
    endif()

    string(TOLOWER ${CMAKE_BUILD_TYPE} BUILD_TYPE)
endmacro(compiler_info)
