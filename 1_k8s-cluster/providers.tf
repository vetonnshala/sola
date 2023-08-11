terraform {
  required_version = ">= 1.0"
  required_providers {
    # Azure Active Directory
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 1.0"
    }
    # Azure Resource Manager
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.0"
    }
  }
}

provider "azurerm" {
  features {}
}
provider "kubernetes" {
  config_path = "~/.kube/config"
}