output "compute_vnet_env_name" {
  value = data.azurerm_virtual_network.compute_vnet.name
}

output "compute_vnet_env_id" {
  value = data.azurerm_virtual_network.compute_vnet.id
}

output "transit_vnet_env_name" {
  value = data.azurerm_virtual_network.transit_vnet.name
}

output "transit_vnet_env_id" {
  value = data.azurerm_virtual_network.transit_vnet.id
}

output "nsg_adb_pub_id" {
  value = data.azurerm_network_security_group.nsg_adb_pub.id
}

output "nsg_adb_priv_id" {
  value = data.azurerm_network_security_group.nsg_adb_priv.id
}

output "nsg_adb_webauth_pub_id" {
  value = data.azurerm_network_security_group.nsg_adb_webauth_pub.id
}

output "nsg_adb_webauth_priv_id" {
  value = data.azurerm_network_security_group.nsg_adb_webauth_priv.id
}

output "subnet_data_id" {
  value = data.azurerm_subnet.subnet_data_id.id
}

output "subnet_transit_id" {
  value = data.azurerm_subnet.subnet_transit_id.id
}

/*
output "dns_dbc_frontend_id" {
  value = data.azurerm_private_dns_zone.dns_dbc_frontend.id
}
*/

output "dns_dbc_backend_id" {
  value = data.azurerm_private_dns_zone.dns_dbc_backend.id
}



