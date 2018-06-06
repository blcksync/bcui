#!/bin/bash

curr_dir=$(cd $(dirname $0); pwd)
PROD_CODE=${PROD_CODE:-""}
SRC_DOCKER_DEPLOY_DIR="$curr_dir/prod"

[ -f $curr_dir/common.sh ] && source "$curr_dir/common.sh"
export ETH_USER=${ETH_USER:-"telegram"}
export ETH_UID=${ETH_UID:-2999}
export ETH_GID=${ETH_GID:-3999}

IMG_NAME=html-dev:latest
RUNTIME_CONTAINER_NAME=html-dev:latest
# devnetbc_bot
TELEGRAM_TOKEN_API=${TELEGRAM_TOKEN_API:-"not_defined"}

export PROD_CODE="/Users/banana/Documents/Google_Drive/Google Drive - blcksync/bcui/html"
mkdir -p "$SRC_DOCKER_DEPLOY_DIR" && rsync -av "$PROD_CODE" "$SRC_DOCKER_DEPLOY_DIR/"

docker run -it \
  --rm \
  --label $RUNTIME_CONTAINER_NAME \
  --env TELEGRAM_TOKEN_API="$TELEGRAM_TOKEN_API" \
  --env ETH_USER="$ETH_USER" \
  --env ETH_UID="$ETH_UID" \
  --env ETH_GID="$ETH_GID" \
  --mount type=bind,source="$SRC_DOCKER_DEPLOY_DIR/html",target=/usr/share/nginx/html,readonly \
  --publish 80:8080 \
  $IMG_NAME
  bash -l
