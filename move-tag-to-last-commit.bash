#!/bin/bash

. ./utils.bash

PATH=$1
PROJECT_NAME=basename $1
BRANCH_NAME="${3:-main}"
EXISTING_TAG=$4
NEW_TAG=$5
echo "Attention!! For mobile and web projects , you should create the tag from the bump branch, are your parameters always ok?"
ask IS_OK
echo "go to $PATH"
cd $PATH

echo "Switch  to  $BRANCH_NAME branch"
git checkout $BRANCH_NAME

echo "stash any local changes"
git stash

echo "pull last updates on $BRANCH_NAME branch of $PROJECT_NAME project"
git pull

echo "delete existing tag $EXISTING_TAG locally"
git tag -d $EXISTING_TAG

echo "delete existing tag $EXISTING_TAG remotly"
git push origin ":$EXISTING_TAG"

echo "create the new tag $NEW_TAG locally"
git tag -a $NEW_TAG -m "$NEW_TAG"

echo "push the new tag $NEW_TAG, and so the github workflow will be started on the corresponding environment"
git push origin "$NEW_TAG:$NEW_TAG"

