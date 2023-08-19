#!/bin/bash
docker volume rm $(docker volume ls -q)
docker rm $(docker volume ls -q)
docker rm -f $(docker ps -a -q)
docker rmi -f $(docker images -a -q)
