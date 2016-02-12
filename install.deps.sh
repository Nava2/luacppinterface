#!/usr/bin/env bash

# This script installs and configures the dependencies for the project

case `uname` in 
    Darwin)     export OS_NAME="osx"    ;;
    Linux)      export OS_NAME="linux"  ;;
esac

echo "Building on: ${OS_NAME}"

if env | grep -qE '^(?:TRAVIS|CI)='; then
#    We're on Travis, intialize variables:
    echo "Detected CI Build -> CI=${CI}"
else
#   We're building locally
    export CI=false
    echo "Detected Local Build -> CI=${CI}"
fi

export_compiler_vars() {
    case ${COMPILER} in
        appleclang*) 
            export CC=clang
            export CXX=clang++
        ;;

        clang*)
            export CC=$(echo ${COMPILER} | sed 's/\+//g')
            export CXX=${COMPILER}
        ;;

        g++-*)
            export CC=$(echo ${COMPILER} | sed 's/\+/c/g')
            export CXX=${COMPILER} 
        ;;

        *) echo "Invalid compiler version" ; exit 2 ;;
    esac

    echo "CC=${CC}"
    $CC --version

    echo "CXX=${CXX}"
    $CXX --version
}

install_os_deps() {
    # Install all of the OS specific OS dependencies
    echo "Install: os-based dependencies"

    local wd=`pwd`

    case ${OS_NAME} in
        osx)
            export HOMEBREW_NO_EMOJI=1

            echo "brew update ..."; brew update > /dev/null

            case ${COMPILER} in

                appleclang*) ;;

                g++-5)
                    brew install gcc5 
                    brew link gcc5 --overwrite --force
                ;;

                g++-4.9) ;;

                *) echo "Invalid compiler version" ; exit 2 ;;
            esac
            
            export_compiler_vars 
 
            brew unlink cmake 
            brew install cmake ccache
        ;;

        linux) 
            export_compiler_vars
            
        ;;
    esac

    cd ${wd}
}

install_manual_deps() {
    echo "Install: manual dependencies"

    local wd=`pwd`

    case ${OS_NAME} in
        osx)

        ;;

        linux)

        ;;

    esac

    cd ${wd}
}
