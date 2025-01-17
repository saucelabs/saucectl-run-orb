#!/usr/bin/env bash

declare -A platforms=([Darwin]=mac [Linux]=linux [Windows]=win)
declare -A archs=([i386]=32-bit [x86_64]=64-bit)
declare -A exts=([mac]=tar.gz [linux]=tar.gz [win]=zip)
declare ARGS

SAUCECTL_VERSION=
SAUCECTL_BIN_PATH=

install() {
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

    # Fetch and install
    ext=${exts[$platform]}
    download_url="https://github.com/saucelabs/saucectl/releases/download/v${version}/saucectl_${version}_${platform}_${arch}.${ext}"

    tmpname=$(mktemp -d)
    curl -L -s "${download_url}" | tar -xz -C "${tmpname}" saucectl || (
        echo "Failed to download / install saucectl"
        exit 1
    )

    SAUCECTL_BIN_PATH=${tmpname}/saucectl
}

# Check version existence / Resolve latest
resolve_version() {
    if [ "${PARAM_SAUCECTL_VERSION}" = "latest" ] || [ -z "${PARAM_SAUCECTL_VERSION}" ];then
        SAUCECTL_VERSION=$(curl -s https://api.github.com/repos/saucelabs/saucectl/releases/latest | jq -r '.name')
        SAUCECTL_VERSION=${SAUCECTL_VERSION/v/}
    else
        if [[ "${version}" =~ ^v?([0-9]+)\.([0-9]+)\.([0-9]+)\$ ]]; then
            echo "version: ${version} has an unexpected format"
            exit 1
        fi
        version=${version/v/}

        check_url="https://github.com/saucelabs/saucectl/releases/tag/v${version}"
        if ! curl -I -f "${check_url}" > /dev/null 2>&1;then
            echo "Version v${version} is not available"
            exit 1
        fi
        SAUCECTL_VERSION=${version}
    fi
}

parse_args() {
    if [ -n "${PARAM_CONFIG_FILE}" ];then
        ARGS+=("-c" "${PARAM_CONFIG_FILE}")
    fi

    if [ -n "${PARAM_REGION}" ];then
        ARGS+=("--region" "${PARAM_REGION}")
    fi

    if [ -n "${PARAM_SUITE}" ];then
        ARGS+=("--select-suite" "${PARAM_SUITE}")
    fi

    if [ -n "${PARAM_WORKING_DIRECTORY}" ];then
        echo "Changing directory to ${PARAM_WORKING_DIRECTORY}"
        cd "${PARAM_WORKING_DIRECTORY}" || exit 1
    fi

    # Boolean environment variables are parsed as 0 or 1.
    if [ "${PARAM_SHOW_CONSOLE_LOG}" == "1" ]; then
        ARGS+=("--show-console-log")
    fi

    if [ -n "${PARAM_SAUCEIGNORE}" ];then
        ARGS+=("--sauceignore" "${PARAM_SAUCEIGNORE}")
    fi

    if [ -n "${PARAM_ENV}" ];then
        while read -r LINE;do
            if [ -n "${LINE}" ];then
                ARGS+=("-e" "${LINE}")
            fi
        done <<< "${PARAM_ENV}"
    fi

    if [ -n "${PARAM_TIMEOUT}" ];then
        ARGS+=("--timeout" "${PARAM_TIMEOUT}")
    fi

    if [ -n "${PARAM_TUNNEL_NAME}" ];then
        ARGS+=("--tunnel-name" "${PARAM_TUNNEL_NAME}")
    fi

    if [ -n "${PARAM_TUNNEL_OWNER}" ];then
        ARGS+=("--tunnel-owner" "${PARAM_TUNNEL_OWNER}")
    fi

    if [ -n "${PARAM_TUNNEL_TIMEOUT}" ];then
        ARGS+=("--tunnel-timeout" "${PARAM_TUNNEL_TIMEOUT}")
    fi

    if [ -n "${PARAM_CCY}" ];then
        ARGS+=("--ccy" "${PARAM_CCY}")
    fi

    if [ -n "${PARAM_RETRIES}" ];then
        ARGS+=("--retries" "${PARAM_RETRIES}")
    fi

    if [ "${PARAM_ASYNC}" == "1" ];then
        ARGS+=("--async")
    fi
}

run() {
    # Set environment variables if credentials are given through params
    if [ -n "${PARAM_SAUCE_USERNAME}" ];then
        export SAUCE_USERNAME=${PARAM_SAUCE_USERNAME}
    fi
    if [ -n "${PARAM_SAUCE_ACCESS_KEY}" ];then
        export SAUCE_ACCESS_KEY=${PARAM_SAUCE_ACCESS_KEY}
    fi

    echo Running "${SAUCECTL_BIN_PATH}" run "${ARGS[@]}"
    ${SAUCECTL_BIN_PATH} run "${ARGS[@]}"
}


# Will not run if sourced for bats.
# View src/tests for more information.
TEST_ENV="bats-core"
if [ "${0#*"$TEST_ENV"}" == "$0" ]; then
    resolve_version
    install "$(uname -s)" "$(uname -m)" "${SAUCECTL_VERSION}"
    echo "saucectl installed at: ${SAUCECTL_BIN_PATH}"
    parse_args
    run
    echo "saucectl test completed"
fi
