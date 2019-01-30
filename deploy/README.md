# GitHub action for deployment using deployer

1. Deployment GitHub action uses [deployer](https://deployer.org/) to do the deploys.

2. Deployment general settings like branch and hosts related to the branch etc., are setup in the `hosts.yml` file (Location in repo: `.github/hosts.yml`). Apart from that `ci_script_options` is also defined in the `hosts.yml` file to get other settings for enviournenmt. Sample `hosts.yml`:

```bash
# GH branch name
master:

  # server to deploy this branch.
  hostname: example.com

  # user to use in deploy. Can be auto-determined using EE version.
  user: root

  # branch name
  stage: master
  
  # Path to deploy. Can be auto-determined using EE version if not specified explicitly.
  deploy_path: /opt/easyengine/sites/example.com/app/htdocs


  # Setting these options because of ssh-issues in GH actions.
  # Should not be needed in future, hopefully :fingers-crossed:
  sshOptions:
    UserKnownHostsFile: /dev/null
    StrictHostKeyChecking: no

staging:
  hostname: stag.example.com
  user: root
  stage: develop
  deploy_path: /opt/easyengine/sites/stag.example.com/app/htdocs
  sshOptions:
    UserKnownHostsFile: /dev/null
    StrictHostKeyChecking: no

develop:
  hostname: dev.example.com
  user: root
  stage: develop
  deploy_path: /opt/easyengine/sites/dev.example.com/app/htdocs
  sshOptions:
    UserKnownHostsFile: /dev/null
    StrictHostKeyChecking: no

ci_script_options:
  vip: true
  wp-version: latest
```

3. The setup of ssh keys for deployment is managed through [vault](https://www.vaultproject.io/). `VAULT_URL` should be setup such that request to `VAULT_URL/hostname` with `VAULT_TOKEN` should give the ssh key.

## Usage

```workflow
action "Deploy" {
  uses = "rtCamp/github-actions-library/deploy@master"
  secrets = ["VAULT_URL", "VAULT_TOKEN"]
}
```

## Environment Variables that can be setup in the GitHub actions

```shell
# MU plugins git repository url in case the site is VIP (defined in hosts.yml). Default is set to: https://github.com/Automattic/vip-mu-plugins-public
MU_PLUGINS_URL="https://github.com/Automattic/vip-mu-plugins-public"
```
