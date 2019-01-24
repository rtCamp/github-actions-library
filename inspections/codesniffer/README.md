# GitHub action for PHPCS inspections

## Usage

```workflow
action "Run phpcs inspection" {
  uses = "rtCamp/github-actions-library/inspections/codesniffer@develop"
  env = {
    DIFF_BASE="master"
  }
}
```

## Environment Variables that can be setup in the GitHub actions

```shell
# Base from which the diff will be taken to run phpcs on. Default: master.
DIFF_BASE=master
# Head commit from which diff will be taken. Default: `git rev-parse HEAD`
DIFF_HEAD=0fbe5466e1ec4eecb4bf0c7453ee4fa045ef3ebf
```
