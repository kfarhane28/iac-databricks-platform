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

variable "databricks_workspace_host" {
  type        = string
  description = "l'url du workspace de compute' "
}