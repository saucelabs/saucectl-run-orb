#!/usr/bin/env bash


install() {
    declare -A platforms=([Darwin]=mac [Linux]=linux [Windows]=win)
    declare -A archs=([i386]=32-bit [x86_64]=64-bit)
    declare -A exts=([mac]=tar.gz [linux]=tar.gz [win]=zip)

    src_platform=${1}
    src_arch=${2}
    version=${3}

    platform=${platforms[$src_platform]}
    arch=${archs[$src_arch]}
    
    # Check value
    if [ -z "${platform}" ] || [ -z "${arch}" ]; then
        echo "Unexpected platform (${src_platform} / ${platform}) or arch (${src_arch} / ${arch})"
        exit 1
    fi

    if [[ "${version}" =~ "^v?([0-9]+)\.([0-9]+)\.([0-9]+)\$" ]]; then
        echo "version: ${version} has an unexpected format"
        exit 1
    fi
    version=${version/v/}

    # Fetch and install
    ext=${exts[$platform]}
    download_url="https://github.com/saucelabs/saucectl/releases/download/v${version}/saucectl_${version}_${platform}_${arch}.${ext}"
    check_url="https://github.com/saucelabs/saucectl/releases/tag/v${version}"

    # Check version existance
    if ! curl -I -f "${check_url}" > /dev/null 2>&1;then
        echo "Version v${version} is not available"
        exit 1
    fi

    tmpname=$(mktemp -d)
    echo ${tmpname}
    echo ${download_url}
    curl -L -s "${download_url}" | tar -xvz -C "${tmpname}" saucectl || (
        echo "Failed to download / install saucectl"
        exit 1
    )

    SAUCECTL_BIN_PATH=${tmpname}/saucectl
}

run() {
    ${SAUCECTL_BIN_PATH} run
}

SAUCECTL_BIN_PATH=

install "$(uname -s)" "$(uname -m)" v0.26.0
echo "saucectl installed: ${SAUCECTL_BIN_PATH}"
run
echo "saucectl: runned"