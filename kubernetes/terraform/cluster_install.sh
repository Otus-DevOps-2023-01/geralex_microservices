#!/bin/bash

set -e

cd terraform
TF_IN_AUTOMATION=1 terraform init
TF_IN_AUTOMATION=1 terraform apply -auto-approve

#Обновляем kube config
yc managed-kubernetes cluster get-credentials k8s-master --external

#Устанавливаем ingress-controller
#helm list -n ingress-nginx
#helm repo update
#helm install ingress-nginx ingress-nginx/ingress-nginx --namespace ingress-nginx --create-namespace
#kubectl get ingress -n dev