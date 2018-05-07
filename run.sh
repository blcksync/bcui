#!/bin/bash

IMG_NAME=telegrambot:latest
RUNTIME_CONTAINER_NAME=telegrambot:latest
# devnetbc_bot
TELEGRAM_TOKEN_API=${TELEGRAM_TOKEN_API:-"540001793:AAHKWLPOd9Am6pUnIR5YRflbafWYyQABv5Y"}

docker run -it \
  --rm \
  --label $RUNTIME_CONTAINER_NAME \
  --env TELEGRAM_TOKEN_API="$TELEGRAM_TOKEN_API" \
  $IMG_NAME
  bash -l
