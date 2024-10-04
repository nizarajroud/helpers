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
function bstge_start {
    # 0.5.7 will install Backstage 1.20.3
    BACKSTAGE_CREATE_APP_VERSION="0.5.8"
    MAIN_PATH="/mnt/c/Users/NizarAjroud/NZSPCE/OPERATIONAL/CLOUD_WORKS/CLD_VSC_WSPCE/ALL-trainings/backstage-trainings"
    PRJ="bstgesample$(date -u +"%H%M")"
    backstageDir=$MAIN_PATH/$PRJ 

    echo "project sample name:  $PRJ"
    BACKSTAGE_APP_NAME=$PRJ npx -y -q @backstage/create-app@$BACKSTAGE_CREATE_APP_VERSION --path $backstageDir
} 
function cdk_start {

    MAIN_PATH="/mnt/c/Users/NizarAjroud/NZSPCE/OPERATIONAL/CLOUD_WORKS/CLD_VSC_WSPCE/CSNA/cdk_trainings"
    PRJ="Cdksample$(date -u +"%H%M")" 

echo "project sample name:  $PRJ"
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
    
    code lib/$PRJ-stack.ts

} 
function cdk_start {

    MAIN_PATH="/mnt/c/Users/NizarAjroud/NZSPCE/OPERATIONAL/CLOUD_WORKS/CLD_VSC_WSPCE/CSNA/cdk_trainings"
    PRJ="Cdksample$(date -u +"%H%M")" 

echo "project sample name:  $PRJ"
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
    
    code lib/$PRJ-stack.ts

} 
function ghrun_wf_br {
    WORKFLOW_NAME=$1
    BRANCH_NAME=$2
    #echo "gh workflow run $WORKFLOW_NAME.yml --ref $BRANCH_NAME && sleep 10 && gh run watch $(gh run list --branch $BRANCH_NAME --user nizarajroud  --limit 1 --json databaseId --jq '.[].databaseId')"
    gh workflow run $WORKFLOW_NAME.yml --ref $BRANCH_NAME && sleep 10 && gh run watch $(gh run list --branch $BRANCH_NAME --user nizarajroud  --limit 1 --json databaseId --jq '.[].databaseId')

} 
function gh_start {
    REPO_NAME=$1
    
    #create repository
    mkdir $REPO_NAME
    
    #initialise repository
    cd $REPO_NAME
    mkdir -p .github/workflows && cd .github/workflows
    touch $REPO_NAME.yml
    add_multiline_content-github_wf $REPO_NAME.yml
    cd ../..
    git init
    echo "# My New Project $REPO_NAME" > README.md
    git add .
    git commit -m "initial commit"
    
    #create remote repository and origin
    gh repo create $REPO_NAME --private
    sleep 5
    git remote add origin https://github.com/nizarajroud/$REPO_NAME.git
    git push --set-upstream origin main
    git push

} 
function add_commit_and_push {
  MSG=$1
  git add . && sleep 7 && git commit -m $MSG && git push

}
function zgit-cmds {
    VERSION="${1:-1.0.0}"
    echo git checkout tags/$VERSION
    echo git tag -d $VERSION \&\& git push origin \":$VERSION\" 
    echo git tag  $VERSION \&\& git push origin tags/$VERSION
    echo git restore . \&\& git checkout tags/$VERSION
    echo git push origin tags/$VERSION --force
    echo git checkout -b chore/upgrade-iso-$VERSION \# Upgraded iso to $VERSION
    echo git checkout -b chore/upgrade-prod-$VERSION \# Upgraded prod to $VERSION
    echo git clone  -b chore/upgrade-prod-$VERSION \# Upgraded prod to $VERSION
    echo git push --set-upstream origin garde-dev-oct-3
    echo discard any changes: git clean -fd
    echo git push origin $VERSION
    echo git push origin tags/$VERSION
    echo Delete local tag : git tag -d $VERSION 
    echo Delete remote tag : git push origin $VERSION
    echo Perform cherry pick : git cherry-pick  commit-id
    echo push code if it is on a branch
    echo create local tag :  git tag  $VERSION
    echo push remote tag to start the build: git push origin tags $VERSION
    echo Force replace the old by the new one on remote : git push origin tags $VERSION --force
 
} 

function start_tf_project {
    Root_PATH=$(pwd)
    Project=$1

    #create the project herarchy
    mkdir $Project
    cd $Project
    touch main.tf providers.tf variables.tf outputs.tf terraform.auto.tfvars

}

#annexes functions
add_multiline_content-github_wf() {
  local target_file="$1"

  # Utilisation d'un bloc HereDoc pour conserver l'indentation
  cat <<EOF >> "$target_file"
    name: CI Pipeline
    
    on:
      push:
        branches:
          - main
    
    jobs:
      build:
        runs-on: ubuntu-latest
        steps:
          - uses: actions/checkout@v2
          - name: Run a simple script
            run: echo "Hello, world!"
EOF
}
