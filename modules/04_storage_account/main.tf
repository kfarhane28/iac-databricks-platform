####################################################################
#                      sacc
####################################################################

resource "azurerm_storage_account" "dlk_sacc" {
  for_each            = toset(var.sacc_dlk)
  name                = "safrc${var.zone}${var.code_appli}${each.value}"
  resource_group_name = "rg-frc-${var.zone}-${var.code_appli}-backend-adb"
  location            = var.location

  account_replication_type         = var.azurerm_storage_account_datalake_account_replication_type
  enable_https_traffic_only        = true
  cross_tenant_replication_enabled = false
  allow_nested_items_to_be_public  = false
  # we should not enable soft delete for datalake sacc, this in not supported for databricks external location

  blob_properties {
    delete_retention_policy {
      days = 7
    }
    container_delete_retention_policy {
      days = 7
    }

  }

  share_properties {
    # cors_rule {}
    retention_policy {
      days = 7
    }
  }
  # caracteristique 
  is_hns_enabled                = true
  account_tier                  = var.azurerm_storage_account_datalake_account_tier
  public_network_access_enabled = false
  network_rules {
    default_action = "Deny"
    # Logging, Metrics, AzureServices, or None.
    bypass = ["AzureServices"]
  }
  tags = var.tags

  lifecycle {
    prevent_destroy = true
  }
}

moved {
  from = azurerm_storage_account.sacc
  to   = azurerm_storage_account.dlk_sacc["bdt"]
}

####################################################################
#                      sacc transit
####################################################################

resource "azurerm_storage_account" "sacc_transit" {
  for_each            = toset(var.sacc_dlk)
  name                = "safrc${var.zone}${var.code_appli}${each.value}trans"
  resource_group_name = "rg-frc-${var.zone}-${var.code_appli}-backend-adb"
  location            = var.location

  account_replication_type         = var.azurerm_storage_account_sacc_account_replication_type
  enable_https_traffic_only        = true
  cross_tenant_replication_enabled = false
  allow_nested_items_to_be_public  = false

  blob_properties {
    delete_retention_policy {
      days = 14
    }
    container_delete_retention_policy {
      days = 14
    }

  }
  share_properties {
    # cors_rule {}
    retention_policy {
      days = 1
    }
  }
  # caracteristique 
  is_hns_enabled                = true
  account_tier                  = var.azurerm_storage_account_datalake_account_tier
  public_network_access_enabled = false
  network_rules {
    default_action = "Deny"
    # Logging, Metrics, AzureServices, or None.
    bypass = ["AzureServices"]
  }
  tags = var.tags

  lifecycle {
    prevent_destroy = true
    ignore_changes  = all
  }

}


####################################################################
#                           sacc endpoints
####################################################################

resource "azurerm_private_endpoint" "endpoint-blob" {
  for_each                      = toset(var.sacc_dlk)
  name                          = "pe-${var.location_code}-${var.zone}-${var.code_appli}-${each.value}-storage-blob-1"
  location                      = var.location
  resource_group_name           = "rg-${var.location_code}-${var.zone}-${var.code_appli}-backend-adb"
  subnet_id                     = var.subnet_data_id
  custom_network_interface_name = "pe-${var.location_code}-${var.zone}-${var.code_appli}-${each.value}-storage-blob-nic"

  private_service_connection {
    name                           = "pe-${var.location_code}-${var.zone}-${var.code_appli}-${each.value}-storage-blob-connection"
    private_connection_resource_id = azurerm_storage_account.dlk_sacc[each.key].id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }
  tags = var.tags

  lifecycle {

    ignore_changes = [
      # ignore changes to private dns zone groupe, because an Azure Policy add it automatically to the PE and we don't manage it in TF
      private_dns_zone_group
    ]

  }

}

moved {
  from = azurerm_private_endpoint.endpoint-blob
  to   = azurerm_private_endpoint.endpoint-blob["bdt"]
}

#------------------------- endpoint dfs-sacc ---------------------------

resource "azurerm_private_endpoint" "endpoint-dfs" {
  for_each                      = toset(var.sacc_dlk)
  name                          = "pe-${var.location_code}-${var.zone}-${var.code_appli}-${each.value}-storage-dfs-1"
  location                      = var.location
  resource_group_name           = "rg-${var.location_code}-${var.zone}-${var.code_appli}-backend-adb"
  subnet_id                     = var.subnet_data_id
  custom_network_interface_name = "pe-${var.location_code}-${var.zone}-${var.code_appli}-${each.value}-storage-dfs-nic"

  private_service_connection {
    name                           = "pe-${var.location_code}-${var.zone}-${var.code_appli}-${each.value}-storage-dfs-connection"
    private_connection_resource_id = azurerm_storage_account.dlk_sacc[each.key].id
    is_manual_connection           = false
    subresource_names              = ["dfs"]
  }
  tags = var.tags

  lifecycle {
    ignore_changes = [
      # ignore changes to private dns zone groupe, because an Azure Policy add it automatically to the PE and we don't manage it in TF
      private_dns_zone_group
    ]
  }
}

