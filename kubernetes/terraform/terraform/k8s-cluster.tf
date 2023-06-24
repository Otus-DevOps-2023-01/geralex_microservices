# Variables

variable "yc_token" {
  type = string
  description = "Yandex Cloud API key"
}

variable "yc_cloud_id" {
  type = string
  description = "Yandex Cloud id"
}

variable "yc_folder_id" {
  type = string
  description = "Yandex Cloud folder id"
}

variable "k8s_version" {
  type = string
  description = "Yandex Cloud k8s version"
}

variable "sa_name" {
  type = string
  description = "Yandex Cloud Service Account Name"
}

# Provider

terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  token     = var.yc_token
  cloud_id  = var.yc_cloud_id
  folder_id = var.yc_folder_id
}

#Create k8s

resource "yandex_kubernetes_cluster" "k8s-zonal" {
  name       = "my-cluster"
  description = "my-cluster description"
  network_id = yandex_vpc_network.mynet.id
  master {
    version = var.k8s_version
    zonal {
      zone      = yandex_vpc_subnet.mysubnet.zone
      subnet_id = yandex_vpc_subnet.mysubnet.id
    }
	public_ip = true # доступность из вне
    security_group_ids = [yandex_vpc_security_group.k8s-public-services.id]
  }
  service_account_id      = yandex_iam_service_account.myaccount.id
  node_service_account_id = yandex_iam_service_account.myaccount.id
  depends_on = [
    yandex_resourcemanager_folder_iam_member.k8s-clusters-agent,
    yandex_resourcemanager_folder_iam_member.vpc-public-admin,
    yandex_resourcemanager_folder_iam_member.images-puller,
	yandex_resourcemanager_folder_iam_member.sa-k8s-admin-permissions
  ]
  release_channel = "STABLE" # Релизный канал
  network_policy_provider = "CALICO" # Включить сетевые политики Calico
  kms_provider {
    key_id = yandex_kms_symmetric_key.kms-key.id
  }
}

resource "yandex_vpc_network" "mynet" {
  name = "mynet"
}

resource "yandex_vpc_subnet" "mysubnet" {
  v4_cidr_blocks = ["10.1.0.0/16"]
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.mynet.id
}

resource "yandex_iam_service_account" "myaccount" {
  folder_id = var.yc_folder_id
  name        = var.sa_name
  description = "K8S zonal service account"
}

resource "yandex_resourcemanager_folder_iam_member" "k8s-clusters-agent" {
  # Сервисному аккаунту назначается роль "k8s.clusters.agent".
  folder_id = var.yc_folder_id
  role      = "k8s.clusters.agent"
  member    = "serviceAccount:${yandex_iam_service_account.myaccount.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "sa-k8s-admin-permissions" {
  # Сервисному аккаунту назначается роль "admin".
  folder_id = var.yc_folder_id
  role      = "admin"
  member    = "serviceAccount:${yandex_iam_service_account.myaccount.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "vpc-public-admin" {
  # Сервисному аккаунту назначается роль "vpc.publicAdmin".
  folder_id = var.yc_folder_id
  role      = "vpc.publicAdmin"
  member    = "serviceAccount:${yandex_iam_service_account.myaccount.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "images-puller" {
  # Сервисному аккаунту назначается роль "container-registry.images.puller".
  folder_id = var.yc_folder_id
  role      = "container-registry.images.puller"
  member    = "serviceAccount:${yandex_iam_service_account.myaccount.id}"
}

resource "yandex_kms_symmetric_key" "kms-key" {
  # Ключ для шифрования важной информации, такой как пароли, OAuth-токены и SSH-ключи.
  name              = "kms-key"
  default_algorithm = "AES_128"
  rotation_period   = "8760h" # 1 год.
}

resource "yandex_resourcemanager_folder_iam_member" "viewer" {
  folder_id = var.yc_folder_id
  role      = "viewer"
  member    = "serviceAccount:${yandex_iam_service_account.myaccount.id}"
}

