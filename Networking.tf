
resource "azurerm_virtual_network" "My-VNET" {
  name                = var.virtual_network_name
  resource_group_name = azurerm_resource_group.My-RG.name
  location            = var.location
  address_space       = ["10.10.0.0/16"]

  tags = {
    environment = "Prod"
  }
}

resource "azurerm_subnet" "My-Subnet" {
  name                 = "DC-Subnet"
  resource_group_name  = azurerm_resource_group.My-RG.name
  virtual_network_name = azurerm_virtual_network.My-VNET.name
  address_prefixes     = ["10.10.0.0/24"]
  service_endpoints    = ["Microsoft.Storage"]
}

resource "azurerm_public_ip" "My-PublicIP" {
  name                = "DC-PublicIP"
  resource_group_name = azurerm_resource_group.My-RG.name
  location            = var.location
  allocation_method   = "Static"

  tags = {
    environment = "Prod"
  }
}


output "public_ip" {
  value = azurerm_public_ip.My-PublicIP.ip_address
}
