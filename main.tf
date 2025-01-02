module "vnet" {
  source        = "./modules/00_vnet"
  zone          = var.zone
  env           = var.env
  code_appli    = var.code_appli
  location_code = var.location_code
  providers = {
    azurerm.hub = azurerm.hub
  }
}

module "sa" {
  source                                                    = "./modules/04_storage_account"
  zone                                                      = var.zone
  env                                                       = var.env
  tags                                                      = var.tags
  location                                                  = var.location
  location_code                                             = var.location_code
  azurerm_storage_account_sacc_account_tier                 = var.azurerm_storage_account_sacc_account_tier
  azurerm_storage_account_datalake_account_tier             = var.azurerm_storage_account_datalake_account_tier
  azurerm_storage_account_sacc_account_replication_type     = var.azurerm_storage_account_sacc_account_replication_type
  azurerm_storage_account_datalake_account_replication_type = var.azurerm_storage_account_datalake_account_replication_type
  subnet_data_id                                            = module.vnet.subnet_data_id
  subnet_transit_id                                         = module.vnet.subnet_transit_id
  code_appli                                                = var.code_appli
  main_sa_name                                              = var.main_sa_name
  sacc_dlk                                                  = var.sacc_dlk
  data_container_names                                      = var.data_container_names
  transit_container_names                                   = var.transit_container_names
  providers = {
    azurerm.hub = azurerm.hub
  }
}

module "keyvault" {
  source                              = "./modules/01_keyvault"
  zone                                = var.zone
  env                                 = var.env
  tags                                = var.tags
  location                            = var.location
  location_code                       = var.location_code
  code_appli                          = var.code_appli
  azurerm_key_vault_ip_rules          = var.azurerm_key_vault_ip_rules
  azurerm_key_vault_keyvault_sku_name = var.azurerm_key_vault_keyvault_sku_name
  subnet_data_id                      = module.vnet.subnet_data_id
}


module "databricks" {
  source                                = "./modules/02_databricks_compute"
  zone                                  = var.zone
  env                                   = var.env
  tags                                  = var.tags
  location                              = var.location
  location_code                         = var.location_code
  code_appli                            = var.code_appli
  azurerm_databricks_workspace_sku_name = var.azurerm_databricks_workspace_sku_name
  azurerm_databricks_network_id         = module.vnet.compute_vnet_env_id
  azurerm_databricks_nsg_priv_id        = module.vnet.nsg_adb_priv_id
  azurerm_databricks_nsg_pub_id         = module.vnet.nsg_adb_pub_id
  subnet_data_id                        = module.vnet.subnet_data_id
  subnet_transit_id                     = module.vnet.subnet_transit_id
  log_analytics_workspace_id            = module.log_workspace_analytics.log_analytics_workspace_id
  dns_dbc_backend_id                    = module.vnet.dns_dbc_backend_id
  depends_on = [module.keyvault, module.log_workspace_analytics]
  providers = {
    azurerm.hub = azurerm.hub
  }
}

#managed identity was created as pre-requisite by another team
/*
module "managed_identity" {
  source        = "./modules/06_managed_identity"
  zone          = var.zone
  env           = var.env
  tags          = var.tags
  location      = var.location
  location_code = var.location_code
  code_appli    = var.code_appli
  depends_on    = [module.sa]
}
*/

####################################################################
#                              managed user assigned identity
####################################################################

data "azurerm_user_assigned_identity" "user_assigned_identity" {
  name                = "mi-${var.location_code}-${var.zone}-${var.code_appli}-dbc"
  resource_group_name = "rg-${var.location_code}-${var.zone}-${var.code_appli}-backend-adb"
}


module "adb_connector" {
  source        = "./modules/05_adb_connector"
  zone          = var.zone
  env           = var.env
  tags          = var.tags
  location      = var.location
  location_code = var.location_code
  code_appli    = var.code_appli
  identity_ids  = data.azurerm_user_assigned_identity.user_assigned_identity.id
}


module "log_workspace_analytics" {
  source                                         = "./modules/07_log_analytics"
  zone                                           = var.zone
  env                                            = var.env
  tags                                           = var.tags
  location                                       = var.location
  location_code                                  = var.location_code
  code_appli                                     = var.code_appli
  azurerm_log_analytics_workspace_sku_name       = var.azurerm_log_analytics_workspace_sku_name
  azurerm_log_analytics_workspace_retention_days = var.azurerm_log_analytics_workspace_retention_days
}

module "databricks_webauth" {
  source                                = "./modules/03_databricks_webauth"
  zone                                  = var.zone
  env                                   = var.env
  tags                                  = var.tags
  location                              = var.location
  location_code                         = var.location_code
  code_appli                            = var.code_appli
  azurerm_databricks_workspace_sku_name = var.azurerm_databricks_workspace_sku_name
  azurerm_databricks_network_id         = module.vnet.transit_vnet_env_id
  azurerm_databricks_nsg_priv_id        = module.vnet.nsg_adb_webauth_priv_id
  azurerm_databricks_nsg_pub_id         = module.vnet.nsg_adb_webauth_pub_id
  /* subnet_transit_id         = module.vnet.subnet_transit_id */ # disable this line until figure out what to do with the workspace webauth already existing
  depends_on = [module.keyvault]
  providers = {
    azurerm.hub = azurerm.hub
  }
}


module "databricks_uc" {
  source                      = "./modules/08_databricks_unity_catalog"
  zone                        = var.zone
  env                         = var.env
  tags                        = var.tags
  location                    = var.location
  location_code               = var.location_code
  code_appli                  = var.code_appli
  databricks_workspace_dbc_id = module.databricks.databricks_workspace_dbc_id
  databricks_workspace_host   = module.databricks.databricks_workspace_host
  dbc_access_connector_name   = module.adb_connector.dbc_access_connector_name
  dbc_access_connector_id     = module.adb_connector.dbc_access_connector_id
  managed_identity_id         = data.azurerm_user_assigned_identity.user_assigned_identity.id
  sacc_name                   = module.sa.storage_af_name
  transit_sacc_name           = module.sa.storage_transit_name
  sacc_dlk                    = var.sacc_dlk
  depends_on                  = [module.databricks, module.databricks_webauth, module.adb_connector]
  providers = {
    databricks.accounts = databricks.accounts
  }
}

module "databricks_git_proxy" {
  source                    = "./modules/11_databricks_gitlab_proxy"
  zone                      = var.zone
  env                       = var.env
  tags                      = var.tags
  location                  = var.location
  location_code             = var.location_code
  code_appli                = var.code_appli
  databricks_workspace_host = module.databricks.databricks_workspace_host
  depends_on                = [module.databricks, module.databricks_webauth]
}


module "databricks_monitor_alerts" {
  source                      = "./modules/10_databricks_monitor_alerts"
  zone                        = var.zone
  env                         = var.env
  tags                        = var.tags
  location                    = var.location
  location_code               = var.location_code
  code_appli                  = var.code_appli
  databricks_workspace_dbc_id = module.databricks.databricks_workspace_dbc_id
  databricks_workspace_host   = module.databricks.databricks_workspace_host
  warehouse_id                = var.warehouse_id
  alert_emails                = var.alert_emails
  schedule_job_alerts         = var.schedule_job_alerts
  depends_on                  = [module.databricks, module.databricks_webauth]
}

/*
module "azure_monitor_alerts" {
  source        = "./modules/09_azure_monitor_alerts"
  zone          = var.zone
  env           = var.env
  tags          = var.tags
  location      = var.location
  location_code = var.location_code
  code_appli    = var.code_appli
  dlk_sacc_id   = module.sa.storage_af_id
}
*/