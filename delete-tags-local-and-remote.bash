#!/bin/bash

PAT='/mnt/c/Users/NizarAjroud/NZSPCE/OPERATIONAL/CLOUD_WORKS/CLD_VSC_WSPCE/woopen'


remove-tag-locally-and-remotly()
{
    cd $1 
    git fetch --all --tags
    git tag --sort=-taggerdate | sed -n '1p;2p;3p'
    echo "tag name ? "
    read TAG_NAME
        if [[ -z "$TAG_NAME" ]]; then
            echo "skipping!"
        else
        git tag -d $TAG_NAME
        git push origin ":$TAG_NAME"
        fi    
    cd "$OLDPWD" 
}

cd $PAT/1-main-application/

echo "== backend =="
remove-tag-locally-and-remotly woopen-backend 

echo "== web =="
remove-tag-locally-and-remotly woopen-web 

echo "== mobile =="
remove-tag-locally-and-remotly woopen-mobile

cd $PAT/2-services/

echo "== cms-admin =="
remove-tag-locally-and-remotly woopen-cms-admin

echo "== cms-service =="
remove-tag-locally-and-remotly woopen-cms-service

echo "== contacts-service =="
remove-tag-locally-and-remotly woopen-contacts-service

echo "== crm-service =="
remove-tag-locally-and-remotly woopen-crm-service








