# argocd-helm-update-yaml

argocd-helm-update-yaml is a github action used to update image tag in helm values file

Action has to be invoked with below parameters

## Inputs

### `git_user`

**Required** username to access github repo

### `git_password`

**Required** Personal Access Token for k8s deployment files repo

### `image_tag`

**Required** Image tag of the docker image

### `app_name`

**Required** App name to be updated

### `env`

**Required** Environment to be update


### `git_repo`

**Required** Repo Name where Helm Chart files exits


### `git_branch`

**Required** Branch Name

```         
      - name: ArgoCD Repo Checkout
        uses: actions/checkout@v3
        with:
          repository: reponame
          token: ${{ secrets.GH_TOKEN }}
          ref: originize_repo

      - name: Update image tag in helm chart
        uses: avetta/argocd-helm-update-yaml@main # Uses an action in the root directory
        id: deployment-update
        with:
          git_user: username
          git_password: ${{ secrets.GH_TOKEN }} 
          image_tag: ${{needs.build-and-push-docker-image.outputs.new_tag}}
          app_name: ${{needs.build-and-push-docker-image.outputs.app_name}}
          environment: dot
          git_repo: reponame
          git_branch: originize_repo
```
