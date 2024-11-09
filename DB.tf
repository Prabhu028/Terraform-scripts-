resource "azurerm_postgresql_flexible_server" "myDB" {
  name                         = var.db_name
  location                     = azurerm_resource_group.Myresrc.location
  resource_group_name          = azurerm_resource_group.Myresrc.name
  sku_name                     = "B_Standard_B1ms"
  storage_mb                   = 32768
  backup_retention_days        = 7
  geo_redundant_backup_enabled = false
  auto_grow_enabled            = false
  high_availability {
    mode = "SameZone"
  }
  version = "15"

  administrator_login    = "postgreSQL"
  administrator_password = "mypostgresql!@spae_mh"

  #public_network_access_enabled = true
  tags = {
    mh-ipm = "dev"
  }
}


resource "azurerm_postgresql_flexible_server_database" "mydb" {
  name      = "exampledb"
  server_id = azurerm_postgresql_flexible_server.myDB.id
  collation = "en_US.utf8"
  charset   = "utf8"

  lifecycle {
    prevent_destroy = true
  }
}


output "postgresql_flexible_server_fqdn" {
  description = "The FQDN of the PostgreSQL Flexible Server"
  value       = azurerm_postgresql_flexible_server.myDB.fqdn
}

output "postgresql_admin_login" {
  description = "The administrator login for the PostgreSQL Flexible Server"
  value       = azurerm_postgresql_flexible_server.myDB.administrator_login
}

output "postgresql_database_name" {
  description = "The name of the PostgreSQL Database"
  value       = azurerm_postgresql_flexible_server_database.mydb.name
}


