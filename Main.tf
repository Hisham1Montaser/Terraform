resource "azurerm_resource_group" "My-RG-Alise" {
  name     = "My-RG"
  location = "East Us"
  tags = {
    environment = "Dev"
  }
}

resource "azurerm_virtual_network" "My-VNET-Alise" {
  name                = "My-VNET"
  resource_group_name = azurerm_resource_group.My-RG-Alise.name
  location            = azurerm_resource_group.My-RG-Alise.location
  address_space       = ["10.10.0.0/16"]

  tags = {
    environment = "Dev"
  }
}

resource "azurerm_subnet" "My-Subnet-Alise" {
  name                 = "My-Subnet"
  resource_group_name  = azurerm_resource_group.My-RG-Alise.name
  virtual_network_name = azurerm_virtual_network.My-VNET-Alise.name
  address_prefixes     = ["10.10.10.0/24"]
}

resource "azurerm_network_security_group" "My-NSG-Alise" {
  name                = "My-NSG"
  resource_group_name = azurerm_resource_group.My-RG-Alise.name
  location            = azurerm_resource_group.My-RG-Alise.location
  tags = {
    environment = "Dev"
  }
}

resource "azurerm_network_security_rule" "My-NSGRule-Alise" {
  name                        = "My-NSGRule"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.My-RG-Alise.name
  network_security_group_name = azurerm_network_security_group.My-NSG-Alise.name
}

resource "azurerm_subnet_network_security_group_association" "MY-NSGAssociation" {
  subnet_id                 = azurerm_subnet.My-Subnet-Alise.id
  network_security_group_id = azurerm_network_security_group.My-NSG-Alise.id
}

resource "azurerm_public_ip" "My-PublicIP-Alise" {
  name                = "My-PublicIP"
  resource_group_name = azurerm_resource_group.My-RG-Alise.name
  location            = azurerm_resource_group.My-RG-Alise.location
  allocation_method   = "Static"

  tags = {
    environment = "Dev"
  }
}

resource "azurerm_network_interface" "My-Nic-Alise" {
  name                = "My-Nic"
  resource_group_name = azurerm_resource_group.My-RG-Alise.name
  location            = azurerm_resource_group.My-RG-Alise.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.My-Subnet-Alise.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.My-PublicIP-Alise.id
  }

  tags = {
    environment = "Dev"
  }
}

test