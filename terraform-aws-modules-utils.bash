# this function takes 2 parameters : 
# the first parameter  is the name of the sample project on which we would test the module (can be any name)
# the second parameter is 
function grub_terraform {
    #variables
    Project=$1
    Module=$2
    old_prefix="terraform"
    new_prefix="najaws"



    #create the project herarchy
    mkdir $Project
    cd $Project
    mkdir modules
    mkdir -p env/dev
    mkdir ZZexamples
    cd modules


    #clone the specified module
    git clone --depth 1 --branch master --no-checkout https://github.com/terraform-aws-modules/${Module}.git
    cd $Module
    git sparse-checkout set   main.tf variables.tf outputs.tf versions.tf
    git checkout master
    #remove .git folder
    rm -Rf .git
    cd ..

    #replace any occurence of "terraform"
    Module=$(echo $2 | sed "s/$old_prefix/$new_prefix/")
    #move the examples on ZZexamples
	mv $2 $Module
    mv $Module/examples ../ZZexamples/${Module}_examples
    sed -i 's/source\ \=\ \"..\/..\/modules\//source\ \=\ \"..\/..\/modules\/'"$Module"'\/modules\//g' ../ZZexamples/${Module}_examples/*/main.tf
    sed -i 's/source\ \=\ \"..\/..\/\"/source\ \=\ \"..\/..\/modules\/'"$Module"'\/\"/g' ../ZZexamples/${Module}_examples/*/main.tf 
    sed -i 's/source\ \=\ \"..\/..\"/source\ \=\ \"..\/..\/modules\/'"$Module"'\/\"/g' ../ZZexamples/${Module}_examples/*/main.tf
    sed -i '/Repository\ \=\ \"https*/d' ../ZZexamples/${Module}_examples/*/main.tf
    cd ..
    tree -d -L 2 -r

}