resource "azurerm_network_interface" "nic" {
  count               = var.myIteration
  name                = "myNic${count.index}"
  location            = "East US"
  resource_group_name = var.rg

  ip_configuration {
    # count                         = var.myIteration
    name = "internal"
    # subnet_id                     = azurerm_subnet.mySubnet[count.index].id
    subnet_id                     = azurerm_subnet.mySubnet.id
    private_ip_address_allocation = "Dynamic"
  }
}
