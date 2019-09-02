#!/bin/bash

docker stop test-run
docker build -t test-run -f test-run.Dockerfile .
docker run -it --rm --name test-run --net arca-net test-run