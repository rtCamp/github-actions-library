# Github Action's Library

A collection of utilities for running WordPress deployments using GitHub actions.

## Deployment Workflow

```workflow

# Work In Progress

```

## Actions in the Library and their usage examples

Note: `secrets` in the usage examples can be configured in the repo settings. Look into [storing secrets](https://developer.github.com/actions/creating-workflows/storing-secrets/#storing-secrets) for more information on how to setup secrets.

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

2. Slack notification with webhook managed by [vault](https://www.vaultproject.io/). More details in internal [README.md](https://github.com/rtCamp/github-actions-library/blob/master/notification/vault-slack/README.md)
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

1. PHP Codesniffer inspections. More details in internal [README.md](https://github.com/rtCamp/github-actions-library/blob/master/inspections/codesniffer/README.md)

```workflow
action "Run phpcs inspection" {
  uses = "rtCamp/github-actions-library/inspections/codesniffer@master"
}
```

### Tests

1. :construction: White Screen WordPress test. This test is still under construction to improve proper white screen of death testing. Currently, it activates all plugins and runs `wp eval` to check if WordPress is loading properly with the code to be deployed.

```workflow
action "White Screen Test" {
  uses = "rtCamp/github-actions-library/test/white-screen@master"
}
```

### Deploy

Deployment using [deployer](https://deployer.org/). Deployment general settings like branch and hosts related to the branch etc., are setup in the `hosts.yml` file. The setup of ssh keys for deployment is managed through [vault](https://www.vaultproject.io/). More details in internal [README.md](https://github.com/rtCamp/github-actions-library/blob/master/deploy/README.md)

```workflow
action "Deploy" {
  uses = "rtCamp/github-actions-library/deploy@master"
  secrets = ["VAULT_URL", "VAULT_TOKEN"]
}
```
