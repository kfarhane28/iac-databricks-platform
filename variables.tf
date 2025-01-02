variable "TENANT_ID" {
  type        = string
  description = "The Tenant Azure ID"
}

variable "SUBSCRIPTION_ID_MAIN" {
  type        = string
  description = "The Subscription ID for main deployment "
}

variable "SUBSCRIPTION_ID_HUB" {
  type        = string
  description = "The Subscription ID for Hub deployment (transit components) "
}

#we use Gitlab Environment variables for azure and databricks providers authentication
/*
variable "CLIENT_ID" {
  type        = string
  description = "The Client ID for Azure GITLAB SP"
}

variable "CLIENT_SECRET" {
  type        = string
  sensitive   = true
  description = "The Secret ID for Azure GITLAB SP"
}
*/

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

variable "project_name" {
  type        = string
  description = "The project name for appli1 socle."
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
  description = "The location code for the azure region (frc, weu, etc) "
}

variable "azurerm_storage_account_sacc_account_tier" {
  type        = string
  description = "Storage account tier"
}

variable "azurerm_storage_account_datalake_account_tier" {
  type        = string
  description = "DLK Storage account tier"
}

variable "azurerm_storage_account_sacc_account_replication_type" {
  type        = string
  description = "Storage account replication type"
}

variable "azurerm_storage_account_datalake_account_replication_type" {
  type        = string
  description = "DLK Storage account replication type"
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
  description = "Liste des noms des containers à créer dans le transit SA"
  type        = list(string)
  default     = ["transit"]
}

variable "azurerm_key_vault_ip_rules" {
  type        = list(string)
  description = "authorized IPs "
}

variable "azurerm_databricks_workspace_sku_name" {
  type        = string
  description = "The sku name for the resource "
}

variable "azurerm_key_vault_keyvault_sku_name" {
  type        = string
  description = "The sku name for the resource "
}

variable "azurerm_log_analytics_workspace_sku_name" {
  type        = string
  description = "The sku name Log Analytics Workspace "
}

variable "azurerm_log_analytics_workspace_retention_days" {
  type        = string
  description = "The retention in days for Log Analytics Workspace "
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