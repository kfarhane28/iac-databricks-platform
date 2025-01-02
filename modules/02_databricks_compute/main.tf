#####################################################################
#                             databricks
#################################################################### 

resource "azurerm_databricks_workspace" "ws_adb" {
  name                                  = "db-${var.location_code}-${var.zone}-${var.code_appli}-wkp1"
  resource_group_name                   = "rg-${var.location_code}-${var.zone}-${var.code_appli}-backend-adb"
  location                              = var.location
  sku                                   = var.azurerm_databricks_workspace_sku_name
  public_network_access_enabled         = false
  network_security_group_rules_required = "NoAzureDatabricksRules"
  custom_parameters {
    no_public_ip                                        = true
    private_subnet_name                                 = "sub-${var.location_code}-${var.zone}-${var.code_appli}-adb-priv"
    public_subnet_name                                  = "sub-${var.location_code}-${var.zone}-${var.code_appli}-adb-pub"
    virtual_network_id                                  = var.azurerm_databricks_network_id
    public_subnet_network_security_group_association_id = var.azurerm_databricks_nsg_pub_id
    # azurerm_subnet_network_security_group_association.sub_priv.id
    private_subnet_network_security_group_association_id = var.azurerm_databricks_nsg_priv_id
    # azurerm_subnet_network_security_group_association.sub_pub.id
  }
  # public_network_access_enabled = false
  managed_resource_group_name = "rg-${var.location_code}-${var.zone}-${var.code_appli}-wkp1-mng"
  tags                        = var.tags

  lifecycle {
    prevent_destroy = true
  }

}

#####################################################################
#                             enable diagnostic settings
#################################################################### 

resource "azurerm_monitor_diagnostic_setting" "databricks_compute_diags" {
  name                       = "diagnostic-settings-databricks-dv-appli1"
  target_resource_id         = azurerm_databricks_workspace.ws_adb.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category_group = "allLogs"
  }
}

#####################################################################
#                             databricks Backend and Frontend PEs
#################################################################### 

# Backend PE
# For this PE, we should specify the backend private Zone DNS to use

resource "azurerm_private_endpoint" "backend_pe" {
  name                = "pe-${var.location_code}-${var.zone}-${var.code_appli}-backend"
  resource_group_name = "rg-${var.location_code}-${var.zone}-${var.code_appli}-backend-adb"
  subnet_id           = var.subnet_data_id
  location            = var.location

  private_service_connection {
    name                           = "pe-${var.location_code}-${var.zone}-${var.code_appli}-backend-connection"
    private_connection_resource_id = azurerm_databricks_workspace.ws_adb.id
    is_manual_connection           = false
    subresource_names              = ["databricks_ui_api"]
  }

  private_dns_zone_group {
    name                 = "private-dns-zone-uiapi"
    private_dns_zone_ids = [var.dns_dbc_backend_id]
  }

  lifecycle {
    ignore_changes = [
      # ignore changes to private dns zone groupe, because an Azure Policy add it automatically to the PE and we don't manage it in TF
      private_dns_zone_group
    ]
  }

}



# Frontend PE

resource "azurerm_private_endpoint" "frontend_pe" {
  provider            = azurerm.hub
  name                = "pe-${var.location_code}-${var.zone}-${var.code_appli}-frontend"
  resource_group_name = "rg-${var.location_code}-sha-${var.code_appli}-transit"
  subnet_id           = var.subnet_transit_id
  location            = var.location

  private_service_connection {
    name                           = "pe-${var.location_code}-${var.zone}-${var.code_appli}-frontend-connection"
    private_connection_resource_id = azurerm_databricks_workspace.ws_adb.id
    is_manual_connection           = false
    subresource_names              = ["databricks_ui_api"]
  }

# for frontend PE, there is an azure policy that add PE to the Private Zone DNS attached to the HUB Vnet, so no need to add the following block
  /*
  private_dns_zone_group {
    name                 = "private-dns-zone-uiapi"
    private_dns_zone_ids = [var.dns_dbc_frontend_id]
  }
  */

  lifecycle {
    ignore_changes = [
      # ignore changes to private dns zone groupe, because an Azure Policy add it automatically to the PE and we don't manage it in TF
      private_dns_zone_group
    ]
  }

}