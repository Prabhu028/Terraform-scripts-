resource "azurerm_public_ip" "mhpublic-ip" {
  name                = "mhip1"
  resource_group_name = azurerm_resource_group.Myresrc.name
  location            = azurerm_resource_group.Myresrc.location
  allocation_method   = "Static"

  tags = {
    mh-ipm = "dev"
  }
}

resource "azurerm_virtual_network" "myVnet" {
  name                = var.vnet_name
  resource_group_name = azurerm_resource_group.Myresrc.name
  location            = azurerm_resource_group.Myresrc.location
  address_space       = [var.vnet_cidr]

  depends_on = [azurerm_resource_group.Myresrc]
  tags = {
    mh-ipm = "dev"
  }
}

resource "azurerm_subnet" "mysubnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.Myresrc.name
  virtual_network_name = azurerm_virtual_network.myVnet.name
  address_prefixes     = [var.subnet_cidr]
  depends_on           = [azurerm_virtual_network.myVnet]
}

resource "azurerm_network_interface" "mynic" {
  name                = "appnic"
  location            = azurerm_resource_group.Myresrc.location
  resource_group_name = azurerm_resource_group.Myresrc.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.mysubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.mhpublic-ip.id
  }
  depends_on = [azurerm_public_ip.mhpublic-ip, azurerm_subnet.mysubnet]
}

resource "azurerm_network_interface_security_group_association" "associat" {
  network_interface_id      = azurerm_network_interface.mynic.id
  network_security_group_id = azurerm_network_security_group.mynsg.id

  depends_on = [azurerm_network_security_group.mynsg, azurerm_subnet.mysubnet]
}

resource "azurerm_linux_virtual_machine" "myvm" {
  name                            = var.vm_name
  resource_group_name             = azurerm_resource_group.Myresrc.name
  location                        = azurerm_resource_group.Myresrc.location
  size                            = var.vm_size
  admin_username                  = var.admin_username
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.mynic.id,
  ]

  admin_password = "**********"


  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

output "public_ip_address" {
  description = "The public IP address of the Azure VM"
  value       = azurerm_public_ip.mhpublic-ip.ip_address
  depends_on  = [azurerm_linux_virtual_machine.myvm]
}