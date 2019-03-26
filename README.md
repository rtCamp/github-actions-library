> **⚠️ Note:** To use this GitHub Action, you must have access to GitHub Actions. GitHub Actions are currently only available in public beta (you must apply for access).

# GitHub Actions Library by rtCamp

A collection of [GitHub Actions](https://github.com/features/actions) created by rtCamp.

This repo itself acts as a placeholder only. We have created a separate repo for each GitHub action to make our actions available via GitHub actions marketplace.

## List of GitHub Actions

Please go to individual GitHub action to read more about them, including usage instructions. All our GitHub actions can be used individually or combined on projects according the requirements.

A minimal WordPress CI/CD including three actions has been setup on a [skeleton repo](https://github.com/rtCamp/wordpress-skeleton). You can refer the [main.workflow](https://github.com/rtCamp/wordpress-skeleton/blob/master/.github/main.workflow) to see how these work together.

GitHub Action                                                                     | GitHub Action's Purpose
----------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------
<img src="https://user-images.githubusercontent.com/8456197/54678910-15ecde80-4b2c-11e9-9bda-149b94951de6.png" height="19px">🕵️‍♂️&nbsp;[PHPCS Code Review](https://github.com/rtCamp/action-phpcs-code-review)    | Run PHPCS on pull requests.
<img src="https://wordpress.org/favicon.ico" height="19px">🚀&nbsp;[Deploy WordPress](https://github.com/rtCamp/action-deploy-wordpress)           | Deploy a WordPress site using using PHP's Deployer.org
<img src="https://a.slack-edge.com/cebaa/img/ico/favicon.ico" height="19px">❗&nbsp;[Slack Notify](https://github.com/rtCamp/action-slack-notify)                     | Send a notification to a Slack channel

## Extras

### WordPress Skeleton

We follow "One Site, One Repo" approach for all our WordPress projects.
You can check [our wordpress skeleton repo here](https://github.com/rtCamp/wordpress-skeleton).
Some of our actions, such as WordPress Deployer, depends on git repo structure.

### Hashicorp Vault (optional)

If you don't use Vault, you can ignore this part. This is completely optional.

We use [Hashicorp Vault](https://www.vaultproject.io) internally for secrets management. So all our actions support fetching secrets from Hashicorp Vault, in addition to [GitHub secrets](https://developer.github.com/actions/managing-workflows/storing-secrets/).

For some actions such as Slack Notify, Vault may seems redundant. But for other such as [Deploy WordPress](https://github.com/rtCamp/action-deploy-wordpress) action, Vault is time saver. 

GitHub doesn't support organization wide secrets. So with GitHub secrets, we need to duplicate many secrets, such as dev/test server SSH keys, across multiple repos.

Using Vault, we reduce this effort to setup Vault's token in GitHub secrets. Further, Vault policies help us enforce fine grain control.
