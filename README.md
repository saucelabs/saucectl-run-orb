# saucectl orb

saucectl orb provides an easy way to run your [saucectl](https://github.com/saucelabs/saucectl) tests.

## Usage

It can be used as a command, or as a job.\
Both are called `saucectl-run`.

> You need to have set the following environment variables to be able to run saucectl:
> - SAUCE_USERNAME
> - SAUCE_ACCESS_KEY

Alternativement, you can use `sauce-username` and `sauce-access-key` parameters of the orb.

## Parameters

| Parameter name | Description | Default value |
| --- | --- | --- |
| sauce-username | Sauce Username to use for authentification | |
| sauce-access-key | Sauce Access Key to use for authentification | |
| saucectl-version | Version of saucectl to use. Example: v0.68.2 | `latest` |
| config-file | Configuration file to use with saucectl | `.sauce/config.yml` |
| working-directory | Working directory to use when running saucectl | `.` | 
| region | Region to pass to saucectl | |
| select-suite | Suite to be executed | |
| show-console-log | Show console log when suite succeed | false |
| env | Environment variable to pass to saucectl | |
| sauceignore | Sauceignore file to be used | |
| timeout | Test timeout in seconds | |
| tunnel-name | Sets the sauce-connect tunnel name to be used for the run | |
| tunnel-owner | Sets the sauce-connect tunnel owner to be used for the run | |
| ccy | Sets the concurrency to be used for the run | |
| retries | ets the number of retries to do for the run | |
| test-env-silent | Skips the test environment announcement | false |

## Example

### command

```
version: 2.1
orbs:
  saucectl: saucelabs/saucectl-run@dev:alpha
jobs:
  run_saucectl:
    docker:
      - image: cimg/base:stable
    steps:
      - checkout
      - setup_remote_docker:
          version: 20.10.2
      - saucectl/saucectl-run:
          env: |
            MY_VAR1=VALUE
            MY_VAR2=VALUE
          show-console-log: true
workflows:
  test_local_and_remote:
    jobs:
      - run_saucectl
```
