variable "zone" {
  type        = string
  description = "The zone code for the resource "
}

variable "env" {
  type        = string
  description = "The environment code for the resource (e.g., 'dev', 'test', or 'prod')."
}

variable "code_appli" {
  type        = string
  description = "Le code applicatif du projet (e.g., 'appli1', 'appli2', etc)."
}


variable "tags" {
  type        = map(any)
  description = "tags list"
}

variable "location" {
  type        = string
  description = "The location name for the resource "
}

variable "location_code" {
  type        = string
  description = "le code la region azure (frc, weu, etc) "
}

variable "azurerm_databricks_workspace_sku_name" {
  type        = string
  description = "The sku name name for the resource "
}

variable "azurerm_databricks_network_id" {
  type        = string
  description = "vnet id for databricks "
}

variable "azurerm_databricks_nsg_pub_id" {
  type        = string
  description = "nsg public id for databricks "
}

variable "azurerm_databricks_nsg_priv_id" {
  type        = string
  description = "nsg private id for databricks "
}
