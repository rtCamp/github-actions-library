# GitHub Actions Library by rtCamp

A collection of [GitHub Actions](https://github.com/features/actions) for running WordPress deployments.

## List of Github Actions

GitHub Action                                                                     | GitHub Action's Purpose
----------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------
[PHP Code Review](https://github.com/rtCamp/action-phpcs)    | Run PHPCS on pull requests.
[WordPress Deploy](https://github.com/rtCamp/action-wordpress-deploy)           | Deploy a WordPress site using using PHP's Deployer.org
[Slack Notify](https://github.com/rtCamp/action-slack-notify)                     | Send a notification to a Slack channel

## WordPress Skeleton

All our actions assumes that the GitHub repo for WordPress project follows [our wordpress skeleton repo's](https://github.com/rtCamp/wordpress-skeleton) structure.

## Usage

* All the three actions can be used individually on projects according the requirements.
1. For simply running code reviews on pull requests follow steps to [setup PHPCS code inspections](https://github.com/rtCamp/action-vip-go-ci#installation).
2. To deploy a WordPress repo follow steps to setup [deply action](https://github.com/rtCamp/action-wordpress-deploy#installation).
3. Send slack notification for success messages or information on any event on GitHub using [slack notification action](https://github.com/rtCamp/action-slack-notify#installation).
4. A minimal WordPress CI/CD including all these three actions has been setup on a [skeleton repo](https://github.com/rtCamp/github-actions-wordpress-skeleton). You can refer the [main.workflow](https://github.com/rtCamp/github-actions-wordpress-skeleton/blob/master/.github/main.workflow) to see how these three work together.

## Hashicorp Vault

[Hashicorp Vault](https://www.vaultproject.io) integration support has been added in all these actions along with the traditional methods.

The main advantage of using vault is in the [deploy action](https://github.com/rtCamp/action-wordpress-deploy). Because of Vault's [Signed SSH Certificates](https://www.vaultproject.io/docs/secrets/ssh/signed-ssh-certificates.html).

By using Vault's powerful CA capabilities and functionality built into OpenSSH, the deploy action can SSH into target hosts with it's own generated SSH key along with the signed certificate from vault.

In simple terms, if [the following steps](https://github.com/rtCamp/action-wordpress-deploy#vault) have been configured on a server. Then anyone with valid vault access, like our deploy action, will be able to ssh with signed certificates and it's private key will not have to be added everytime in the server's `authorized_keys`.

For [other actions](https://github.com/rtCamp/action-slack-notify) as well, secrets like `SLACK_WEBHOOK` can be centrally stored and managed using vault.
