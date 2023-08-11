locals {
  aks_cluster_name    = "aks-${local.resource_group_name}"
  location            = "westeurope"
  resource_group_name = "sola"
  aad_domain_name     = "vettonshalaagmail.onmicrosoft.com"
}