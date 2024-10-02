#!/bin/bash

REPO_NAME=$1

#create repository

mkdir $REPO_NAME

#initialise repository

cd $REPO_NAME
git init
git add .
git commit -m "initial commit"

#create remote repository and origin

gh repo create $REPO_NAME --private
git remote add origin https://github.com/nizarajroud/$REPO_NAME.git
git push --set-upstream origin main
git push
