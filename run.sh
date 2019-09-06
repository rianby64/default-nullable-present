#!/bin/bash

docker network create arca-net

docker build -t test-prepare -f test-prepare.Dockerfile .
docker run -d --rm --name test-prepare --net arca-net test-prepare

sleep 2

docker build -t test-run -f test-run.Dockerfile .
docker run --rm --name test-run --net arca-net test-run
