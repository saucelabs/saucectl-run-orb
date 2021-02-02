#!/usr/bin/env bash

declare -A platforms
declare -A archs
declare -A exts

platforms=([Darwin]=mac [Linux]=linux [Windows]=win)
archs=([i386]=32-bits [x86_64]=64-bits)
exts=([mac]=tar.gz [linux]=tar.gz [win]=zip)

install() {
    src_platform=${1}
    src_arch=${2}
    version=${3}

    platform=${platforms[src_platform]}
    arch=${archs[src_arch]}
    
    # Check value
    if [ -z "${platform}" ] || [ -z "${arch}" ]; then
        echo "Unexpected platform or arch"
        exit 1
    fi

    if [[ "${version}" =~ ^v?([0-9]+)\.([0-9]+)\.([0-9]+)$ ]]; then
        echo "version: ${version} has an unexpected format"
        exit 1
    fi
    version=${version/v/}

    # Fetch and install
    ext=${exts[$platform]}
    download_url="https://github.com/saucelabs/saucectl/releases/download/v${version}/saucectl_${version}_${platform}_${arch}.${ext}"
    check_url="https://github.com/saucelabs/saucectl/releases/tag/v${version}"

    # Check version existance
    curl -I -f "${check_url}"  2>&1 > /dev/null
    if [ ${?} != 0 ];then
        echo "Version v${version} is not available"
        exit 1
    fi

    tmpname=$(mktemp -d saucectl)
    curl "${download_url}" | tar -xvz -C "${tmpname}" || (
        echo "Failed to download / install saucectl"
        exit 1
    )

    SAUCECTL_BIN_PATH=${tmpname}/saucectl
}

run() {
    ${SAUCECTL_BIN_PATH} run
}

bash --version

SAUCECTL_BIN_PATH=
install
echo "saucectl installed: ${SAUCECTL_BIN_PATH}"
run

echo "saucectl: runned"