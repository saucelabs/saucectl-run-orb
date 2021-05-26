# saucectl orb

saucectl orb provides an easy way to run your [saucectl](https://github.com/saucelabs/saucectl) tests.

## Usage

It can be used as a command, or as a job.\
Both are called `saucectl-run`.

> You need to have set the following environment variables to be able to run saucectl:
> - SAUCE_USERNAME
> - SAUCE_ACCESS_KEY

## Parameters

| Parameter name | Description | Default value |
| --- | --- | --- |
| saucectl-version | Version of saucectl to use. Example: v0.25.1 | `latest` |
| config-file | Configuration file to use with saucectl | `.sauce/config.yml` |
| working-directory | Working directory to use when running saucectl | `.` | 
| region | Region to pass to saucectl | |
| testing-environment | Testing Environment | |
| suite | Suite to be tested | |
| show-console-log | Show console log when suite succeed | false |
| env | Environment variable to pass to saucectl | |
| sauceignore | Sauceignore file to be used | |
| timeout | Test timeout in seconds | |
| tunnel-id | Sets the sauce-connect tunnel ID to be used for the run | |
| tunnel-parent | Sets the sauce-connect tunnel parent to be used for the run | |
| logdir | Path where to store logs | |

## Example

### job

```
version: 2.1
orbs:
  saucectl: saucelabs/saucectl@1.0.0
workflows:
  use-saucectl:
    jobs:
      - saucectl/saucectl-run:
          env: |
            MY_VAR1=VALUE
            MY_VAR2=VALUE
          show-console-log: true

```

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
