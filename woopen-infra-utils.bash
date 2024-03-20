# main fruntion: inputs : name of folder on wich you process  run acp before 
function grub_woopen_infra {

    Infra="woopen-infrastructure"
    Project=$1
    Root_PATH=$(pwd)
    PROD_ENV="env/prod"

    mkdir $Project &&  cd $Project
    git clone  --branch main https://github.com/team-homi/woopen-infrastructure.git

    clean_woopen_infra;

    update_refs_main_module;

    replace_remote_refs_locals;

    grub_submodules_woopen_infra $Infra

    clean_woopen_infra_submodules;
    # copy_existing_terraform_folder;
    # comment_s3_terraform_backend;
    # get_faked_tfvar_file;
    # reset_region_and_acc_id;
    # initialise_terraform;
    # terraform_plan;

}

function clean_woopen_infra {

    
    find . -name \*.md  -type f -delete
    find . -name \*.editorconfig  -type f -delete
    find . -name \*.gitignore  -type f -delete
    find . -name \*.sh  -type f -delete
    find . -name \*.example  -type f -delete    

    find . -type d -name ".github" | xargs rm -Rf
    find . -type d -name ".git" | xargs rm -Rf
    find . -type d -name "ansible" | xargs rm -Rf
    find . -type d -name "docs" | xargs rm -Rf

    find ./*/env -type d -name "staging" | xargs rm -Rf    
    find ./*/env -type d -name "dev" | xargs rm -Rf    
    find ./*/env -type d -name "iso-prod" | xargs rm -Rf    


}

function update_refs_main_module {

    sed -i 's/source\ \=\ .*base.*/source\ \=\ \"..\/..\/modules\/base\"/g' ./*/env/*/main.tf

}
function replace_remote_refs_locals {

    sed -i 's/version\ \=\ \"\~.*//g' ./*/modules/*/*.tf

    sed -i 's/source\ \ \=\ \".*acm.*/source\ \ \=\ \"..\/..\/sub-modules\/acm\"/g' ./*/modules/*/*.tf
    sed -i 's/source\ \ \=\ \".*lambda.*/source\ \ \=\ \"..\/..\/sub-modules\/lambda\"/g' ./*/modules/*/*.tf
    sed -i 's/source\ \ \=\ \".*vpc.*/source\ \ \=\ \"..\/..\/sub-modules\/vpc\"/g' ./*/modules/*/*.tf
    sed -i 's/source\ \ \=\ \".*s3.*/source\ \ \=\ \"..\/..\/sub-modules\/s3\"/g' ./*/modules/*/*.tf
    sed -i 's/source\ \ \=\ \".*acm.*/source\ \ \=\ \"..\/..\/sub-modules\/acm\"/g' ./*/modules/*/*.tf
    sed -i 's/source\ \ \=\ \".*ecr.*/source\ \ \=\ \"..\/..\/sub-modules\/ecr\"/g' ./*/modules/*/*.tf
    sed -i 's/source\ \ \=\ \".*cloudfront.*/source\ \ \=\ \"..\/..\/sub-modules\/cloudfront\"/g' ./*/modules/*/*.tf
    sed -i 's/source\ \ \=\ \".*alb.*/source\ \ \=\ \"..\/..\/sub-modules\/alb\"/g' ./*/modules/*/*.tf
    # fargate submodules updates
    sed -i 's/source\ \ \=\ \".*fargate.*service.*/source\ \ \=\ \"..\/..\/sub-modules\/fargate\/modules\/service\"/g' ./*/modules/*/*.tf
    sed -i 's/source\ \ \=\ \".*fargate.*task.*/source\ \ \=\ \"..\/..\/sub-modules\/fargate\/modules\/task\"/g' ./*/modules/*/*.tf
    sed -i 's/source\ \ \=\ \".*fargate.*container.*/source\ \ \=\ \"..\/..\/sub-modules\/fargate\/modules\/container\"/g' ./*/modules/*/*.tf
    sed -i 's/source\ \ \=\ \".*fargate.*cluster.*/source\ \ \=\ \"..\/..\/sub-modules\/fargate\/modules\/cluster\"/g' ./*/modules/*/*.tf

}
# This function is used to grab the whole infrastructure for the wopen project including all the sub modules
# First parameter is the name of the sample project: Project
function grub_submodules_woopen_infra {

    custom_lambda_path="/mnt/c/Users/NizarAjroud/NZSPCE/OPERATIONAL/TECH_DOCS/PROJECTS/Woopen/WOOPEN-CONFIGS/lambda-code-main-v1"


    mkdir $Infra/sub-modules && cd $Infra/sub-modules

    # git clone  --branch main https://github.com/team-homi/woopen_terraform-aws-lambda
    mkdir lambda && cd lambda && cp $custom_lambda_path/* . && cd ..
    git clone  --branch main https://github.com/team-homi/woopen_terraform-aws-vpc.git
    git clone  --branch main https://github.com/team-homi/woopen_terraform-aws-s3.git
    git clone  --branch main https://github.com/team-homi/woopen_terraform-aws-acm
    git clone  --branch main https://github.com/team-homi/woopen_terraform-aws-fargate.git
    git clone  --branch main https://github.com/team-homi/woopen_terraform-aws-ecr.git
    git clone  --branch main https://github.com/team-homi/woopen_terraform-aws-cloudfront.git
    git clone  --branch main https://github.com/team-homi/woopen_terraform-aws-alb.git
}

function clean_woopen_infra_submodules {

    for file in *; do mv "${file}" "${file/woopen_terraform-aws-/}"; done
    
    #find . -name \*.md  -type f -delete
    find . -name \*.editorconfig  -type f -delete
    find . -name \*.gitignore  -type f -delete

    find . -type d -name ".github" | xargs rm -Rf
    find . -type d -name ".git" | xargs rm -Rf

}

function copy_existing_terraform_folder {
    cp -R  $Root_PATH/save_tf/.terraform $Root_PATH/$Project/$Infra/$PROD_ENV
    # cd /path/to/SOURCE_FOLDER; tar cf - . | (cd /path/to/DESTINATION_FOLDER; tar xvf -)
}
function comment_s3_terraform_backend {
    sed -i '/backend "s3"/{:a;s/.*/#\0/;/}/!{n;ba}}' $Root_PATH/$Project/$Infra/$PROD_ENV/providers.tf
}

