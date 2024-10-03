
#Needed for executing a script:

resource "azurerm_storage_account" "My-StorageAccount" {
  name                     = "bastawisidcstorage"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  depends_on               = [azurerm_virtual_machine.My-VM, azurerm_public_ip.My-PublicIP]

  network_rules {
    default_action             = "Deny"
    ip_rules                   = ["156.214.234.210"]
    virtual_network_subnet_ids = [azurerm_subnet.My-Subnet.id]
  }

  tags = {
    environment = "Prod"
  }
}

resource "azurerm_storage_container" "My-Container" {
  name                  = "dc-container"
  storage_account_name  = azurerm_storage_account.My-StorageAccount.name
  container_access_type = "blob"

}

resource "azurerm_storage_blob" "My-blob" {
  name                   = "scriptforad.ps1"
  storage_account_name   = azurerm_storage_account.My-StorageAccount.name
  storage_container_name = azurerm_storage_container.My-Container.name
  type                   = "Block"
  source                 = "scriptforad.ps1"

}