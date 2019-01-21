#!/usr/bin/env bash

export PATH="$PATH:$COMPOSER_HOME/vendor/bin"
export PROJECT_ROOT="$(pwd)"
export HTDOCS="$HOME/htdocs"
export GITHUB_BRANCH=${GITHUB_REF##*heads/}

# Setup hosts file
rsync -av "$GITHUB_WORKSPACE/.github/hosts.yml" /hosts.yml
cat /hosts.yml

# get hostname
hostname=$(cat /hosts.yml | shyaml get-value "$GITHUB_BRANCH.hostname")

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

#wp_version_file="$PROJECT_ROOT/WP-VERSION.txt"
#wp core download --version=$([ -s "$wp_version_file" ] && cat "$wp_version_file" || echo 'latest') --allow-root

wp core download --allow-root
rm -r wp-content/

rsync -av  "$GITHUB_WORKSPACE/" "$HTDOCS/wp-content/"  > /dev/null

cd "$GITHUB_WORKSPACE"
dep deploy "$GITHUB_BRANCH"

printf "[\e[0;34mNOTICE\e[0m] Deploy successful.\n"
