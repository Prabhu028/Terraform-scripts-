resource "azurerm_resource_group" "Myresrc" {
  name     = var.resource_name
  location = var.location
  tags = {
    mh-ipm = "dev"
  }
}