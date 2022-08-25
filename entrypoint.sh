#!/bin/sh -l

sleep 20

git_user=$1
git_password=$2
image_tag=$3
app_name=$4
env=$5
git_repo=$6
git_branch=$7
github_token=$8

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
#git remote set-url origin https://github.com/${git_repo}.git
#git config user.email "$git_user"
#git config user.name "$git_user"
#git config --global --add safe.directory '*'
echo -e "\nSetting GitHub credentials..."
# Prevents issues with: fatal: unsafe repository ('/github/workspace' is owned by someone else)

if [[ -z "${github_token}" ]]; then
  # shellcheck disable=SC2016
  MESSAGE='Missing env var "github_token: ${{ secrets.GITHUB_TOKEN }}".'
  echo -e "[ERROR] ${MESSAGE}"
  exit 1
fi
git config --global --add safe.directory "${GITHUB_WORKSPACE}"
git config --global --add safe.directory /github/workspace
git remote set-url origin "https://${GITHUB_ACTOR}:${GITHUB_TOKEN}@github.com/${git_repo}"
git config --global user.name "${GITHUB_ACTOR}"
git config --global user.email "${GITHUB_ACTOR}@users.noreply.github.com"
# Needed for hub binary
export GITHUB_USER="${GITHUB_ACTOR}"
git add .
git commit -m "Image tag in ${app_name}/values.yaml for ${app_name} with ${image_tag}"
git push -u origin ${git_repo}
echo "==> Updated image tag in ${env}/${app_name}/values.yaml for ${app_name}"


status="Updated image tag in ${app_name}/values.yaml for ${app_name}"
echo "::set-output name=status::$status"
