####################################################################
#                              Log Analytics Workspace
####################################################################

resource "azurerm_log_analytics_workspace" "az_law" {
  name                = "law-${var.location_code}-${var.zone}-${var.code_appli}-socle"
  resource_group_name = "rg-${var.location_code}-${var.zone}-${var.code_appli}-backend-adb"
  location            = var.location
  sku                 = var.azurerm_log_analytics_workspace_sku_name
  retention_in_days   = var.azurerm_log_analytics_workspace_retention_days
  tags                = var.tags
}