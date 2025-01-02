####################################################################
#                      Compute VNet
####################################################################

data "azurerm_virtual_network" "compute_vnet" {
  name                = "vnet-${var.location_code}-${var.zone}-${var.code_appli}-compute"
  resource_group_name = "rg-landing-${var.location_code}-${var.zone}-1"
}

data "azurerm_subnet" "subnet_adb_priv" {
  virtual_network_name = "vnet-${var.location_code}-${var.zone}-${var.code_appli}-compute"
  name                 = "sub-${var.location_code}-${var.zone}-${var.code_appli}-adb-priv"
  resource_group_name  = "rg-landing-${var.location_code}-${var.zone}-1"
}
data "azurerm_subnet" "subnet_adb_pub" {
  virtual_network_name = "vnet-${var.location_code}-${var.zone}-${var.code_appli}-compute"
  name                 = "sub-${var.location_code}-${var.zone}-${var.code_appli}-adb-pub"
  resource_group_name  = "rg-landing-${var.location_code}-${var.zone}-1"
}

data "azurerm_subnet" "subnet_data_id" {
  virtual_network_name = "vnet-${var.location_code}-${var.zone}-${var.code_appli}-compute"
  name                 = "sub-${var.location_code}-${var.zone}-${var.code_appli}-commun"
  resource_group_name  = "rg-landing-${var.location_code}-${var.zone}-1"
}

data "azurerm_network_security_group" "nsg_adb_priv" {
  name                = "nsg-${var.location_code}-${var.zone}-${var.code_appli}-adb-priv"
  resource_group_name = "rg-landing-${var.location_code}-${var.zone}-nsg"
}
data "azurerm_network_security_group" "nsg_adb_pub" {
  name                = "nsg-${var.location_code}-${var.zone}-${var.code_appli}-adb-pub"
  resource_group_name = "rg-landing-${var.location_code}-${var.zone}-nsg"
}
data "azurerm_network_security_group" "nsg_data" {
  name                = "nsg-${var.location_code}-${var.zone}-${var.code_appli}-commun"
  resource_group_name = "rg-landing-${var.location_code}-${var.zone}-nsg"
}

####################################################################
#                      Transit VNet
####################################################################

data "azurerm_virtual_network" "transit_vnet" {
  provider            = azurerm.hub
  name                = "vnet-${var.location_code}-sha-${var.code_appli}-transit"
  resource_group_name = "rg-landing-${var.location_code}-sha-1"
}

data "azurerm_subnet" "subnet_adb_webauth_priv" {
  provider             = azurerm.hub
  virtual_network_name = "vnet-${var.location_code}-sha-${var.code_appli}-transit"
  name                 = "sub-${var.location_code}-sha-${var.code_appli}-transit-adb-priv"
  resource_group_name  = "rg-landing-${var.location_code}-sha-1"
}
data "azurerm_subnet" "subnet_adb_webauth_pub" {
  provider             = azurerm.hub
  virtual_network_name = "vnet-${var.location_code}-sha-${var.code_appli}-transit"
  name                 = "sub-${var.location_code}-sha-${var.code_appli}-transit-adb-pub"
  resource_group_name  = "rg-landing-${var.location_code}-sha-1"
}

data "azurerm_subnet" "subnet_transit_id" {
  provider             = azurerm.hub
  virtual_network_name = "vnet-${var.location_code}-sha-${var.code_appli}-transit"
  name                 = "sub-${var.location_code}-sha-${var.code_appli}-transit-adb"
  resource_group_name  = "rg-landing-${var.location_code}-sha-1"
}

data "azurerm_network_security_group" "nsg_adb_webauth_priv" {
  provider            = azurerm.hub
  name                = "nsg-${var.location_code}-sha-${var.code_appli}-transit-adb-priv"
  resource_group_name = "rg-landing-${var.location_code}-sha-nsg"
}

data "azurerm_network_security_group" "nsg_adb_webauth_pub" {
  provider            = azurerm.hub
  name                = "nsg-${var.location_code}-sha-${var.code_appli}-transit-adb-pub"
  resource_group_name = "rg-landing-${var.location_code}-sha-nsg"
}

data "azurerm_network_security_group" "nsg_transit" {
  provider            = azurerm.hub
  name                = "nsg-${var.location_code}-sha-${var.code_appli}-transit-adb"
  resource_group_name = "rg-landing-${var.location_code}-sha-nsg"
}


####################################################################
#                      Databricks private zone DNS
####################################################################
/*
data "azurerm_private_dns_zone" "dns_dbc_frontend" {
  provider            = azurerm.hub
  name                = "privatelink.azuredatabricks.net"
  resource_group_name = "rg-landing-${var.location_code}-hub-2"
}
*/

data "azurerm_private_dns_zone" "dns_dbc_backend" {
  provider            = azurerm.hub
  name                = "privatelink.azuredatabricks.net"
  resource_group_name = "rg-landing-${var.location_code}-sha-2"
}

