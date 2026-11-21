terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "32c1e551-2ca1-4005-800a-708959d57556"
}

resource "azurerm_resource_group" "aks" {
  name     = "rg-cloud-course-aks"
  location = "Central India"
}

resource "azurerm_kubernetes_cluster" "main" {
  name                = "mercury-cluster"
  location            = azurerm_resource_group.aks.location
  resource_group_name = azurerm_resource_group.aks.name
  dns_prefix          = "mercury"
  kubernetes_version  = "1.34.12"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2s_v6"
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin     = "azure"
    network_policy     = "cilium"
    network_data_plane = "cilium"
  }

}
