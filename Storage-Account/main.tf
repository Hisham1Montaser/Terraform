
#Needed for executing a script:

resource "azurerm_storage_account" "My-StorageAccount" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  network_rules {
    default_action             = "Deny"
    ip_rules                   = ["41.34.12.252"]
    virtual_network_subnet_ids = [var.subnet_id]
  }
}

resource "azurerm_storage_container" "My-Container" {
  name                  = var.storage_container_name
  storage_account_name  = azurerm_storage_account.My-StorageAccount.name
  container_access_type = "blob"

}

resource "azurerm_storage_blob" "My-blob" {
  name                   = "scriptforad.ps1"
  storage_account_name   = azurerm_storage_account.My-StorageAccount.name
  storage_container_name = azurerm_storage_container.My-Container.name
  type                   = "Block"
  source                 = var.stroage_blob_source

}