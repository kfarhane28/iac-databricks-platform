variable "zone" {
  type        = string
  description = "The zone code for the resource "
}

variable "env" {
  type        = string
  description = "The environment code for the resource (e.g., 'dev', 'test', or 'prod')."
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

variable "code_appli" {
  type        = string
  description = "Le code applicatif du projet (e.g., 'appli1', 'appli2', etc)."
}

variable "azurerm_key_vault_ip_rules" {
  type        = list(string)
  description = "authorized IPs "
}

variable "azurerm_key_vault_keyvault_sku_name" {
  type        = string
  description = "The sku name name for the resource "
}

variable "subnet_data_id" {
  type        = string
  description = "subnet data id"
}


