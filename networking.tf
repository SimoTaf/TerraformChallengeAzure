resource "azurerm_virtual_network" "vNet" {
  name                = "vNet"
  resource_group_name = var.rg
  location            = "East US"
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "mySubnet" {
  # count                = var.myIteration
  # name                 = "mysubnet_0${count.index}"
  name                 = "myVmSubnet"
  resource_group_name  = var.rg
  virtual_network_name = azurerm_virtual_network.vNet.name
  # address_prefixes     = ["10.0.${count.index}.0/24"]
  address_prefixes = ["10.0.1.0/24"]

}

resource "azurerm_subnet_nat_gateway_association" "subnetNatgwAssoc" {
  # count          = var.myIteration
  # subnet_id      = azurerm_subnet.mySubnet[count.index].id
  subnet_id      = azurerm_subnet.mySubnet.id
  nat_gateway_id = azurerm_nat_gateway.nat.id
}