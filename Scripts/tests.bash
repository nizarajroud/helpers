#!/bin/bash

. ./utils.bash
TS=$1
BRANCH_NAME="${2:-main}"


echo "For mobile and web projects , you should create the tag from the bump branch, are your parameters always correct"
ask IS_OK
echo "next step $TS"
echo "third step $BRANCH_NAME"