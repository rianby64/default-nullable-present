#!/bin/bash

docker container stop test-prepare
docker build -t test-prepare -f test-prepare.Dockerfile .
docker run -d --rm --name test-prepare --net arca-net test-prepare

sleep 2

docker stop test-run
docker build -t test-run -f test-run.Dockerfile .
docker run -it --rm --name test-run --net arca-net test-run