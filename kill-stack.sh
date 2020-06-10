#!/bin/bash -m
# -*- coding: utf-8 -*-

function check_dep {
    for i in "$@"; do
        command -v "$i" &> /dev/null || {
            echo -e "!! Please install $i first. Aborting." >&2
            exit 1
        }
    done
}

check_dep docker

# kill Elasticsearch
RUNNING=$(docker inspect --format="{{.State.Running}}" elasticsearch 2> /dev/null)
if [ "$RUNNING" = "true" ] ; then
    printf "\nElasticsearch container running. Stopping...\n"
    docker stop elasticsearch > /dev/null 2>&1
fi
docker rm elasticsearch > /dev/null 2>&1

# kill pygeoapi
RUNNING=$(docker inspect --format="{{.State.Running}}" opendrr-api-pygeoapi 2> /dev/null)
if [ "$RUNNING" = "true" ]; then
    printf "\npygeoapi container running. Stopping...\n"
    docker stop opendrr-api-pygeoapi > /dev/null 2>&1
fi
docker rm opendrr-api-pygeoapi > /dev/null 2>&1

# kill Kibana
RUNNING=$(docker inspect --format="{{.State.Running}}" opendrr-api-kibana 2> /dev/null)
if [ "$RUNNING" = "true" ] ; then
    printf "\nKibana container running. Stopping...\n"
    docker stop opendrr-api-kibana > /dev/null 2>&1
fi
docker rm opendrr-api-kibana > /dev/null 2>&1

# kill PostGreSQL/PostGIS
RUNNING=$(docker inspect --format="{{.State.Running}}" opendrr-api-postgis 2> /dev/null)
if [ "$RUNNING" = "true" ] ; then
    printf "\nPostGIS container running. Stopping...\n"
    docker stop opendrr-api-postgis > /dev/null 2>&1
fi
docker rm opendrr-api-postgis > /dev/null 2>&1

printf "\nStack killed!\n"