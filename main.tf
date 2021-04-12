resource "azurerm_resource_group" "logicapprg" {
  name      = var.resource_group_name
  location  = var.location

  lifecycle {
    ignore_changes  = [tags]
  }
}

resource "azurerm_logic_app_workflow" "logicappwf" {
  name      = "${var.logic_app_name}-workflow"
  location  = var.location
  resource_group_name = azurerm_resource_group.logicapprg.name 

  lifecycle {
    ignore_changes  = [tags]
  }
}

resource "azurerm_logic_app_trigger_recurrence" "logicapptrigger" {
  name         = "${var.logic_app_name}-trigger"
  logic_app_id = azurerm_logic_app_workflow.logicappwf.id
  frequency    = "Day"
  interval     = 1
}

resource "azurerm_resource_group_template_deployment" "example" {
  name                = "${var.logic_app_name}-sqlconnection"
  resource_group_name = azurerm_resource_group.logicapprg.name
  deployment_mode     = "Incremental"
  template_content = <<TEMPLATE
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "connections_sql_name": {
            "defaultValue": "sql",
            "type": "String"
        },
        "location": {
            "defaultValue": "southeastasia",
            "type": "String"
        }
    },
    "variables": {},
    "resources": [
        {
            "type": "Microsoft.Web/connections",
            "apiVersion": "2016-06-01",
            "name": "[parameters('connections_sql_name')]",
            "location": "[parameters('location')]",
            "properties": {
                "displayName": "Test",
                "customParameterValues": {},
                "api": {
                    "id": "[concat('/subscriptions/7bd03bca-6ad8-4e23-87e7-88457e614216/providers/Microsoft.Web/locations/southeastasia/managedApis/', parameters('connections_sql_name'))]"
                }
            }
        }
    ]
}

TEMPLATE

  // NOTE: whilst we show an inline template here, we recommend
  // sourcing this from a file for readability/editor support
}