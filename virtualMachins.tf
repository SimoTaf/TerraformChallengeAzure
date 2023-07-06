resource "azurerm_linux_virtual_machine" "myVms" {
  count                           = var.myIteration
  name                            = "myVm0n${count.index}"
  resource_group_name             = var.rg
  location                        = "East US"
  size                            = "Standard_F2"
  admin_username                  = "adminuser"
  disable_password_authentication = false
  admin_password                  = "Abc_123###"
  network_interface_ids = [
    azurerm_network_interface.nic[count.index].id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }

  custom_data = base64encode(data.template_file.linux-vm-cloud-init.rendered)

}
# Data template Bash bootstrapping file
data "template_file" "linux-vm-cloud-init" {
  template = file("myScript.sh")
}

