# GitHub action for Slack-Notify

### Uses: https://hub.docker.com/r/mrrobot47/slack-notify, https://github.com/mrrobot47/slack-notify/tree/alpine

## Slack Incoming Webhooks

This tool uses [Slack Incoming Webhooks](https://api.slack.com/incoming-webhooks)
to send a message to your slack channel. 

It also uses [Vault by HashiCorp](https://www.vaultproject.io/) to get the slack webhook. The `VAULT_ADDR` secret variable specifies the address on which vault is deployed, e.g., `VAULT_ADDR=https://example.com:8200`, the slack webhook should be put inside the kv store `secret`, such `vault read -field=webhook secret/slack` get's the vaule of the webhook.

## Usage

```workflow
action "Slack Notification" {
  uses = "rtCamp/github-actions-library/notification/slack@master"
  env = {
    SLACK_MESSAGE = "Deploy success :tada: GitHub Actions :rocket:",
    SLACK_USERNAME="notify-bot"
  }
  secrets = ["VAULT_ADDR", "VAULT_TOKEN"]
}
```

## Alternate usage 

```workflow
action "Slack Notification" {
  uses = "docker://mrrobot47/slack-notify"
  env = {
    SLACK_MESSAGE = "Deploy success :tada: GitHub Actions :rocket:",
    SLACK_USERNAME="notify-bot"
  }
  secrets = ["VAULT_ADDR", "VAULT_TOKEN"]
}
```

## Environment Variables that can be setup in the GitHub actions

```shell
# A URL to an icon
SLACK_ICON=http://example.com/icon.png
# The channel to send the message to (if omitted, use Slack-configured default)
SLACK_CHANNEL=example
# The title of the message
SLACK_TITLE="Hello World"
# The body of the message
SLACK_MESSAGE="Today is a fine day"
# RGB color to for message formatting. (Slack determines what is colored by this)
SLACK_COLOR="#efefef"
# The name of the sender of the message. Does not need to be a "real" username
SLACK_USERNAME="notify-bot"
```
