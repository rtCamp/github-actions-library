#!/usr/bin/env bash

stars=$(printf "%-30s" "*")

rsync -a $GITHUB_WORKSPACE/ /home/techfreak-ci/github-workspace
rsync -a /root/vip-go-ci-tools/ /home/techfreak-ci/vip-go-ci-tools
chown -R techfreak-ci:techfreak-ci /home/techfreak-ci/

GITHUB_REPO_NAME=${GITHUB_REPOSITORY##*/}
GITHUB_REPO_OWNER=${GITHUB_REPOSITORY%%/*}

gosu techfreak-ci bash -c "/home/techfreak-ci/vip-go-ci-tools/vip-go-ci/vip-go-ci.php --repo-owner=$GITHUB_REPO_OWNER --repo-name=$GITHUB_REPO_NAME --commit=$GITHUB_SHA --token=$USER_GITHUB_TOKEN --phpcs-path=/home/techfreak-ci/vip-go-ci-tools/phpcs/bin/phpcs --local-git-repo=/home/techfreak-ci/github-workspace --phpcs=true --phpcs-standard=wordpress-vip-go --lint=true"
