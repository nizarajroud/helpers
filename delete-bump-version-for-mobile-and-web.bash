#!/bin/bash

PAT='/mnt/c/Users/NizarAjroud/NZSPCE/OPERATIONAL/CLOUD_WORKS/CLD_VSC_WSPCE/woopen'



remove-bump-version()
{
        
    cd $1 
    git fetch --all --tags
    git branch -a --sort=-committerdate|grep bump | sed -n '1p;2p;3p'
    echo "bump version name ? "
    read BUMP_VERSION_NAME
        if [[ -z "$BUMP_VERSION_NAME" ]]; then
            echo "skipping!"
        else
        git branch -d $BUMP_VERSION_NAME
        git push origin -d $BUMP_VERSION_NAME
        fi
    cd "$OLDPWD" 
}

cd $PAT/1-main-application/


echo "== web =="
remove-bump-version woopen-web 

echo "== mobile =="
remove-bump-version woopen-mobile








