variable "aks_rg_name" {
  type        = string
  description = "The name of the cluster's resource group."
  default     = "local-demo"
}
variable "aks_cluster_name" {
  type        = string
  description = "The name of the cluster."
  default     = "local-demo"
}


variable "elkcloud_namespace" {
  type        = string
  description = "The activemq namespace (it will be created if needed)."
  default     = "logging"
}

variable "subscription_id" {
  type        = string
  default     = <your-az-subs-id>
}
 
variable "tenant_id" {
  type        = string
  default     = <your-az-subs-taint-id>

variable "adminsa_name" {
  type        = string
  default     = "admin-sa"
}