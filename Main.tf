resource "azurerm_resource_group" "My-RG" {
  name     = var.resource_group_name
  location = var.location
}

module "Networking" {
  source                  = "./Networking"
  location                = var.location
  resource_group_name     = var.resource_group_name
  virtual_network_name    = var.virtual_network_name
  address_space           = var.address_space
  subnet_name             = var.subnet_name
  subnet_address_prefixes = var.subnet_address_prefixes
  public_ip_name          = var.public_ip_name
}

module "Storage-Account" {
  source                 = "./Storage-Account"
  location               = var.location
  resource_group_name    = var.resource_group_name
  storage_account_name   = var.storage_account_name
  storage_container_name = var.storage_container_name
  storage_blob_name      = var.storage_blob_name
  stroage_blob_source    = var.stroage_blob_source

  #Passing outputs from Networking module to Storage-Account module
  subnet_id = module.Networking.subnet_id
}

module "VM" {
  source                 = "./VM"
  location               = var.location
  resource_group_name    = var.resource_group_name
  DC-VM-NIC-Name         = var.DC-VM-NIC-Name
  DC-IP-Config-Name      = var.DC-IP-Config-Name
  DC-PrivateIP           = var.DC-PrivateIP
  DC-VM-Name             = var.DC-VM-Name
  DC-VM-Size             = var.DC-VM-Size
  DC-Computer-Name       = var.DC-Computer-Name
  DC-VM-localAdmin       = var.DC-VM-localAdmin
  DC-VM-localAdmin-PW    = var.DC-VM-localAdmin-PW
  DC-NSG-Name            = var.DC-NSG-Name
  DC-VM-Extension-name   = var.DC-VM-Extension-name
  storage_account_name   = var.storage_account_name
  storage_container_name = var.storage_container_name
  script_file_name       = var.script_file_name

  #Passing outputs from Networking module to VM module
  subnet_id    = module.Networking.subnet_id
  PublicIP_id  = module.Networking.PublicIP_id
  Storage_blob = module.Storage-Account.Storage_blob
}