# geralex_microservices
geralex microservices repository

ДЗ по kubernetes-4

 - Написаны helm-chartы в формате yaml для разворачивания в кубере нашего приложения с использованием утилиты helm
 - В рамках изменений на стороне YC была повышена версия Kubernetes с 1.22 до 1.23

Для создания кластера кубера в Yandex.Cloud, необходимо создать файл private.auto.tfvars на основе private.auto.tfvars.example. 
Заполнить информацию для подключения к YC, имя сервисного акаунта и кол-во node.
Затем запустить bash-скрипт cluster_install.sh из каталога kubernetes\terraform для разворачивания кластера kubernetes в YC

Затем запустить bash-скрипт deploy_gitlab.sh для разворачивания gitlab, после выделения ip в ingress-controller прописать адреса в файл hosts (kubectl get ingress -A)
#echo "*.*.*.* kas.example.com minio.example.com registry.example.com gitlab.example.com" >> /etc/hosts

Перейти в gitlab UI по ссылке gitlab.otus.local для авторизации использовать логин root пароль из секрета
kubectl get secret gitlab-gitlab-initial-root-password -n infra -o yaml
затем декомпилировать base64 -d секрет из data: password:
Создать группу, так как Gitlab API не позволяет создавать группы через API, записать Group_ID понадобится для запуска скрипта генерации проектов
Создать token для пользователя чтобы дальше взаимодействовать по API, записать token понадобится для запуска скрипта генерации проектов
Скопировать из Admin Area token для глобальной регистрации gitlab-runner-а, записать token понадобится для запуска скрипта генерации проектов

#Затем скорректировать файл Charts\gitlab-runners\values.yaml в части указать ранее записанный token для регистрации runner-а (runnerRegistrationToken), а твкже URL
Для регистрации gitlab-runner-а необходимо добавить A-запись в DNS-server YC
gitlab.otus.local.ru-central1.internal. -> ExternalIP (Ingress-controller)
registry.otus.local.ru-central1.internal. -> ExternalIP (Ingress-controller)

Затем скорректировать файл deploy_gitlab_2.sh в части указать GROUP_ID в вызове API через curl
Затем запустить bash-скрипт deploy_gitlab_2.sh для генерации проекта в gitlab по средством вызова API передать на вход три параметра: token пользователя, пароль от docker hub, идентификатор группы в которой будем генерировать проекты
Затем запустите bash-скрипт deploy_gitlab_3.sh для наполнения ранее созданных проектов исходными кодами, файлом для организации ci/cd и push изменений в ранее развернутый gitlab

Для удаления созданных ресурсов в Yandex.Cloud - выполнить bash-скрипт cluster_destroy.sh из каталога kubernetes\terraform


ДЗ по kubernetes-3
 - Обновлены и созданы manifest-файлы в формате yaml для разворачивания в кубере нашего приложения, включая доступность по сети до ui + pv и pvc для работы с БД
 - Для создания кластера кубера в Yandex.Cloud, необходимо создать файл private.auto.tfvars на основе private.auto.tfvars.example.
 Заполнить информацию для подключения к YC, имя сервисного акаунта и кол-во node. Затем запустить bash-скрипт cluster_install.sh 
 Затем запустить bash-скрипт cluster_app_install.sh для разворачивания нашего приложения.
 Отдельно требуется сгенерировать самоподписанный сертификат для создания секрета через yaml файл, в файле обновить информацию по сертификату!
  #!!!Выполнять отдельно после генерации сертификата/ключа под выделенный IP-адрес!!!
  #kubectl apply -f ./tls.yml -n dev
  #kubectl apply -f ./ui-ingress.yml -n dev
 - Для удаления созданных ресурсов в Yandex.Cloud - выполнить bash-скрипт cluster_destroy.sh

 - В каталоге kubernetes добавлены два скриншота, где можно видеть, что после удаления и создания deploy БД сообщения остались (Image_03_State_01.png Image_03_State_02.png)
 
ДЗ по kubernetes-2
 - Обновлены и созданы manifest-файлы в формате yaml для разворачивания в кубере нашего приложения, включая доступность по сети до ui
 - Для создания кластера кубера в Yandex.Cloud, необходимо создать файл private.auto.tfvars на основе private.auto.tfvars.example.
 Заполнить информацию для подключения к YC, имя сервисного акаунта и кол-во node. Затем запустить bash-скрипт cluster_install.sh 
 Затем запустить bash-скрипт cluster_app_install.sh для разворачивания нашего приложения.
 - Для удаления созданных ресурсов в Yandex.Cloud - выполнить bash-скрипт cluster_destroy.sh
 - В каталоге kubernetes приложены два скриншота ui-веб интерфейса из кластера кубера + скриншоты с kubectl

ДЗ по kubernetes-1
 - Созданы manifest-файлы в формате yaml для разворачивания в кубере нашего приложения
 - Для создания кластера кубера в Yandex.Cloud, необходимо создать файл private.auto.tfvars на основе private.auto.tfvars.example, заполнить информацию для подключения к YC, имя сервисного акаунта и кол-во node. Затем запустить bash-скрипт cluster_install.sh 
 - Для удаления созданных ресурсов в Yandex.Cloud - выполнить bash-скрипт cluster_destroy.sh

ДЗ по logging-1
 - Логирование docker-контейнеров
 - Сбор и визуализация логов
 - Работа с драйвером для сбора логов fluentd
 - Работа с инструментами - EFK

ДЗ по monitoring-1
 - Научились запускать и конфигурировать prometeus
 - Реализовали мониторинг микросервисного приложения
 - Добавлен мониторинг mongodb, а так же blackbox микросервиса

 Ссылки на образы в докерхаб:
 docker push geralex88/prometheus:tagname
 docker push geralex88/post:tagname
 docker push geralex88/comment:tagname
 docker push geralex88/ui:tagname

ДЗ по gitlab-ci
 - Научились поднимать gitlab-ce и gitlab-runner через docker
 - Настроили свой первый pipeline в рамках организации ci/cd
 - Добавили сборку приложения reddit и пуш в docker-registery (Для сборку требуется скорректировать конфиг раннера!)

ДЗ по docker-4

 - Научились собирать образы приложения reddit с помощью docker-compose
 - Задать имя образа используя container_name, данная настройка вынесена так же в переменную .envs

ДЗ по docker-3

 - Загружено приложение reddit-microservices;
 - Реализовано через Dockerfile сборка и разворачивание трех приложений "comment" "post-py" "ui";
 - Дополнительно оптимизирована сборка приложения post-py (обновлены версии компонентов и отключен лог так как мешало запуску, требуется привлечение разработчика для обновления кода) тем самым убраны при сканировании в 0 уязвимости приложения;
 - Оптимизировано использование базовых образов тем самым уменьшены размеры докер образов в десятки раз;
 - Дополнительно запускаем mongodb с подключением локального volme для хранения сообщений;

ДЗ по docker-2

В рамках данного ДЗ:
- Установили docker, docker-compose, docker machine
- Создали свой образ
- Создали docker host
- Зарегистрировались на Docker Hub с последующей загрузкой образа в публичное хранилище для последующего использования в работе без необходимости новой сборки
