# Deploying Databricks Infrastructure on Azure with Terraform

This Terraform project sets up a complete infrastructure on Azure, including a Databricks workspace, storage accounts, virtual networks, a Key Vault, and other key components.
this code use Databricks Standard Deployment for Private Link and is based on the [Medium Article: Azure Databricks Private Link](https://medium.com/@farhanekarim/azure-databricks-private-link-9331f7d5e53b) written by the author.

## Prerequisites

- **Required Software**:
  - Terraform (v1.3.0 or later)
  - Azure CLI (configured and authenticated)
  - Access to an Azure subscription with permissions to create resources.

## Project Structure

### Modules Overview

1. **Virtual Network (VNet)**:
   - Configures the main virtual network and subnets.
   - Module: `./modules/00_vnet`.

2. **Storage Accounts**:
   - Sets up two storage accounts for data storage and transit.
   - Configures data and transit containers.
   - Module: `./modules/04_storage_account`.

3. **Key Vault**:
   - Creates a Key Vault for managing secrets and keys.
   - Restricts access via IP rules and a dedicated subnet.
   - Module: `./modules/01_keyvault`.

4. **Databricks Workspace**:
   - Deploys a Databricks workspace integrated with the virtual network. Using Standard Deployment for Private Link
   - Module: `./modules/02_databricks_compute`.

5. **ADB Connector**:
   - Sets up an access connector for Databricks using a user-assigned identity.
   - Module: `./modules/05_adb_connector`.

6. **Log Analytics Workspace**:
   - Configures a Log Analytics Workspace for monitoring.
   - Module: `./modules/07_log_analytics`.

7. **Databricks Unity Catalog**:
   - Integrates Unity Catalog with the Databricks workspace for data governance.
   - Module: `./modules/08_databricks_unity_catalog`.

8. **Databricks GitLab Proxy**:
   - Sets up a proxy for integrating GitLab with Databricks.
   - Module: `./modules/11_databricks_gitlab_proxy`.

9. **Databricks Monitoring and Alerts**:
   - Creates alerts for monitoring Databricks jobs and clusters.
   - Module: `./modules/10_databricks_monitor_alerts`.

### Other Components

- **User-Assigned Identity**:
  - A managed identity required for specific modules, referenced in the `adb_connector` and `databricks_uc` modules.

## Deployment Steps

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/kfarhane28/iac-databricks-platform.git
   cd iac-databricks-platform
   ```
2. **Initialize Terraform**:
    ```bash
    terraform init
    ```
3. **Set Variables**:
    - Under `environment` directory, update tfvars file for each environment (dev,rec and prd)
    - Update the `DATABRICKS_CLIENT_ID` and `DATABRICKS_CLIENT_SECRET` with you Azure SPN credentials
      ```bash
      export DATABRICKS_CLIENT_ID="xxxxx"
      export DATABRICKS_CLIENT_SECRET="yyyyy"
      ```
4. **Validate and Plan**:
   The following command, run TF Plan again dev environment.
    ```bash
    terraform plan -var-file="environments/dev.vars"
    ```
5. **Apply Changes**:
   The following command, run TF Apply again dev environment.
    ```bash
    terraform apply -var-file="environments/dev.vars"
    ```
    Confirm by typing **yes** when prompted.

## # Resources Deployed
This Terraform configuration deploys:

- A virtual network with required subnets.
- Two storage accounts (data and transit).
- An Azure Key Vault.
- A Databricks workspace with integrated networking.
- A Log Analytics Workspace for monitoring.
- Additional components like Unity Catalog, GitLab proxy, and custom alerts.

## Notes

- Some modules (e.g., `managed_identity`) are commented out and depend on pre-existing configurations created by another team.
- Ensure necessary Azure policies and prerequisites are in place before deployment.

## References
- [Medium Article Azure Databricks Private Link](https://medium.com/@farhanekarim/azure-databricks-private-link-9331f7d5e53b)
- [Terraform Documentation](https://www.terraform.io/docs)
- [Azure Databricks Documentation](https://learn.microsoft.com/en-us/azure/databricks/)
- [AzureRM Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)


## Authors
- Karim FARHANE

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
