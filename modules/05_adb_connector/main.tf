####################################################################
#                              adb_connector
####################################################################

resource "azurerm_databricks_access_connector" "adb_connector" {
  name                = "dbc-${var.location_code}-${var.zone}-${var.code_appli}"
  resource_group_name = "rg-${var.location_code}-${var.zone}-${var.code_appli}-backend-adb"
  location            = var.location

  identity {
    type         = "UserAssigned"
    identity_ids = [var.identity_ids]
  }

  tags = var.tags

  lifecycle {
    ignore_changes = all
  }
}
