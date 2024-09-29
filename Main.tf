resource "azurerm_resource_group" "My-RG" {
  name     = var.resource_group_name
  location = var.location
  tags = {
    environment = "Prod"
  }
}

resource "azurerm_virtual_network" "My-VNET" {
  name                = "DC-VNET"
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = ["10.10.0.0/16"]

  tags = {
    environment = "Prod"
  }
}

resource "azurerm_subnet" "My-Subnet" {
  name                 = "DC-Subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  address_prefixes     = ["10.10.0.0/24"]
}


resource "azurerm_network_interface" "My-Nic" {
  name                = "DC-Nic"
  resource_group_name = var.resource_group_name
  location            = var.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.My-Subnet
    private_ip_address_allocation = "Static"
  }

  tags = {
    environment = "Prod"
  }
}

resource "azurerm_virtual_machine" "My-VM" {
  name                  = "DC-VM"
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = azurerm_network_interface.My-Nic
  vm_size               = "Standard_DC2ds_v3"


  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }
  storage_os_disk {
    name              = "MyOSDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "DC"
    admin_username = "admiin"
    admin_password = var.admin_password
  }

  tags = {
    environment = "Prod"
  }
}


resource "azurerm_network_security_group" "My-NSG" {
  name                = var.network_security_group_name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags = {
    environment = "Prod"
  }
}

resource "azurerm_network_security_rule" "My-NSGRule" {
  name                        = "DC-NSGRule"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = var.network_security_group_name
}

resource "azurerm_network_interface_security_group_association" "My-DC-NSG-Association" {
  network_interface_id      = azurerm_network_interface.My-Nic.id
  network_security_group_id = azurerm_network_security_group.My-NSG.id
}

resource "azurerm_public_ip" "My-PublicIP" {
  name                = "DC-PublicIP"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"

  tags = {
    environment = "Prod"
  }
}
