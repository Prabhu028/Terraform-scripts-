resource "azurerm_network_security_group" "mynsg" {
  name                = "mh_nsg"
  resource_group_name = azurerm_resource_group.Myresrc.name
  location            = azurerm_resource_group.Myresrc.location
}

resource "azurerm_network_security_rule" "myrule" {
  count                       = length(var.nsg_rules_app_subnet)
  name                        = var.nsg_rules_app_subnet[count.index].name
  priority                    = var.nsg_rules_app_subnet[count.index].priority
  direction                   = "Inbound"
  access                      = var.nsg_rules_app_subnet[count.index].access
  protocol                    = var.nsg_rules_app_subnet[count.index].protocol
  source_port_range           = var.nsg_rules_app_subnet[count.index].source_port_range
  destination_port_range      = var.nsg_rules_app_subnet[count.index].destination_port_range
  source_address_prefix       = var.nsg_rules_app_subnet[count.index].source_address_prefix
  destination_address_prefix  = var.nsg_rules_app_subnet[count.index].destination_address_prefix
  resource_group_name         = azurerm_resource_group.Myresrc.name
  network_security_group_name = azurerm_network_security_group.mynsg.name


  depends_on = [azurerm_virtual_network.myVnet]
}