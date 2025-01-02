#####################################################################
#                             databricks Git Proxy
####################################################################


resource "databricks_cluster" "git_proxy_cluster" {
  cluster_name            = "Repos GitLab Proxy"
  spark_version           = "12.2.x-scala2.12"
  autotermination_minutes = 0
  num_workers             = 0
  node_type_id            = "Standard_DS3_v2"

  spark_conf = {
    "spark.databricks.cluster.profile" = "singleNode"
    "spark.master"                     = "local[*]"
  }

  custom_tags = {
    "ResourceClass" = "SingleNode"
  }

  spark_env_vars = {
    "GIT_PROXY_ENABLE_SSL_VERIFICATION" = "false"
    "GIT_PROXY_HTTP_PROXY"              = "http://myproxy:8080"
  }
}

resource "databricks_workspace_conf" "enable_git_proxy" {
  custom_config = {
    "enableGitProxy" = "true"
  }
}

resource "databricks_workspace_conf" "set_git_proxy_cluster" {
  custom_config = {
    "gitProxyClusterId" = databricks_cluster.git_proxy_cluster.cluster_id
  }

  depends_on = [databricks_cluster.git_proxy_cluster]
}
