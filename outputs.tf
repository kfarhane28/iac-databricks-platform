output "databricks_az_id" {
  value = module.databricks.databricks_workspace_az_id
}

output "databricks_id" {
  value = module.databricks.databricks_workspace_dbc_id
}


output "databricks_host" {
  value = module.databricks.databricks_workspace_host
}


output "databricks_wa_az_id" {
  value = module.databricks_webauth.databricks_workspace_webauth_az_id
}

output "databricks_wa_id" {
  value = module.databricks_webauth.databricks_workspace_webauth_dbc_id
}


output "databricks_wa_host" {
  value = module.databricks_webauth.databricks_workspace_webauth_host
}