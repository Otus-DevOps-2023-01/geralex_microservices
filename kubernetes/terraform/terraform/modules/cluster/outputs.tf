# Output values

output "instance_group_masters_public_ips" {
  description = "Public IP addresses for master"
  value       = yandex_kubernetes_cluster.k8s-zonal.master[0].external_v4_endpoint
}