function initialise_terraform {
    cd $Root_PATH/$Project/$Infra
    terraform fmt -recursive
    cd $PROD_ENV
    terraform init
}
function get_faked_tfvar_file {
    cp   $Root_PATH/save_tf/tfvars/prod/terraform.auto.tfvars $Root_PATH/$Project/$Infra/$PROD_ENV/
    sed -i 's/= "/= "FAKED_/g' $Root_PATH/$Project/$Infra/$PROD_ENV/terraform.auto.tfvars

}
function terraform_plan {
    cd $Root_PATH/$Project/$Infra/$PROD_ENV/
    terraform plan

}

function reset_region_and_acc_id {

    sed -i 's/945387379655/247117250760/g' $Root_PATH/$Project/$Infra/$PROD_ENV/*.tf
    sed -i 's/945387379655/247117250760/g' $Root_PATH/$Project/$Infra/modules/*/*.tf

    sed -i 's/eu-west-3/us-east-1/g' $Root_PATH/$Project/$Infra/$PROD_ENV/*.tf
    sed -i 's/eu-west-3/us-east-1/g' $Root_PATH/$Project/$Infra/modules/*/*.tf

    # sed -i 's/${var.account_id}/XXXXX/g' $Root_PATH/$Project/$Infra/$PROD_ENV/providers.tf
    # sed -i '/assume_role {/{:a;s/.*/#\0/;/}/!{n;ba}}' $Root_PATH/$Project/$Infra/$PROD_ENV/providers.tf
# acp iam admin
# terraform plan
# terraform.tfstate

}


