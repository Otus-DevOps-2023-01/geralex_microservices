#Network

resource "yandex_vpc_network" "otusnet" {
  name = "otusnet"
}

resource "yandex_vpc_subnet" "k8s-subnet" {
  v4_cidr_blocks = ["10.1.0.0/16"]
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.otusnet.id
}
