#!/bin/bash

#helm upgrade --install test-ui-1 ui/ --create-namespace --namespace dev

#добавляем чарт для mongodsb
#helm repo add mongodb https://mongodb.github.io/helm-charts

cd ./reddit
helm dep update ./reddit
helm dependency build
# временно разворачиваем наше решение в ns - default
helm upgrade --install --set name=reddit-test reddit --create-namespace --namespace dev .
