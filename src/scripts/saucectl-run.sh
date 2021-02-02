# PARAM_SAUCECTL_VERSION: <<parameters.saucectl_version>>
# PARAM_SAUCE_USERNAME: <<parameters.sauce_username>>
# PARAM_SAUCE_ACCESS_KEY: <<parameters.sauce_access_key>>
# PARAM_WORKING_DIRECTORY: <<parameters.working_directory>>
# PARAM_CONFIG_FILE: <<parameters.config_file>>
# PARAM_REGION: <<parameters.region>>
# PARAM_TESTING_ENVIRONMENT: <<parameters.testing_environment>>
# PARAM_SKIP_RUN: <<parameters.skip_run>>
# PARAM_SUITE: <<parameters.suite>>

run() {

    export SAUCE_USERNAME=${PARAM_SAUCE_USERNAME}
    export SAUCE_ACCESS_KEY=${PARAM_SAUCE_ACCESS_KEY}

    ${SAUCECTL_BINARY} ${}
    echo Hello "${PARAM_TO}"
}

# Will not run if sourced for bats-core tests.
# View src/tests for more information.
ORB_TEST_ENV="bats-core"
if [ "${0#*$ORB_TEST_ENV}" == "$0" ]; then
    run
fi

