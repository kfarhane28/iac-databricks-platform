# Configure the Microsoft Azure Provider
provider "azurerm" {
  subscription_id = var.SUBSCRIPTION_ID_MAIN
  #client_id       = var.CLIENT_ID
  #tenant_id       = var.TENANT_ID
  features {}
  skip_provider_registration = "true"
}

provider "azurerm" {
  alias = "hub"
  features {}

  subscription_id = var.SUBSCRIPTION_ID_HUB
  #client_id       = var.CLIENT_ID
  #tenant_id       = var.TENANT_ID
  skip_provider_registration = "true"

}

# Configure Databricks Providers
provider "databricks" {
  azure_workspace_resource_id = module.databricks.databricks_workspace_az_id
  host                        = module.databricks.databricks_workspace_host
}

provider "databricks" {
  alias      = "accounts"
  host       = "https://accounts.azuredatabricks.net"
  account_id = "xxxxxxxxx"
}