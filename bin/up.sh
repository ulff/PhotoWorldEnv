#!/usr/bin/env bash

if [ ! -d "PhotoWorld" ]; then
  git clone git@github.com:ulff/PhotoWorld.git
fi

docker-compose up -d
