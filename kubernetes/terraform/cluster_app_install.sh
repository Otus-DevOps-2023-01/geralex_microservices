#!/bin/bash

set -e

cd ../reddit

#Установим Ingress-Controller (https://cloud.yandex.ru/docs/managed-kubernetes/tutorials/nginx-ingress-certificate-manager) -->> Ссылка зщапасной вариант...

#Создадим dev namespace
kubectl apply -f ./dev-namespace.yml
#Задеплоим все компоненты приложения в namespace dev
#kubectl apply -f . -n dev
kubectl apply -f ./ui-deployment.yml -n dev
kubectl apply -f ./ui-service.yml -n dev
#!!!Выполнять отдельно после генерации сертификата/ключа под выделенный IP-адрес!!!
#kubectl apply -f ./tls.yml -n dev
#kubectl apply -f ./ui-ingress.yml -n dev

kubectl apply -f ./mongo-volume.yml -n dev

kubectl apply -f ./mongo-deployment.yml -n dev
kubectl apply -f ./mongodb-service.yml -n dev
kubectl apply -f ./mongo-network-policy.yml -n dev

kubectl apply -f ./comment-deployment.yml -n dev
kubectl apply -f ./comment-service.yml -n dev
kubectl apply -f ./comment-mongodb-service.yml -n dev

kubectl apply -f ./post-deployment.yml -n dev
kubectl apply -f ./post-service.yml -n dev
kubectl apply -f ./post-mongodb-service.yml -n dev


#kubectl get ingress -n dev
