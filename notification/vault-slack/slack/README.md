# GitHub action for Slack-Notify

### Uses: https://hub.docker.com/r/mrrobot47/slack-notify

## Slack Incoming Webhooks

This tool uses [Slack Incoming Webhooks](https://api.slack.com/incoming-webhooks)
to send a message to your slack channel. 

It also uses [Vault by HashiCorp](https://www.vaultproject.io/) to get the slack webhook. The `VAULT_URL` to be set in secret should have the path resolved such that: `$VAULT_URL/slack-webhook` generates the entire path to the secret. The key for secret should be `url` and the vaule should be the webhook.

Before you can use this tool, you need to log into your Slack account and configure
slack webhook and setup secret in your vault, e.g., in path `https://example.com:8200/v1/secret/slack-webhook`

## Usage

```workflow
action "Slack Notification" {
  uses = "rtCamp/github-actions-library/notification/slack@master"
  env = {
    SLACK_MESSAGE = "Deploy success :tada: GitHub Actions :rocket:",
    SLACK_USERNAME="notify-bot"
  }
  secrets = ["VAULT_URL", "VAULT_TOKEN"]
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
  secrets = ["VAULT_URL", "VAULT_TOKEN"]
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
