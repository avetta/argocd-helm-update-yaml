#!/bin/sh -l

sleep 20

git_user=$1
git_password=$2
image_tag=$3
app_name=$4
env=$5
git_repo=$6
git_branch=$7

DIR="$( cd "$( dirname "$0" )" && pwd )" && ls -latr
VALUES_FILE=avetta/configs/${env}/${app_name}/values.yaml
old_tag=$(cat avetta/configs/${env}/${app_name}/values.yaml | grep tag: | awk '{print $2}')
echo "==> Old image tag is ${old_tag}"
if [[ -z ${old_tag} ]]; then
echo "==> tag is null! trying to update tag..."
sed -i "s/tag:/tag: ${image_tag}/" $VALUES_FILE
elif [[ ${old_tag} != ${image_tag} ]]; then
echo "==> updating tag to ${image_tag}"
sed -i "s/tag: ${old_ta}/tag: ${image_tag}/" $VALUES_FILE
else
echo "==> Nothing to update"
exit 0
fi

#yq -i eval ".image.tag = \"${image_tag}\"" $VALUES_FILE
git remote set-url origin https://github.com/${git_repo}.git
git config user.email "$git_user"
git config user.name "$git_user"
git config --global --add safe.directory /github/workspace
git add .
git commit -m "Image tag in ${app_name}/values.yaml for ${app_name} with ${image_tag}"
git push -u origin originize_repo
echo "==> Updated image tag in ${env}/${app_name}/values.yaml for ${app_name}"


status="Updated image tag in ${app_name}/values.yaml for ${app_name}"
echo "::set-output name=status::$status"
