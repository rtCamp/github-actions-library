# Github Action's Library

A collection of utilities for running WordPress deployments using GitHub actions.

## Deployment Workflow

```workflow

# Work In Progress

```

## Actions in the Library and their usage examples

### Branch Filter

Example showing how mulitple args can sent to filter required branches and block the rest.

```workflow
# Filter for specific deploy branch
action "Whitelist deploy branches" {
  uses = "rtCamp/github-actions-library/bin/filter@master"
  args = "branch master develop qa"
}
```
