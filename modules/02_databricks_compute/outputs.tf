output "databricks_workspace_az_id" {
  value = azurerm_databricks_workspace.ws_adb.id
}

output "databricks_workspace_dbc_id" {
  value = azurerm_databricks_workspace.ws_adb.workspace_id
}

output "databricks_workspace_host" {
  value = azurerm_databricks_workspace.ws_adb.workspace_url
}