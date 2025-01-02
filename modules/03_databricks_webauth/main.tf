#####################################################################
#                             databricks
#################################################################### 
locals {
  is_env_dev            = var.env == "dev"
  should_create_webauth = local.is_env_dev ? true : false
}

data "azurerm_databricks_workspace" "existing" {
  provider            = azurerm.hub
  name                = "db-${var.location_code}-sha-${var.code_appli}-wkpAuth"
  resource_group_name = "rg-${var.location_code}-sha-${var.code_appli}-transit"
}

resource "azurerm_databricks_workspace" "ws_adb_webauth" {
  count                                 = local.should_create_webauth ? 1 : 0
  provider                              = azurerm.hub
  name                                  = "db-${var.location_code}-sha-${var.code_appli}-wkpAuth"
  resource_group_name                   = "rg-${var.location_code}-sha-${var.code_appli}-transit"
  location                              = var.location
  sku                                   = var.azurerm_databricks_workspace_sku_name
  network_security_group_rules_required = "NoAzureDatabricksRules"
  public_network_access_enabled         = false
  custom_parameters {
    no_public_ip                                        = true
    private_subnet_name                                 = "sub-${var.location_code}-sha-${var.code_appli}-transit-adb-priv"
    public_subnet_name                                  = "sub-${var.location_code}-sha-${var.code_appli}-transit-adb-pub"
    virtual_network_id                                  = var.azurerm_databricks_network_id
    public_subnet_network_security_group_association_id = var.azurerm_databricks_nsg_pub_id
    # azurerm_subnet_network_security_group_association.sub_priv.id
    private_subnet_network_security_group_association_id = var.azurerm_databricks_nsg_priv_id
    # azurerm_subnet_network_security_group_association.sub_pub.id
  }
  # public_network_access_enabled = false
  managed_resource_group_name = "rg-${var.location_code}-sha-${var.code_appli}-wkpAuth-mng"
  tags                        = var.tags

  lifecycle {
    #prevent_destroy = true
  }

}

moved {
  from = azurerm_databricks_workspace.ws_adb_webauth
  to   = azurerm_databricks_workspace.ws_adb_webauth[0]
}

#####################################################################
#                             Web auth PE
#################################################################### 
# comment this block, until a replacement of webauth existing workspace will be done
/*
resource "azurerm_private_endpoint" "transit_auth" {
  name                = "pe-${var.location_code}-sha-${var.code_appli}-webauth"
  resource_group_name = "rg-${var.location_code}-sha-${var.code_appli}-transit"
  subnet_id           = var.subnet_transit_id
  location            = var.location

  private_service_connection {
    name                           = "pe-${var.location_code}-sha-${var.code_appli}-auth-connection"
    private_connection_resource_id = azurerm_databricks_workspace.ws_adb_webauth.id
    is_manual_connection           = false
    subresource_names              = ["browser_authentication"]
  }

}
*/

