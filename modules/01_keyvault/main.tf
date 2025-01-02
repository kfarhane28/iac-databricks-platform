
####################################################################
#                      vault
####################################################################
data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "keyvault" {
  name                          = "kv-${var.location_code}-${var.zone}-${var.code_appli}"
  location                      = var.location
  resource_group_name           = "rg-${var.location_code}-${var.zone}-${var.code_appli}-backend-adb"
  enabled_for_disk_encryption   = false
  purge_protection_enabled      = false
  sku_name                      = var.azurerm_key_vault_keyvault_sku_name
  enable_rbac_authorization     = true
  soft_delete_retention_days    = 14
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  public_network_access_enabled = true
  network_acls {

    bypass = "None"
    #  default_action = "Allow"
    default_action = "Deny"
    ip_rules       = var.azurerm_key_vault_ip_rules

  }
  tags = var.tags
}
####################################################################
#                      endpoints
####################################################################



resource "azurerm_private_endpoint" "endpoint-vault" {
  name                          = "pe-${var.location_code}-${var.zone}-${var.code_appli}-kv"
  location                      = var.location
  resource_group_name           = "rg-${var.location_code}-${var.zone}-${var.code_appli}-backend-adb"
  subnet_id                     = var.subnet_data_id
  custom_network_interface_name = "pe-${var.location_code}-${var.zone}-${var.code_appli}-kv-nic"
  private_service_connection {
    name                           = "pe-${var.location_code}-${var.zone}-${var.code_appli}-kv-connection"
    private_connection_resource_id = azurerm_key_vault.keyvault.id
    is_manual_connection           = false
    subresource_names              = ["vault"]
  }
  tags = var.tags

  lifecycle {
    ignore_changes = [
      # ignore changes to private dns zone groupe, because an Azure Policy add it automatically to the PE and we don't manage it in TF
      private_dns_zone_group
    ]
  }
}