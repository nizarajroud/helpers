REPO_NAME=$1

git init
git add .
git commit -m "initial commit"

gh repo create $REPO_NAME --private
git branch -M main
git remote add origin https://github.com/nizarajroud/$REPO_NAME.git
git push -u origin main
