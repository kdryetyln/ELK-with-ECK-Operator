provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  tenant_id = var.tenant_id
}


data "azurerm_kubernetes_cluster" "akscluster" {
  name                = var.aks_cluster_name
  resource_group_name = var.aks_rg_name
}

###Remote State Datas
data "terraform_remote_state" "akssa" {
   backend = "local"
   config = {
    path = "${path.root}/service-accounts/terraform.tfstate"
  }
 }
 
provider "kubernetes" {
  host                   = data.azurerm_kubernetes_cluster.akscluster.kube_config.0.host
  cluster_ca_certificate = lookup(data.terraform_remote_state.akssa.outputs.adminsasecret, "ca.crt")
  token                  = lookup(data.terraform_remote_state.akssa.outputs.adminsasecret, "token")
}

provider "kubectl" {
  host                   = data.azurerm_kubernetes_cluster.akscluster.kube_config.0.host
  cluster_ca_certificate = lookup(data.terraform_remote_state.akssa.outputs.adminsasecret, "ca.crt")
  token                  = lookup(data.terraform_remote_state.akssa.outputs.adminsasecret, "token")
}

resource "kubernetes_namespace" "elkcloud_namespace" {
  metadata {
    annotations = {
      name = var.elkcloud_namespace
    }
    name = var.elkcloud_namespace
  }
}

provider "helm" {
  kubernetes {
    host                   = data.azurerm_kubernetes_cluster.akscluster.kube_config.0.host
    cluster_ca_certificate = lookup(data.terraform_remote_state.akssa.outputs.adminsasecret, "ca.crt")
    token                  = lookup(data.terraform_remote_state.akssa.outputs.adminsasecret, "token")
  }
}

resource "helm_release" "eck-operator" {
  name       = "eck-operator"
  repository = "https://helm.elastic.co"
  chart      = "eck-operator"
  namespace         = "elastic-system"
  create_namespace  = true
  force_update = true
  dependency_update = true #helm repo update command
}

data "kubectl_filename_list" "manifests_deployment_op" {
    pattern = "./deployment/*.yaml"
}

resource "kubectl_manifest" "operator_deploy" {
    count = length(data.kubectl_filename_list.manifests_deployment_op.matches)
    yaml_body = file(element(data.kubectl_filename_list.manifests_deployment_op.matches, count.index))
    override_namespace = var.elkcloud_namespace

    depends_on = [
    helm_release.eck-operator
  ]
}
