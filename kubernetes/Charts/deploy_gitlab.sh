#!/bin/bash

#cd ./gitlab
cd gitlab
helm upgrade --install gitlab . -f values.yaml --create-namespace --namespace infra

#kubectl get ingress -A
#kubectl get service -n nginx-ingress nginx

#echo "51.250.95.135 kas.example.com minio.example.com registry.example.com gitlab.example.com" >> /etc/hosts

# Otus HW
#51.250.75.45 kas.otus.local minio.otus.local registry.otus.local gitlab.otus.local