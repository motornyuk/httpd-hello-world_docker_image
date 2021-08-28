#!/usr/bin/env bash
#

# Docker server
docker_server="docker.io"

# Docker repo
docker_repo="motornyuk/httpd-hello-world"

# Docker tag
docker_tag="latest"

# Git server
git_server="git@github.com"

# Gi repo
git_repo="motornyuk/http-hello-world_docker_image.git"

# Log file
declare -r log="./log_build.log"
cat /dev/null > "${log}"

# Generate timestamp
function timestamp() {
  date +"%Y%m%d_%H%M%S"
}

# Log and Print
logger() {
    printf "$1\n"
    printf "$(timestamp) - $1\n" >> "${log}"
}

# Exception Catcher
except () {
    logger $1
    return 1
}

# Assign timestamp to ensure var is a static point in time.
declare -r timestp=$(timestamp)
logger "Starting Build. Timestamp: ${timestp}\n"

# Build the image
function build() {
  local cmd
  cmd="docker build . -t ${docker_server}/${docker_repo}:${docker_tag} >> ${log}"
  logger "Running Docker Build Command: \"$cmd\""
  docker build . -t "${docker_server}"/"${docker_repo}":"${docker_tag}" >> "${log}" || except "Error! docker build failed"
}

# Push to github
function git() {
  git="/usr/bin/git -C ./"
  ${git} -C './' pull "${git_server}":"${git_repo}" >> "${log}" || except "git pull failed!"
  ${git} add --all >> "${log}" || except "git add failed!"
  ${git} commit -a -m "Automatic build ${docker_repo}:${docker_tag}" >> "${log}" || except "git commit failed!"
  ${git} push >> "${log}" || except "git push failed!"
} 

# Push the new tag to Docker
function docker_push() {
  echo "Pushing ${docker_repo}:${docker_tag}..."
  docker push "${docker_repo}":"${docker_tag}" >> "${log}" || except "docker image ${docker_repo}:${docker_tag} push failed!"
}

# Prune the git tree in the local dir
function prune() {
  logger "Running git gc --prune"
  /usr/bin/git gc --prune
}


function main() {
build
git
docker_push
prune
logger "All complete."
}

main
