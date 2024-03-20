#!/bin/bash

. ./utils.bash
BRANCH_NAME="${1:-main}"

echo "go to woopen-backend"
cd ../1-main-application/woopen-backend
ask IS_OK

echo "remove lock on index"
rm -f .git/index.lock
ask IS_OK

echo "Switch  to  $BRANCH_NAME branch"
git checkout $BRANCH_NAME
ask IS_OK

echo "stash any local changes"
git stash
ask IS_OK

echo "pull last updates"
git pull
ask IS_OK

echo "get entities elligibles for ELK reindex"

git diff $(git tag --sort=-taggerdate  | sed -n '1p;2p') src/elasticsearch|grep -w -E 'src/elasticsearch'