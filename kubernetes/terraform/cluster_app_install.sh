#!/bin/bash

set -e

cd ../reddit

#Создадим dev namespace
kubectl apply -f ./dev-namespace.yml
#Задеплоим все компоненты приложения в namespace dev
kubectl apply -f . -n dev
#kubectl apply -f ./ui-deployment.yml -n dev
#kubectl apply -f ./ui-service.yml -n dev
