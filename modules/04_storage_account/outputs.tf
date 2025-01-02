/*
output "storage_af_name" {
  value = azurerm_storage_account.sacc.name
}

output "storage_af_id" {
  value = azurerm_storage_account.sacc.id
}

output "storage_af_primary_access_key" {
  value = azurerm_storage_account.sacc.primary_access_key
}
*/

output "storage_af_name" {
  value = [for key, sa in azurerm_storage_account.dlk_sacc : sa.name]
}

output "storage_af_id" {
  value = [for key, sa in azurerm_storage_account.dlk_sacc : sa.id]
}

output "storage_af_primary_access_key" {
  value = [for key, sa in azurerm_storage_account.dlk_sacc : sa.primary_access_key]
}

/*
output "storage_af_name" {
  value = azurerm_storage_account.sacc.name
}

output "storage_af_id" {
  value = azurerm_storage_account.sacc.id
}

output "storage_af_primary_access_key" {
  value = azurerm_storage_account.sacc.primary_access_key
}

output "storage_transit_name" {
  value = azurerm_storage_account.sacc_transit.name
}
*/

output "storage_transit_name" {
  value = [for key, sa in azurerm_storage_account.sacc_transit : sa.name]
}
