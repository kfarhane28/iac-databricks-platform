output "databricks_workspace_webauth_az_id" {
  value = [for key, wa in azurerm_databricks_workspace.ws_adb_webauth : wa.id]
}


output "databricks_workspace_webauth_dbc_id" {
  value = [for key, wa in azurerm_databricks_workspace.ws_adb_webauth : wa.workspace_id]
}

output "databricks_workspace_webauth_host" {
  value = [for key, wa in azurerm_databricks_workspace.ws_adb_webauth : wa.workspace_url]
}

/*
output "databricks_workspace_webauth_az_id" {
  value = azurerm_databricks_workspace.ws_adb_webauth.id
}

output "databricks_workspace_webauth_dbc_id" {
  value = azurerm_databricks_workspace.ws_adb_webauth.workspace_id
}

output "databricks_workspace_webauth_host" {
  value = azurerm_databricks_workspace.ws_adb_webauth.workspace_url
}
*/