#!/bin/bash

docker build \
  -t telegrambot:latest \
  --file Dockerfile \
  .
