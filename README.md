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

### Slack Notification

1. Normal slack notification. More details in internal [README.md](https://github.com/rtCamp/github-actions-library/blob/master/notification/slack/README.md)

```workflow
action "Slack Notification" {
  uses = "rtCamp/github-actions-library/notification/slack@master"
  env = {
    SLACK_MESSAGE  = "Deploy success :tada: GitHub Actions :rocket:",
    SLACK_USERNAME = "notify-bot"
  }
  secrets = ["SLACK_WEBHOOK"]
}
```

2. Slack notification with webhook managed by vault. More details in internal [README.md](https://github.com/rtCamp/github-actions-library/blob/master/notification/vault-slack/README.md)
```workflow
action "Slack Notification" {
  uses = "rtCamp/github-actions-library/notification/vault-slack@master"
  env = {
    SLACK_MESSAGE = "Deploy success :tada: GitHub Actions :rocket:",
    SLACK_USERNAME="notify-bot"
  }
  secrets = ["VAULT_URL", "VAULT_TOKEN"]
}
```

### Inspections

1. PHP Codesniffer inspections. More details in internal [README.md](https://github.com/rtCamp/github-actions-library/blob/develop/inspections/codesniffer/README.md)

```workflow
action "Run phpcs inspection" {
  uses = "rtCamp/github-actions-library/inspections/codesniffer@develop"
}
```