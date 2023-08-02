# Provider

terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "0.95.0"
    }
  }
}

provider "yandex" {
  token     = var.yc_token
  cloud_id  = var.yc_cloud_id
  folder_id = var.yc_folder_id
}

#module "vpc" {
#  source    = "./modules/vpc"
#}

#module "vm" {
#  source    = "./modules/vm"
#  cores     = var.cores
#  memory    = var.memory
#  subnet_id = var.subnet_id
#}

module "cluster" {
  source         = "./modules/cluster"
  k8s_version    = var.k8s_version
  count_instance = var.count_instance
  cores          = var.cores
  memory         = var.memory
  disk_type      = var.disk_type
  disk_size      = var.disk_size
  yc_folder_id   = var.yc_folder_id
  sa_name        = var.sa_name
#  subnet_id      = var.subnet_id
#  zone_id        = var.zone_id
#  network_id     = var.network_id
}
