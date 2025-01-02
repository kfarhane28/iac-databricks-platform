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

variable "databricks_workspace_dbc_id" {
  type        = string
  description = "ID databricks du workspace de compute sous forme de 4232916714614651 pour le workspace https://adb-4232916714614651.11.azuredatabricks.net/"
}

variable "databricks_workspace_host" {
  type        = string
  description = "l'url du workspace de compute' "
}

variable "dbc_access_connector_name" {
  type        = string
  description = "the name of DBC"
}

variable "dbc_access_connector_id" {
  type        = string
  description = "the ID of DBC"
}

variable "managed_identity_id" {
  type        = string
  description = "the ID of MI"
}

variable "sacc_name" {
  type        = list(string)
  description = "the list account name of SA used for datalake"
}

variable "sacc_dlk" {
  description = "Liste storage account lakehouse à créer (1 par direction)"
  type        = list(string)
  default     = ["dir1", "dir2"]
}

variable "transit_sacc_name" {
  type        = list(string)
  description = "the list account name of Transit SA"
}

variable "data_container_names" {
  description = "Liste des noms des containers à créer"
  type        = list(string)
  default     = ["stg", "raw", "bronze", "silver", "gold"]
}

variable "transit_container_names" {
  description = "Liste des noms des containers transit à créer"
  type        = list(string)
  default     = ["transit"]
}

