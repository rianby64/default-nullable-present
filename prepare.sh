#!/bin/bash

docker container stop test-prepare
docker build -t test-prepare -f test-prepare.Dockerfile .
docker run -d --rm --name test-prepare --net arca-net test-prepare