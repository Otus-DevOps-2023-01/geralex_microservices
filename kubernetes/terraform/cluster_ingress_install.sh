#!/bin/bash

set -e

#Установим Ingress-Controller (https://cloud.yandex.ru/docs/managed-kubernetes/tutorials/nginx-ingress-certificate-manager) -->> Ссылка зщапасной вариант...

#Создайте авторизованный ключ для сервисного аккаунта и сохраните его в файл authorized-key.json:
#yc iam key create \
  --service-account-name eso-service-account \
  --output authorized-key.json
  
#Назначьте роль certificate-manager.certificates.downloader сервисному аккаунту eso-service-account, чтобы он мог читать содержимое сертификата:
#yc cm certificate add-access-binding \
  --id <идентификатор_сертификата> \
  --service-account-name eso-service-account \
  --role certificate-manager.certificates.downloader

#helm repo add sonatype https://sonatype.github.io/helm3-charts/

#helm install nx340 -n nexus -f nexus.yaml sonatype/nexus-repository-manager --create-namespace

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.34.1/deploy/static/provider/cloud/deploy.yaml

#Генерируем проект + ci + cd 


##Secret && TLS
#kubectl get ingress -n dev
#openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout tls.key -out tls.crt -subj "/CN=35.190.66.90"
#kubectl create secret tls ui-ingress --key tls.key --cert tls.crt -n dev
#kubectl describe secret ui-ingress -n dev

#openssl req -x509 -newkey rsa:4096 -nodes \
  -keyout key.pem \
  -out cert.pem \
  -days 365 \
  -subj '/CN=example.com'
  
https://console.cloud.yandex.ru/folders/b1g3l9isrnq8ofkdnu9b/certificate-manager/certificates
  
#kubectl create secret tls kifia-tls-cert --key kifia.key --cert kifia.cp02.cikrf.cp.crt -n master
#kubectl create configmap cacerts --from-file=cacerts -n master
#kubectl apply -f kifia-ingress-master.yaml

#$ kubectl delete ingress ui -n dev
#$ kubectl apply -f ui-ingress.yml -n dev

#cat tls.crt | base64
#cat tls.key | base64