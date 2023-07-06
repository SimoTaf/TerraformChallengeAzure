resource "azurerm_monitor_action_group" "actionGrp" {
  name                = "monitor-actiongroup"
  resource_group_name = var.rg

  short_name = "myAct"

  email_receiver {
    name          = "mailTosend"
    email_address = "sidahmed.tafifet@infraxcode.com"
  }
}
resource "azurerm_monitor_metric_alert" "metric" {
  name                = "monitor-metricalert"
  resource_group_name = var.rg
  scopes              = [azurerm_application_gateway.network.id]
  description         = "Action will be triggered when more than 10 request/minute  to the app."

  criteria {
    metric_namespace = "Microsoft.Network/applicationGateways"
    metric_name      = "TotalRequests"
    # metric_name      = "Transactions"
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = 10
    skip_metric_validation  = true
    # dimension {
    #   name     = "ApiName"
    #   operator = "Include"
    #   values   = ["*"]
    # }
  
  
}
# enabled  =  true
  
  # action {
  #   action_group_id = azurerm_monitor_action_group.actionGrp.id
  # }
  # target_resource_type = "Microsoft.Network/applicationGateways"
  # target_resource_location = azurerm_linux_virtual_machine.myVms[0].location
  # depends_on = [
  #   azurerm_application_gateway.network ,
  #   azurerm_monitor_action_group.actionGrp
  # ]
}