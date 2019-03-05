#!/bin/bash

# Note that this does not use pipefail
# because if the grep later doesn't match any deleted files,
# which is likely the majority case,
# it does not exit with a 0, and I only care about the final exit.
set -eo

# Ensure SVN username and password are set
# IMPORTANT: secrets are accessible by anyone with write access to the repository!
if [[ -z "$WORDPRESS_USERNAME" ]]; then
	echo "Set the WORDPRESS_USERNAME secret"
	exit 1
fi

if [[ -z "$WORDPRESS_PASSWORD" ]]; then
	echo "Set the WORDPRESS_PASSWORD secret"
	exit 1
fi

# Allow some ENV variables to be customized
if [[ -z "$SLUG" ]]; then
	SLUG=${GITHUB_REPOSITORY#*/}
fi
echo "ℹ︎ SLUG is $SLUG"

# Set VERSION value according to tag value.
VERSION=${GITHUB_REF#refs/tags/}
echo "ℹ︎ VERSION is $VERSION"

# Get the files in the latest tag.
git archive --format=tar --prefix="archive-${VERSION}/" "${VERSION}" | (cd /tmp/ && tar xf -)
cd "/tmp/archive-${VERSION}/"

# Install composer dependencies
# Run `composer install`  if composer.json is found.
if [[ -f "composer.json" ]]; then
  composer install --no-dev --optimize-autoloader
fi

# Install npm dependencies
# Run `npm install` if package.json is found.
if [[ -f "package.json" ]]; then
  npm install
fi

# Install project dependencies
# This is to allow the plugin author to run custom command for asset building process.
if [[ ! -z "$CUSTOM_COMMAND" ]]; then
  eval "$CUSTOM_COMMAND"
fi

# Use a custom path inside git repo to be used as root path.
# Files will be copied from this path to plugin trunk directory.
if [[ -z "$CUSTOM_PATH" ]]; then
  CUSTOM_PATH='';
fi

# If EXCLUDE_LIST is provided store them in a file for rsync.
# This env variable expects a file/folder names to be exclude while doing the rsync command.
if [[ -z "$EXCLUDE_LIST" ]]; then
  echo $EXCLUDE_LIST | tr " " "\n" >> exclude.txt
fi

# Create exclude file with default values anyway.
echo ".git .github ${ASSETS_DIR} exclude.txt" | tr " " "\n" >> exclude.txt

SVN_URL="http://plugins.svn.wordpress.org/${SLUG}/"
SVN_DIR="/github/svn-${SLUG}"

# Checkout just trunk and assets for efficiency
# Tagging will be handled on the SVN level
echo "➤ Checking out .org repository..."
svn checkout --depth immediates "$SVN_URL" "$SVN_DIR"
cd "$SVN_DIR"
svn update --set-depth infinity assets
svn update --set-depth infinity trunk

echo "➤ Copying files..."

# Copy from current branch to /trunk, excluding dotorg assets
# The --delete flag will delete anything in destination that no longer exists in source
rsync -r --exclude-from="/tmp/archive-${VERSION}/exclude.txt" "/tmp/archive-${VERSION}/${CUSTOM_PATH}" trunk/ --delete

if [[ ! -z "$ASSETS_DIR" ]]; then
    # Copy dotorg assets to /assets
    rsync -r "$GITHUB_WORKSPACE/$ASSETS_DIR/" assets/ --delete
fi

# Add everything and commit to SVN
# The force flag ensures we recurse into subdirectories even if they are already added
# Suppress stdout in favor of svn status later for readability
echo "➤ Preparing files..."
svn add . --force > /dev/null

# SVN delete all deleted files
# Also suppress stdout here
svn status | grep '^\!' | sed 's/! *//' | xargs -I% svn rm % > /dev/null

svn status

eval "ls -al $SVN_DIR/trunk"

#echo "︎➤ Committing files..."
#svn commit -m "Update to version $VERSION from GitHub" --no-auth-cache --non-interactive  --username "$WORDPRESS_USERNAME" --password "$WORDPRESS_PASSWORD"

# SVN tag to VERSION
#echo "➤ Tagging version..."
#svn cp "^/$SLUG/trunk" "^/$SLUG/tags/$VERSION" -m "Tag $VERSION" --no-auth-cache --non-interactive --username "$WORDPRESS_USERNAME" --password "$WORDPRESS_PASSWORD"

#echo "✓ Plugin deployed!"
