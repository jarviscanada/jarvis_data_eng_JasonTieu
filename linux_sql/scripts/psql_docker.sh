#!/bin/bash

#Capture CLI arguments
cmd=$1
db_username=$2
db_password=$3

#start Docker
sudo systemctl status docker --no-pager || systemctl start docker

#Check container Status
docker container inspect jrvs-psql
container_status=$?

#Switch case for START|STOP|CREATE options
case $cmd in
  create)

    #Check if container is already created
    if [ $container_status -eq 0 ]; then
      echo 'Container already exist'
      exit 1
    fi

    #check # of CTL arguments (Less than 3 arguments)
    if [ $# -ne 3 ]; then
      echo 'Create requires username and password'
      exit 1
    fi

    #Create container
    docker volume create pgdata
    #Start the container
    docker run --name jrvs-psql -e POSTGRES_USERNAME=$db_username -e POSTGRES_PASSWORD=$db_password -d -v pgdata:/var/lib/postgresql/data -p 5432:5432 postgres:9.6-alpine

    exit $?
  ;;

  start|stop)
    #Check instance status; exit 1 if container was not created yet
    if [ $container_status -ne 0 ]; then
      echo 'container was not created yet'
      exit 1
    fi

    # Start or stop the container
    docker container $cmd jrvs-psql
    exit $?
  ;;

  *)#any other case
      echo 'Illegal Command'
      echo 'Commands: start|stop|create'
      exit 1
  ;;

esac