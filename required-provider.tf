terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.67.0"
    }
    databricks = {
      source = "databricks/databricks"
      #version = "1.38.0" # provider version
      version = "1.50.0" # upgrade to 1.50 to support databricks_notification_destination
    }
    gitlab = {
      source = "gitlabhq/gitlab"
    }
    vault = {
      source = "hashicorp/vault"
    }
  }
}