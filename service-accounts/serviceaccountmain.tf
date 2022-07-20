provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  tenant_id = var.tenant_id
}

 data "azurerm_kubernetes_cluster" "akscluster" {
   name                = var.aks_cluster_name
   resource_group_name = var.aks_rg_name
 }

 provider "kubernetes" {
   host                   = data.azurerm_kubernetes_cluster.akscluster.kube_config.0.host
   client_certificate     = base64decode(data.azurerm_kubernetes_cluster.akscluster.kube_admin_config.0.client_certificate)
   client_key             = base64decode(data.azurerm_kubernetes_cluster.akscluster.kube_admin_config.0.client_key)
   cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.akscluster.kube_admin_config.0.cluster_ca_certificate)
 }


# Create a Service Account
resource "kubernetes_service_account" "adminsa" {
  automount_service_account_token = true
  metadata {
    name = "admin-sa"
  }
}

# Add the Secret, that holds the Service Account Token as a data source
data "kubernetes_secret" "adminsasecret" {
  metadata {
    name = "${kubernetes_service_account.adminsa.default_secret_name}"
  }
}


resource "kubernetes_cluster_role_binding" "adminrolebinding" {
  metadata {
    name = "sa-admin-binding"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.adminsa.metadata[0].name
  }
}

output "adminsasecret" {

   description = "admin sa secret"
   value = data.kubernetes_secret.adminsasecret.data
   sensitive = true
}
