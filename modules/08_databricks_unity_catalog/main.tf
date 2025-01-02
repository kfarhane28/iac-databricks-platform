#####################################################################
#                             databricks
####################################################################

resource "databricks_group" "reader_group" {
  provider     = databricks.accounts # Use the 'accounts' provider alias
  display_name = "test_group_tf_kf"
  force        = true

}

data "databricks_metastore" "this" {
  provider = databricks.accounts
  name     = "adb-metastore-${var.location_code}-sha-${var.code_appli}"
  //force_destroy = true
}

resource "databricks_metastore_assignment" "this" {
  provider             = databricks.accounts
  workspace_id         = var.databricks_workspace_dbc_id
  metastore_id         = data.databricks_metastore.this.id
  default_catalog_name = "hive_metastore"
}

resource "databricks_storage_credential" "external" {
  name = "${var.dbc_access_connector_name}-connector"
  azure_managed_identity {
    access_connector_id = var.dbc_access_connector_id
    managed_identity_id = var.managed_identity_id
  }
  force_destroy = true
  force_update  = true
  comment       = "Managed by TF"
  depends_on = [
    databricks_metastore_assignment.this
  ]
}

data "databricks_group" "all_account_users" {
  display_name = "account users"
  provider     = databricks.accounts
}

resource "databricks_external_location" "external_managed_locations" {
  for_each = toset(var.sacc_dlk)
  name     = "managed-location-${var.zone}-${each.value}"
  url = format("abfss://managed@sa%s%s%s%s.dfs.core.windows.net",
    var.location_code,
    var.zone,
    var.code_appli,
  each.value)

  credential_name = databricks_storage_credential.external.id
  comment         = "Managed by TF"
  depends_on = [
    databricks_storage_credential.external
  ]
}

resource "databricks_grants" "browse_permissions" {
  for_each = databricks_external_location.external_managed_locations

  external_location = each.value.id

  grant {
    principal  = data.databricks_group.all_account_users.display_name
    privileges = ["BROWSE"]
  }

  depends_on = [
    databricks_external_location.external_managed_locations
  ]
}


resource "databricks_catalog" "catalog" {
  for_each = toset(var.sacc_dlk)

  name = "catalog_${var.zone}_${each.value}"
  storage_root = format("abfss://managed@sa%s%s%s%s.dfs.core.windows.net",
    var.location_code,
    var.zone,
    var.code_appli,
  each.value)
  comment = "This catalog is managed by Terraform"

  properties = {
    purpose = "Catalog ${each.value} de l'environnement ${var.env}"
  }

  depends_on = [
    databricks_external_location.external_managed_locations
  ]
}

resource "databricks_workspace_binding" "catalog_binding" {
  for_each = databricks_catalog.catalog

  securable_name = each.value.name
  workspace_id   = var.databricks_workspace_dbc_id
  depends_on = [
    databricks_catalog.catalog
  ]
}

resource "databricks_grants" "catalog_browse_permissions" {
  for_each = databricks_catalog.catalog

  catalog = each.value.name

  grant {
    principal  = data.databricks_group.all_account_users.display_name
    privileges = ["BROWSE"]
  }
  depends_on = [
    databricks_catalog.catalog
  ]
}



/*
resource "databricks_catalog_workspace_binding" "sandbox" {
  securable_name = databricks_catalog.sandbox.name
  workspace_id   = databricks_mws_workspaces.other.workspace_id
}

resource "databricks_grants" "external_creds" {
  storage_credential = databricks_storage_credential.external.id
  grant {
    principal  = "Data Engineers"
    privileges = ["CREATE_EXTERNAL_TABLE"]
  }
  depends_on = [
    databricks_storage_credential.external
  ]
}

resource "databricks_cluster" "mycluster" {
  num_workers             = 1
  cluster_name            = "myTF_cluster"
  idempotency_token       = "mycluster_tfos"
  spark_version           = "13.3.x-scala2.12"
  node_type_id            = "Standard_DS3_v2"
  autotermination_minutes = 60
  data_security_mode      = "USER_ISOLATION"
}

resource "databricks_external_location" "external_locations" {
  for_each = toset(var.data_container_names)
  name     = each.value
  url = format("abfss://%s@%s.dfs.core.windows.net",
    each.value,
  var.sacc_name)

  credential_name = databricks_storage_credential.external.id
  comment         = "Managed by TF"
  depends_on = [
    databricks_storage_credential.external
  ]
}

resource "databricks_external_location" "transit_external_locations" {
  for_each = toset(var.transit_container_names)
  name     = each.value
  url = format("abfss://%s@%s.dfs.core.windows.net",
    each.value,
  var.transit_sacc_name)

  credential_name = databricks_storage_credential.external.id
  comment         = "Managed by TF"
  depends_on = [
    databricks_storage_credential.external
  ]
}
 */