moved {
  from = azurerm_private_endpoint.endpoint-dfs
  to   = azurerm_private_endpoint.endpoint-dfs["bdt"]
}
####################################################################
#                           sacc transit endpoints
####################################################################
#------------------------- endpoint blob-sacc-transit ---------------------------

resource "azurerm_private_endpoint" "transit-endpoint-blob" {
  for_each = toset(var.sacc_dlk)
  provider = azurerm.hub
  name     = "pe-${var.location_code}-${var.zone}-${var.code_appli}-${each.value}-transit-blob-1"
  location = var.location
  /*
  resource_group_name = "rg-${var.location_code}-${var.zone}-${var.code_appli}-backend-adb"
  subnet_id           = var.subnet_data_id
  */
  resource_group_name = "rg-${var.location_code}-sha-${var.code_appli}-transit"
  subnet_id           = var.subnet_transit_id


  custom_network_interface_name = "pe-${var.location_code}-${var.zone}-${var.code_appli}-${each.value}-transit-blob-nic"

  private_service_connection {
    name                           = "pe-${var.location_code}-${var.zone}-${var.code_appli}-${each.value}-transit-blob-connection"
    private_connection_resource_id = azurerm_storage_account.sacc_transit[each.key].id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }
  tags = var.tags

  lifecycle {
    ignore_changes = [
      # ignore changes to private dns zone groupe, because an Azure Policy add it automatically to the PE and we don't manage it in TF
      private_dns_zone_group
    ]
  }
}

#------------------------- endpoint dfs-sacc ---------------------------

resource "azurerm_private_endpoint" "transit-endpoint-dfs" {
  for_each = toset(var.sacc_dlk)
  provider = azurerm.hub
  name     = "pe-${var.location_code}-${var.zone}-${var.code_appli}-${each.value}-transit-dfs-1"
  location = var.location
  /*
  resource_group_name = "rg-${var.location_code}-${var.zone}-${var.code_appli}-backend-adb"
  subnet_id           = var.subnet_data_id
  */
  resource_group_name = "rg-${var.location_code}-sha-${var.code_appli}-transit"
  subnet_id           = var.subnet_transit_id


  custom_network_interface_name = "pe-${var.location_code}-${var.zone}-${var.code_appli}-${each.value}-transit-dfs-nic"

  private_service_connection {
    name                           = "pe-${var.location_code}-${var.zone}-${var.code_appli}-${each.value}-transit-dfs-connection"
    private_connection_resource_id = azurerm_storage_account.sacc_transit[each.key].id
    is_manual_connection           = false
    subresource_names              = ["dfs"]
  }
  tags = var.tags

  lifecycle {
    ignore_changes = [
      # ignore changes to private dns zone groupe, because an Azure Policy add it automatically to the PE and we don't manage it in TF
      private_dns_zone_group
    ]
  }
}



####################################################################
#                      sacc containers
####################################################################
#add a sleep time to allow azure policy for private DNS to apply
resource "time_sleep" "wait_15_seconds" {
  create_duration = "15s"
  depends_on      = [azurerm_private_endpoint.transit-endpoint-blob, azurerm_private_endpoint.endpoint-blob]
}

locals {
  storage_account_names = [for suffix in var.sacc_dlk : "saapplifrc${var.zone}${var.code_appli}${suffix}"]
  flat_list             = setproduct(local.storage_account_names, var.data_container_names)
}

resource "azurerm_storage_container" "containers" {
  for_each = { for idx, val in local.flat_list : idx => val }

  name                  = each.value[1]
  container_access_type = "private"
  storage_account_name  = each.value[0]

  depends_on = [azurerm_storage_account.dlk_sacc]
}

locals {
  transit_storage_account_names = [for suffix in var.sacc_dlk : "saapplifrc${var.zone}${var.code_appli}${suffix}trans"]
  transit_flat_list             = setproduct(local.transit_storage_account_names, var.transit_container_names)
}

resource "azurerm_storage_container" "transit_containers" {
  for_each = { for idx, val in local.transit_flat_list : idx => val }

  name                  = each.value[1]
  container_access_type = "private"
  storage_account_name  = each.value[0]

  depends_on = [azurerm_storage_account.sacc_transit]
}