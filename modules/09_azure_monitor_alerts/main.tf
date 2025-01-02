resource "azurerm_monitor_action_group" "mail" {
  name                = "ag-${var.location_code}-${var.zone}-${var.code_appli}-mail"
  resource_group_name = "rg-${var.location_code}-${var.zone}-${var.code_appli}-backend-adb"
  short_name          = "MailToAdmin"

  email_receiver {
    name          = "mailAdmin"
    email_address = "xxxx@gmail.com"
  }
}

resource "azurerm_monitor_metric_alert" "example" {
  name                = "al-${var.location_code}-${var.zone}-${var.code_appli}-dlkUsage"
  resource_group_name = "rg-${var.location_code}-${var.zone}-${var.code_appli}-backend-adb"
  scopes              = ["${var.dlk_sacc_id}"]
  description         = "Action will be triggered when dlk SA usage is greather thant 100 TB."

  criteria {
    metric_namespace = "Microsoft.Storage/storageAccounts"
    metric_name      = "UsedCapacity"
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = 109951162777600
  }

  action {
    action_group_id = azurerm_monitor_action_group.mail.id
  }
}

locals {
  json_data_logSearch = jsondecode(file("${path.module}\\LogSearch.json"))["alertslogSearch"]
  json_data_alert     = jsondecode(file("${path.module}\\LogSearch.json"))["alertsMetrics"]
}

resource "azurerm_monitor_metric_alert" "example" {
  for_each            = { for t in local.json_data_alert : t.name => t }
  name                = each.value.name //"arisample-metricalert"
  resource_group_name = azurerm_resource_group.rgAlerting.name
  scopes              = [azurerm_storage_account.to_monitor.id]
  description         = each.value.description //"Action will be triggered when Transactions count is greater than 50."

  criteria {
    metric_namespace = each.value.metric_namespace //"Microsoft.Storage/storageAccounts"
    metric_name      = each.value.metric_name      //"Transactions"
    aggregation      = each.value.aggregation      //"Total"
    operator         = each.value.operator         //"GreaterThan"
    threshold        = each.value.threshold        //50

    dimension {
      name     = "ApiName"
      operator = "Include"
      values   = ["*"]
    }
  }
}