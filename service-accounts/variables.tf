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

variable "subscription_id" {
  type        = string
  default     = <your-az-subs-id>
}
 
variable "tenant_id" {
  type        = string
  default     = <your-az-subs-taint-id>