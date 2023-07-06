resource "azurerm_public_ip" "natPubIP" {
  name                = "nat-gateway-publicIP"
  location            = azurerm_linux_virtual_machine.myVms[0].location
  resource_group_name = var.rg
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1"]
}



resource "azurerm_nat_gateway" "nat" {
  name                    = "nat-Gateway"
  location                = azurerm_linux_virtual_machine.myVms[0].location
  resource_group_name     = var.rg
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
  zones                   = ["1"]
}
resource "azurerm_nat_gateway_public_ip_association" "natAssocPubIP" {
  nat_gateway_id       = azurerm_nat_gateway.nat.id
  public_ip_address_id = azurerm_public_ip.natPubIP.id
}