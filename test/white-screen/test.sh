#!/usr/bin/env bash

# Starting all process
exec /usr/bin/mysqld --user=mysql &
sleep 5

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

wp config create --dbname='wp' --dbuser='root' --dbpass='root' --allow-root
wp core install --url=example.com --title=CI --admin_user=ci --admin_password=blahblahblah --admin_email=ci@example.com --allow-root
rm -rf "$build_root/wp-content/themes/"{twentyfifteen,twentysixteen,twentyseventeen}
wp plugin activate --all --allow-root
wp eval 'echo "wp verify success";' --allow-root
rm "$build_root/wp-config.php";

pushd "$build_root/wp-content" > /dev/null
rm -r uploads && ln -sn ../../../uploads
popd > /dev/null
