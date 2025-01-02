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

variable "azurerm_storage_account_sacc_account_tier" {
  type        = string
  description = "Storage account tier"
}

variable "azurerm_storage_account_datalake_account_tier" {
  type        = string
  description = "Datalake Storage account tier"
}

variable "azurerm_storage_account_sacc_account_replication_type" {
  type        = string
  description = "Storage account replication type"
}

variable "azurerm_storage_account_datalake_account_replication_type" {
  type        = string
  description = "Storage account replication type"
}

variable "subnet_data_id" {
  type        = string
  description = "subnet data id"
}

variable "subnet_transit_id" {
  type        = string
  description = "subnet data id"
}


variable "sacc_dlk" {
  description = "Liste storage account lakehouse à créer (1 par direction)"
  type        = list(string)
  default     = ["dir1", "dir2"]
}

variable "data_container_names" {
  description = "Liste des noms des containers à créer"
  type        = list(string)
  default     = ["stg", "raw", "bronze", "silver", "gold", "managed"]
}

variable "transit_container_names" {
  description = "Liste des noms des containers de transit à créer"
  type        = list(string)
  default     = ["transit"]
}