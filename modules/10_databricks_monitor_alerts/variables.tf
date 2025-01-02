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

variable "warehouse_id" {
  type        = string
  default     = ""
  description = "Optional Warehouse ID to run queries on. If not provided, new SQL Warehouse is created"
}

variable "schedule_job_alerts" {
  type        = string
  default     = "0 0 6 1/1 * ? *"
  description = "the crontab expression for scheduling job alerts"
}

variable "alert_emails" {
  type        = list(string)
  description = "List of emails to notify when alerts are fired"
}