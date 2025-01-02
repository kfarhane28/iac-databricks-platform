#####################################################################
#                             Global Init Scripts
####################################################################

resource "databricks_global_init_script" "private-pypi-install" {
  content_base64 = base64encode(<<-EOT
    export HTTPS_PROXY=http://myproxy:8080
    export HTTP_PROXY=http://myproxy:8080
    export https_proxy=http://myproxy:8080
    export http_proxy=http://myproxy:8080

    pip config set global.index-url "https://myartifactory.com/artifactory/api/pypi/pypi-repo/simple"
    pip config set global.trusted-host "myartifactory.com"
    pip install --proxy http://myproxy:8080 --upgrade pip 
    EOT
  )
  name     = "private-pypi-install.sh"
  position = 0
  enabled  = true
}
