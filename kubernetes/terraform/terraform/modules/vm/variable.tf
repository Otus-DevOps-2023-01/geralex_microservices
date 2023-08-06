# Variables

variable "cores" {
  type        = string
  description = "Yandex Cloud Count vCPU"
}

variable "memory" {
  type        = string
  description = "Yandex Cloud Count RAM"
}

variable "subnet_id" {
  description = "Subnets for modules"
}