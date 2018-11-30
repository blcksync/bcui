#!/bin/bash

curr_dir=$(cd $(dirname $0); pwd)

[ -f $curr_dir/common.sh ] && source "$curr_dir/common.sh"
export ETH_USER=${ETH_USER:-"telegram"}
export ETH_UID=${ETH_UID:-2999}
export ETH_GID=${ETH_GID:-3999}

[ -d python-telegram-bot ] && rm -rf python-telegram-bot

# git clone -b botfun-v11.1.0 --depth 1 git@github.com:matr1xc0in/python-telegram-bot.git
# pushd python-telegram-bot
# git checkout botfun-v11.1.0
# git pull
# git submodule update --init --recursive
# popd

docker build \
  -t telegrambot:latest \
  --build-arg ETH_USER=$ETH_USER \
  --build-arg ETH_UID=$ETH_UID \
  --build-arg ETH_GID=$ETH_GID \
  --file Dockerfile \
  .
