terraform {
  required_version = ">= 1.5.0"
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.31"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.14"
    }
  }
}

provider "kubernetes" {
  # Absolute path for native Windows execution
  config_path = "C:/Users/Andrew/.kube/config"
}

provider "helm" {
  kubernetes {
    # Absolute path for native Windows execution
    config_path = "C:/Users/Andrew/.kube/config"
  }
}