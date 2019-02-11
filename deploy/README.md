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

staging:
  hostname: stag.example.com
  user: root
  stage: develop
  deploy_path: /opt/easyengine/sites/stag.example.com/app/htdocs

develop:
  hostname: dev.example.com
  user: root
  stage: develop
  deploy_path: /opt/easyengine/sites/dev.example.com/app/htdocs

ci_script_options:
  vip: true
  wp-version: latest
```

3. The setup of ssh keys for deployment is managed through [vault](https://www.vaultproject.io/). The `VAULT_ADDR` secret variable specifies the address on which vault is deployed, e.g., `VAULT_ADDR=https://example.com:8200`.

4. For Signed SSH Certificates to work, follow the steps give [here](https://www.vaultproject.io/docs/secrets/ssh/signed-ssh-certificates.html#signing-key-amp-role-configuration) on the deployed vault instance.

5. Then, to configure the server to accept ssh connection via signed certificate, run the following steps:
```bash
export VAULT_ADDR='https://example.com:8200'
export VAULT_TOKEN='vault-root-token'

# Add the public key to all target host's SSH configuration.
curl -o /etc/ssh/trusted-user-ca-keys.pem "$VAULT_ADDR/v1/ssh-client-signer/public_key"

# Add the path where the public key contents are stored to the SSH configuration file as the TrustedUserCAKeys option.
echo "TrustedUserCAKeys /etc/ssh/trusted-user-ca-keys.pem" >> /etc/ssh/sshd_config

# Restart ssh service. This may differ according to the OS.
systemctl restart ssh
```

## Usage

```workflow
action "Deploy" {
  uses = "rtCamp/github-actions-library/deploy@master"
  secrets = ["VAULT_ADDR", "VAULT_TOKEN"]
}
```

## Environment Variables that can be setup in the GitHub actions

```shell
# MU plugins git repository url in case the site is VIP (defined in hosts.yml). Default is set to: https://github.com/Automattic/vip-mu-plugins-public
MU_PLUGINS_URL="https://github.com/Automattic/vip-mu-plugins-public"
```
