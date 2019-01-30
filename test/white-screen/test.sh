#!/usr/bin/env bash

# Starting all process
exec /usr/bin/mysqld --user=mysql &
sleep 5

export PATH="$PATH:$COMPOSER_HOME/vendor/bin"
export PROJECT_ROOT="$(pwd)"
export HTDOCS="$HOME/htdocs"
export GITHUB_BRANCH=${GITHUB_REF##*heads/}

mkdir -p "$HTDOCS"
cd "$HTDOCS"
export build_root="$(pwd)"

#wp_version_file="$PROJECT_ROOT/WP-VERSION.txt"
#wp core download --version=$([ -s "$wp_version_file" ] && cat "$wp_version_file" || echo 'latest') --allow-root

wp core download --allow-root
rm -r wp-content/

# Setup WordPress files
rsync -av  "$GITHUB_WORKSPACE/" "$HTDOCS/wp-content/"  > /dev/null

