#!/usr/bin/env bash

export PATH="$PATH:$COMPOSER_HOME/vendor/bin"
export PROJECT_ROOT="$(pwd)"
export HTDOCS="$HOME/htdocs"
export GITHUB_BRANCH=${GITHUB_REF##*heads/}
export CI_SCRIPT_OPTIONS="ci_script_options"

# Setup hosts file
hosts_file="$GITHUB_WORKSPACE/.github/hosts.yml"
rsync -av "$hosts_file" /hosts.yml
cat /hosts.yml

# Setup custom deploy.php if found
custom_deploy_php="$GITHUB_WORKSPACE/.github/deploy.php"
if [ -f "$custom_deploy_php" ]; then
    rsync -av "$custom_deploy_php" /deploy.php
fi

# get hostname
hostname=$(cat "$hosts_file" | shyaml get-value "$GITHUB_BRANCH.hostname")

ENCODED_SSH_PRIVATE_KEY=$(curl --silent --header "X-Vault-Token: $VAULT_TOKEN" "$VAULT_URL/$hostname" | jq '.data' | jq '.[]')

printf "[\e[0;34mNOTICE\e[0m] Setting up SSH access to server.\n"

SSH_DIR="$HOME/.ssh"
mkdir -p "$SSH_DIR"
chmod 700 "$SSH_DIR"

echo "$ENCODED_SSH_PRIVATE_KEY" | base64 -d > "$SSH_DIR/id_rsa"
chmod 600 "$SSH_DIR/id_rsa"
eval "$(ssh-agent -s)"
ssh-add "$SSH_DIR/id_rsa"

# echo "$SSH_KNOWN_HOSTS" | tr -d '\r' > "$SSH_DIR/known_hosts"
# chmod 644 "$SSH_DIR/known_hosts"

mkdir -p "$HTDOCS"
cd "$HTDOCS"
export build_root="$(pwd)"

WP_VERSION=$(cat "$hosts_file" | shyaml get-value "$CI_SCRIPT_OPTIONS.wp-version" | tr '[:upper:]' '[:lower:]')
wp core download --version="$WP_VERSION" --allow-root

rm -r wp-content/

rsync -av  "$GITHUB_WORKSPACE/" "$HTDOCS/wp-content/"  > /dev/null

# Symlink uploads directory
cd "$HTDOCS/wp-content/"
rm -rf uploads
ln -s ../../../uploads uploads

# Setup mu-plugins if VIP
VIP=$(cat "$hosts_file" | shyaml get-value "$CI_SCRIPT_OPTIONS.vip" | tr '[:upper:]' '[:lower:]')
if [ "$VIP" = "true" ]; then
    MU_PLUGINS_URL=${MU_PLUGINS_URL:-"https://github.com/Automattic/vip-mu-plugins-public"}
    MU_PLUGINS_DIR="$HTDOCS/wp-content/mu-plugins"
    echo "Cloning mu-plugins from: $MU_PLUGINS_URL"
    git clone -q --recursive --depth=1 "$MU_PLUGINS_URL" "$MU_PLUGINS_DIR"
fi

cd "$GITHUB_WORKSPACE"
dep deploy "$GITHUB_BRANCH"

printf "[\e[0;34mNOTICE\e[0m] Deploy successful.\n"
