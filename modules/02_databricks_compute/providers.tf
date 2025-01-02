terraform {
  required_providers {
    azurerm = {
      source                = "hashicorp/azurerm"
      configuration_aliases = [azurerm.hub]
    }
    databricks = {
      source = "databricks/databricks"
    }
  }
}
