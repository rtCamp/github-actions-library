# Github Action's Library

A collection of utilities for running WordPress deployments using GitHub actions.

## Deployment Workflow

```workflow

# Work In Progress

```

### Branch Filter

Example depicting how mulitple args can sent to filter required branches.

```workflow
# Filter for specific deploy branch
action "Whitelist deploy branches" {
  uses = "rtCamp/github-actions-library/bin/filter@master"
  args = "branch master develop qa"
}
```