resource "yandex_vpc_security_group" "k8s-public-services" {
  name        = "k8s-public-services"
  description = "Правила группы разрешают подключение к сервисам из интернета. Примените правила только для групп узлов."
  network_id  = yandex_vpc_network.mynet.id
  ingress {
    protocol          = "TCP"
    description       = "Правило разрешает проверки доступности с диапазона адресов балансировщика нагрузки. Нужно для работы отказоустойчивого кластера Managed Service for Kubernetes и сервисов балансировщика."
    predefined_target = "loadbalancer_healthchecks"
    from_port         = 0
    to_port           = 65535
  }
  ingress {
    protocol          = "ANY"
    description       = "Правило разрешает взаимодействие мастер-узел и узел-узел внутри группы безопасности."
    predefined_target = "self_security_group"
    from_port         = 0
    to_port           = 65535
  }
  ingress {
    protocol          = "ANY"
    description       = "Правило разрешает взаимодействие под-под и сервис-сервис. Укажите подсети вашего кластера Managed Service for Kubernetes и сервисов."
    v4_cidr_blocks    = concat(yandex_vpc_subnet.mysubnet.v4_cidr_blocks)
    from_port         = 0
    to_port           = 65535
  }
  ingress {
    protocol          = "ICMP"
    description       = "Правило разрешает отладочные ICMP-пакеты из внутренних подсетей."
    v4_cidr_blocks    = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
  }
  ingress {
    protocol          = "TCP"
    description       = "Правило разрешает входящий трафик из интернета на диапазон портов NodePort. Добавьте или измените порты на нужные вам."
    v4_cidr_blocks    = ["0.0.0.0/0"]
    from_port         = 30000
    to_port           = 32767
  }
#  ingress {
#    protocol       = "TCP"
#    description    = "Правило разрешает подключение к узлам по SSH с указанных IP-адресов."
#    v4_cidr_blocks = ["10.112.0.0/16"]
#    port           = 22
#  }
#  ingress {
#    protocol       = "TCP"
#    description    = "Правило разрешает подключение к API Kubernetes через порт 6443 из указанной сети."
#    v4_cidr_blocks = ["203.0.113.0/24"]
#    port           = 6443
#  }
#  ingress {
#    protocol       = "TCP"
#    description    = "Правило разрешает подключение к API Kubernetes через порт 443 из указанной сети."
#    v4_cidr_blocks = ["203.0.113.0/24"]
#    port           = 443
#  }
  egress {
    protocol          = "ANY"
    description       = "Правило разрешает весь исходящий трафик. Узлы могут связаться с Yandex Container Registry, Yandex Object Storage, Docker Hub и т. д."
    v4_cidr_blocks    = ["0.0.0.0/0"]
    from_port         = 0
    to_port           = 65535
  }
}

# Output values

output "instance_group_masters_public_ips" {
  description = "Public IP addresses for master-nodes"
  value = yandex_vpc_address.addr.external_ipv4_address[0].address
}

#output "instance_group_masters_public_ips" {
#  description = "Public IP addresses for master-nodes"
#  value = yandex_compute_instance_group.k8s-masters.instances.*.network_interface.0.nat_ip_address
#}

#output "instance_group_masters_private_ips" {
#  description = "Private IP addresses for master-nodes"
#  value = yandex_compute_instance_group.k8s-masters.instances.*.network_interface.0.ip_address
#}

#output "instance_group_workers_public_ips" {
#  description = "Public IP addresses for worder-nodes"
#  value = yandex_compute_instance_group.k8s-workers.instances.*.network_interface.0.nat_ip_address
#}

#output "instance_group_workers_private_ips" {
#  description = "Private IP addresses for worker-nodes"
#  value = yandex_compute_instance_group.k8s-workers.instances.*.network_interface.0.ip_address
#}

#output "instance_group_ingresses_public_ips" {
#  description = "Public IP addresses for ingress-nodes"
#  value = yandex_compute_instance_group.k8s-ingresses.instances.*.network_interface.0.nat_ip_address
#}

#output "instance_group_ingresses_private_ips" {
#  description = "Private IP addresses for ingress-nodes"
#  value = yandex_compute_instance_group.k8s-ingresses.instances.*.network_interface.0.ip_address
#}

#output "load_balancer_public_ip" {
#  description = "Public IP address of load balancer"
#  value = yandex_lb_network_load_balancer.k8s-load-balancer.listener.*.external_address_spec[0].*.address
#}

#output "static-key-access-key" {
#  description = "Access key for admin user"
#  value = yandex_iam_service_account_static_access_key.static-access-key.access_key
#}

#output "static-key-secret-key" {
#  description = "Secret key for admin user"
#  value = yandex_iam_service_account_static_access_key.static-access-key.secret_key
#  sensitive = true
#}
