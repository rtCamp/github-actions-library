s# GitHub action for PHPCS inspections

## Usage

```workflow
action "Run phpcs inspection" {
  uses = "rtCamp/github-actions-library/inspections/codesniffer@develop"
  env = {
    DIFF_BASE="origin/master"
  }
}
```

## Environment Variables that can be setup in the GitHub actions

```shell
# To compare the committed changes between master and the current branch. Default: origin/master.
DIFF_BASE=origin/master

# Head commit from which diff will be taken. Default: `git rev-parse HEAD`
DIFF_HEAD=0fbe5466e1ec4eecb4bf0c7453ee4fa045ef3ebf
```
