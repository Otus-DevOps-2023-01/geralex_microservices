# Variables

variable "yc_folder_id" {
  type        = string
  description = "Yandex Cloud folder id"
}

variable "k8s_version" {
  type        = string
  description = "Yandex Cloud k8s version"
}

variable "sa_name" {
  type        = string
  description = "Yandex Cloud Service Account Name"
}

variable "count_instance" {
  type        = string
  description = "Yandex Cloud Count Instance Node"
}

variable "cores" {
  type        = string
  description = "Yandex Cloud Count vCPU"
}

variable "memory" {
  type        = string
  description = "Yandex Cloud Count RAM"
}

variable "disk_size" {
  type        = string
  description = "Yandex Cloud Count Disk Size"
}

variable "disk_type" {
  type        = string
  description = "Yandex Cloud Type Disk"
}

#variable "subnet_id" {
#  description = "Subnets for modules"
#}

#variable "zone_id" {
#  description = "Zones for modules"
#}

#variable "network_id" {
#  description = "Networks for modules"
#}
