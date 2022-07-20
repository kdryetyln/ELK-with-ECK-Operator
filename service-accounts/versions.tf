terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.8.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "= 2.11.0"
    }
  }
}