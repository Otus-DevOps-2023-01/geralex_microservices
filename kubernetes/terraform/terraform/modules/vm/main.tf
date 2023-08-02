terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "0.95.0"
    }
  }
}

#Data
data "yandex_compute_image" "container-optimized-image" {
  family = "container-optimized-image"
}

#Create VM

resource "yandex_compute_instance" "instance-based-on-coi" {
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.container-optimized-image.id
    }
  }
  network_interface {
    subnet_id = var.subnet_id
    nat       = true
  }
  resources {
    cores  = var.cores
    memory = var.memory
  }
  metadata = {
    docker-container-declaration = file("${path.module}/declaration.yaml")
    user-data                    = file("${path.module}/cloud_config.yaml")
  }
}

