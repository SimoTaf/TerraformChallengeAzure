resource "azurerm_subnet" "frontend" {
  name                 = "apgwSubnetTerraform"
  resource_group_name  = var.rg
  virtual_network_name = azurerm_virtual_network.vNet.name
  address_prefixes     = ["10.0.2.0/24"]
}
resource "azurerm_public_ip" "agwIP" {
  name                = "agwPubIPterraform"
  resource_group_name = var.rg
  location            = azurerm_linux_virtual_machine.myVms[0].location
  allocation_method   = "Dynamic"
}

locals {
  backend_address_pool_name      = "${azurerm_virtual_network.vNet.name}-backendPool"
  frontend_port_name             = "${azurerm_virtual_network.vNet.name}-feport"
  frontend_ip_configuration_name = "${azurerm_virtual_network.vNet.name}-feip"
  http_setting_name              = "${azurerm_virtual_network.vNet.name}-be-htst"
  listener_name                  = "${azurerm_virtual_network.vNet.name}-httplstn"
  request_routing_rule_name      = "${azurerm_virtual_network.vNet.name}-rqrt"
  redirect_configuration_name    = "${azurerm_virtual_network.vNet.name}-rdrcfg"
}


resource "azurerm_application_gateway" "network" {
  name                = "myAppgatewayTerraform"
  resource_group_name = var.rg
  location            = azurerm_linux_virtual_machine.myVms[0].location
  sku {
    name     = "Standard_Small"
    tier     = "Standard"
    capacity = 2
  }
  # autoscale_configuration {
  #   min_capacity = 0
  #   max_capacity = 10
  # }
  gateway_ip_configuration {
    name      = "my-gateway-ip-configuration"
    subnet_id = azurerm_subnet.frontend.id
  }

  frontend_port {
    name = local.frontend_port_name
    port = 80
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.agwIP.id
  }

  backend_address_pool {

    name = local.backend_address_pool_name // here i must do changes to map vms private ips 
    # ip_addresses = [azurerm_public_ip.PublicIP[0].ip_address, azurerm_public_ip.PublicIP[1].ip_address]
    # ip_addresses = azurerm_network_interface.nic[0].ip_configuration[0].subnet_id
    ip_addresses = [azurerm_network_interface.nic[0].private_ip_address, azurerm_network_interface.nic[1].private_ip_address]
  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    #path                                = "/"
    port                                = 80
    protocol                            = "Http"
    request_timeout                     = 20
    pick_host_name_from_backend_address = true
    probe_name                          = "myProbe"


  }
  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
    ## priority                   = 10000
  }
  probe {
    # host                                      = "127.0.0.1"
    name                                      = "myProbe"
    interval                                  = 30
    protocol                                  = "Http"
    path                                      = "/"
    timeout                                   = 30
    unhealthy_threshold                       = 3
    pick_host_name_from_backend_http_settings = true

  }

  # zones = [1, 2, 3]

  ##########
  ## this is where i will try nic for my appgateway 
}

# resource "azurerm_network_interface_backend_address_pool_association" "nicBackPoolAssoc" {
#   count                   = var.myIteration
#   network_interface_id    = azurerm_network_interface.nic[count.index].id
#   ip_configuration_name   = azurerm_network_interface.nic[count.index].ip_configuration.name
#   backend_address_pool_id = azurerm_application_gateway.network.backend_address_pool.id
# }

# resource "azurerm_network_interface_application_gateway_backend_address_pool_association" "nicBackPoolAssoc" {
#   count                   = var.myIteration
#   network_interface_id    = azurerm_network_interface.nic[count.index].id
#   ip_configuration_name   = azurerm_network_interface.nic[0].ip_configuration[0].name
#   backend_address_pool_id = tolist(azurerm_application_gateway.network.backend_address_pool).0.id
# }








