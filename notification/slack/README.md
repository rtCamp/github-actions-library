# GitHub action for Slack-Notify

### Uses: https://hub.docker.com/r/technosophos/slack-notify

## Slack Incoming Webhooks

This tool uses [Slack Incoming Webhooks](https://api.slack.com/incoming-webhooks)
to send a message to your slack channel.

Before you can use this tool, you need to log into your Slack account and configure
this.

## Usage

```workflow
action "Slack Notification" {
  uses = "rtCamp/github-actions-library/notification/slack@master"
  env = {
    SLACK_MESSAGE = "Deploy success :tada: GitHub Actions :rocket:",
    SLACK_USERNAME="notify-bot"
  }
  secrets = ["SLACK_WEBHOOK"]
}
```

## Alternate usage 

```workflow
action "Slack Notification" {
  uses = "docker://technosophos/slack-notify"
  env = {
    SLACK_MESSAGE = "Deploy success :tada: GitHub Actions :rocket:",
    SLACK_USERNAME="notify-bot"
  }
  secrets = ["SLACK_WEBHOOK"]
}
```

## Environment Variables that can be setup in the GitHub actions

```shell
# The Slack-assigned webhook
SLACK_WEBHOOK=https://hooks.slack.com/services/Txxxxxx/Bxxxxxx/xxxxxxxx
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
