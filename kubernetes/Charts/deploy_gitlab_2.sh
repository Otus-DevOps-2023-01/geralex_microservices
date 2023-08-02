#!/bin/bash

GITLAB_TOKEN=$1 ## glpat-p8sVzTJ-urPirkkP2FXG
REGISTRY_PASSWORD=$2 ##H1dpnijs88!##
GROUP_ID=$3

echo ${GROUP_ID}
#curl --header "PRIVATE-TOKEN: $1" -X POST "http://$GITLAB_IP/api/v4/projects?name=crawler&description=hello_otus&initialize_with_readme=true"

## Создать группу через UI - через API - нету функционала!!

## Создаём ci/cd variables

curl --request POST --header "PRIVATE-TOKEN: $1" \
     "http://gitlab.otus.local/api/v4/groups/$3/variables" --form "key=CI_REGISTRY_USER" --form "value=geralex88"
	 
curl --request POST --header "PRIVATE-TOKEN: $1" \
     "http://gitlab.otus.local/api/v4/groups/$3/variables" --form "key=CI_REGISTRY_PASSWORD" --form "value=$2"
	 
## Создаем проекты
curl --request POST --header "PRIVATE-TOKEN: $1" \
     --header "Content-Type: application/json" --data '{
        "name": "reddit-deploy", "description": "New Project", "path": "reddit-deploy",
        "namespace_id": "4", "initialize_with_readme": "true"}' \
     --url 'http://gitlab.otus.local/api/v4/projects/' 
	 
curl --request POST --header "PRIVATE-TOKEN: $1" \
     --header "Content-Type: application/json" --data '{
        "name": "comment", "description": "New Project", "path": "comment",
        "namespace_id": "4", "initialize_with_readme": "true"}' \
     --url 'http://gitlab.otus.local/api/v4/projects/' 
	 
curl --request POST --header "PRIVATE-TOKEN: $1" \
     --header "Content-Type: application/json" --data '{
        "name": "post", "description": "New Project", "path": "post",
        "namespace_id": "4", "initialize_with_readme": "true"}' \
     --url 'http://gitlab.otus.local/api/v4/projects/' 
	 
curl --request POST --header "PRIVATE-TOKEN: $1" \
     --header "Content-Type: application/json" --data '{
        "name": "ui", "description": "New Project", "path": "ui",
        "namespace_id": "4", "initialize_with_readme": "true"}' \
     --url 'http://gitlab.otus.local/api/v4/projects/' 
