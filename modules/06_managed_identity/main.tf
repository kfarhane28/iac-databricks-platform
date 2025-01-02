####################################################################
#                              managed user assigned identity
####################################################################

resource "azurerm_user_assigned_identity" "user_assigned_identity" {
  name                = "mi-${var.location_code}-${var.zone}-${var.code_appli}-dbc"
  resource_group_name = "rg-${var.location_code}-${var.zone}-${var.code_appli}-backend-adb"
  location            = var.location
  tags                = var.tags

  lifecycle {
    prevent_destroy = true
  }

}

# for role assigned, we don't have the right to add it, ask azure team to add "Storage Blob Data Contributor" on RG scope "rg-${var.location_code}-${var.zone}-${var.code_appli}-backend-adb"

