#!/usr/bin/env bash

# Starting all process
exec /usr/bin/mysqld --user=mysql &
sleep 5

export PROJECT_ROOT="$(pwd)"
export TEST_HTDOCS="$HOME/test"
export GITHUB_BRANCH=${GITHUB_REF##*heads/}
hosts_file="$GITHUB_WORKSPACE/.github/hosts.yml"

mkdir -p "$TEST_HTDOCS"
cd "$TEST_HTDOCS"
export build_root="$(pwd)"

WP_VERSION=$(cat "$hosts_file" | shyaml get-value "$CI_SCRIPT_OPTIONS.wp-version" | tr '[:upper:]' '[:lower:]')
wp core download --version="$WP_VERSION" --allow-root
rm -r wp-content/

# Setup WordPress files
rsync -av  "$GITHUB_WORKSPACE/" "$TEST_HTDOCS/wp-content/"  > /dev/null

wp config create --dbname='wp' --dbuser='root' --dbpass='root' --allow-root
wp db create --allow-root
wp core install --url=example.com --title=CI --admin_user=ci --admin_password=blahblahblah --admin_email=ci@example.com --allow-root
rm -rf "$build_root/wp-content/themes/"{twentyfifteen,twentysixteen,twentyseventeen}
wp plugin activate --all --allow-root
wp eval 'echo "wp verify success";' --allow-root
rm "$build_root/wp-config.php";
