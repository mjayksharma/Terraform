provider "azurerm" {
  subscription_id   = "${var.subscription_id}"
  client_id         = "${var.client_id}"
  client_secret     = "${var.client_secret}"
  tenant_id         = "${var.tenant_id}"
}

variable "subscription_id" {
  description = "Enter Subscription ID for provisioning resources in Azure"  
}

variable "client_id" {
  description = "Enter client ID for provisioning resources in Azure"  
}

variable "client_secret" {
  description = "Enter client secret for provisioning resources in Azure"
}

variable "tenant_id" {
  description = "Enter tenant ID for provisioning resources in Azure"
}

variable "prefix" {
  description = "Enter Prefix"
}
