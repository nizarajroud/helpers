#!/bin/bash
#  define you function + vim ~/.zshrc and add alias + source ~/.zshrc

ask() {
echo "ok? (y/n)"
read IS_OK
    if [[ -z "$IS_OK" ]]; then
        IS_OK='y'
    fi

    if [[ "$IS_OK" != "y" && "$IS_OK" != "Y" ]]; then
        echo "Aborting!"
        exit 1
    fi
}
gl() {

repo=$(basename -s .git `git config --get remote.origin.url`)

if [[ "$repo" != "woopen-infrastructure" ]]; then
    let "num_commits_after_last_tag=$(git rev-list  `git rev-list --tags --no-walk --max-count=1`..HEAD --count) "
else
    num_commits_after_last_tag=3
fi    

git --no-pager log \
--decorate-refs-exclude=refs/remotes \
--oneline \
--pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' \
-n${num_commits_after_last_tag/#-/}

#
#
#
#$(git tag --sort=-taggerdate  | sed -n '1p')..HEAD
#--decorate \
#--first-parent main \
#-n$(git rev-list  `git rev-list --tags --no-walk --max-count=1`..HEAD --count)
#--remotes=main \
#--merges \
#--branches=main \
#$(git tag --sort=-taggerdate  | sed -n '1p')..HEAD \
#--exclude=refs/remotes --all \
#main^..HEAD \
#--first-parent main \
#$(git tag --sort=-taggerdate  | sed -n '1p')..HEAD \
#--all \
#--graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' \

}

br() {
    blast-radius --serve . 
}

# ghrun(){

#     BRANCH_NAME=$1
#     WORKFLOW_NAME=$2
#     echo "gh workflow run $WORKFLOW_NAME.yml --ref $BRANCH_NAME && sleep 10 && gh run watch $(gh run list --branch $BRANCH_NAME --user nizarajroud  --limit 1 --json databaseId --jq '.[].databaseId')"
#     #gh workflow run $WORKFLOW_NAME.yml --ref $BRANCH_NAME && sleep 10 && gh run watch $(gh run list --branch $BRANCH_NAME --user nizarajroud  --limit 1 --json databaseId --jq '.[].databaseId')
# }

# function get_now_in_GMT_timezone_and_UTC_Format{
#     date -u +"%Y-%m-%dT%H:%M:%SZ"
# }

function tf_start {

    MAIN_PATH="/mnt/c/Users/NizarAjroud/NZSPCE/OPERATIONAL/CLOUD_WORKS/CLD_VSC_WSPCE/trainings"
    PRJ="test_$(date -u +"%H_%M")"

    cd $MAIN_PATH && mkdir $PRJ && cd $PRJ

    cat <<EOT >> main.tf
provider "aws" {
  region = "us-east-1"
}
EOT

    terraform fmt -recursive

    cp  $MAIN_PATH/tf-confs/terraform-conf.zip .  
    unzip terraform-conf.zip && chmod -R 777 .terraform 

    terraform init && terraform plan
    
    code main.tf

} 

function cdk_start {

    MAIN_PATH="/mnt/c/Users/NizarAjroud/NZSPCE/OPERATIONAL/CLOUD_WORKS/CLD_VSC_WSPCE/CSNA/cdk_trainings"
    PRJ="Cdksample$(date -u +"%H%M")" 

cd $MAIN_PATH && mkdir $PRJ && cd $PRJ
cdk init app --language typescript 

rm lib/$PRJ-stack.ts  && touch lib/$PRJ-stack.ts
    cat <<EOT >> lib/$PRJ-stack.ts
import * as cdk from 'aws-cdk-lib';
import { Construct } from 'constructs';
import * as sqs from 'aws-cdk-lib/aws-sqs';

export class ${PRJ}Stack extends cdk.Stack {
  constructor(scope: Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    // The code that defines your stack goes here

    const queue = new sqs.Queue(this, '${PRJ}Queue', {
      visibilityTimeout: cdk.Duration.seconds(300)
    });
  }
}
EOT
npm run build
cdk ls && cdk synth
cdk bootstrap aws://579977624675/ca-central-1 && cdk deploy
    
#     code main.tf

} 
function ghrun_wf_br {
    WORKFLOW_NAME=$1
    BRANCH_NAME=$2
    #echo "gh workflow run $WORKFLOW_NAME.yml --ref $BRANCH_NAME && sleep 10 && gh run watch $(gh run list --branch $BRANCH_NAME --user nizarajroud  --limit 1 --json databaseId --jq '.[].databaseId')"
    gh workflow run $WORKFLOW_NAME.yml --ref $BRANCH_NAME && sleep 10 && gh run watch $(gh run list --branch $BRANCH_NAME --user nizarajroud  --limit 1 --json databaseId --jq '.[].databaseId')

} 
function ghrun_wf_br {
    WORKFLOW_NAME=$1
    BRANCH_NAME=$2
    #echo "gh workflow run $WORKFLOW_NAME.yml --ref $BRANCH_NAME && sleep 10 && gh run watch $(gh run list --branch $BRANCH_NAME --user nizarajroud  --limit 1 --json databaseId --jq '.[].databaseId')"
    gh workflow run $WORKFLOW_NAME.yml --ref $BRANCH_NAME && sleep 10 && gh run watch $(gh run list --branch $BRANCH_NAME --user nizarajroud  --limit 1 --json databaseId --jq '.[].databaseId')

} 
function patch-cmds {
    VERSION=$1
    echo git checkout tags/$VERSION
    echo git tag -d $VERSION \&\& git push origin \":$VERSION\" 
    echo git tag  $VERSION \&\& git push origin tags/$VERSION
    echo git restore . \&\& git checkout tags/$VERSION
    echo git push origin tags/$VERSION --force
    echo git checkout -b chore/upgrade-iso-$VERSION \# Upgraded iso to $VERSION
    echo git checkout -b chore/upgrade-prod-$VERSION \# Upgraded prod to $VERSION
    echo git clone  -b chore/upgrade-prod-$VERSION \# Upgraded prod to $VERSION
    
    # echo git push origin \":$VERSION\" 
    # echo git push origin tags/$VERSION
    # echo Delete local tag : git tag -d $VERSION 
    # echo 'Delete remote tag : git push origin ":$VERSION" '
    # echo Perform cherry pick : git cherry-pick  commit-id
    # echo push code if it is on a branch
    # echo create local tag :  git tag  $VERSION
    # echo push remote tag to start the build: git push origin tags/$VERSION
    # echo "Force replace the old by the new one on remote : git push origin tags/$VERSION --force
 
} 

function start_tf_project {
    Root_PATH=$(pwd)
    Project=$1

    #create the project herarchy
    mkdir $Project
    cd $Project
    touch main.tf providers.tf variables.tf outputs.tf terraform.auto.tfvars

}