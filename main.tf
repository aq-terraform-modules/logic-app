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
  
  lifecycle {
    ignore_changes  = [tags]
  }
}