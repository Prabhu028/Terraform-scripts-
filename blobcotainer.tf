resource "azurerm_storage_account" "mystrg" {
  name                     = "spaestorage1"
  resource_group_name      = azurerm_resource_group.Myresrc.name
  location                 = azurerm_resource_group.Myresrc.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    mh-ipm = "dev"
  }
}

resource "azurerm_storage_container" "container" {
  name                  = "spaemh1"
  storage_account_name  = azurerm_storage_account.mystrg.name
  container_access_type = "container"
}

output "storage_account_primary_access_key" {
  value = azurerm_storage_account.mystrg.primary_access_key
  sensitive = true
}