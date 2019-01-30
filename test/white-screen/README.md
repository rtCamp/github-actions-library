# GitHub action for White Screen Test

This test activates all plugins and runs `wp eval` to check if WordPress is loading properly with the code to be deployed.

## Usage

```workflow
action "White Screen Test" {
  uses = "rtCamp/github-actions-library/test/white-screen@master"
}
```
