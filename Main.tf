resource "azurerm_resource_group" "My-RG" {
  name     = "DC-RG"
  location = var.location
  tags = {
    environment = "Prod"
  }
}

resource "azurerm_virtual_network" "My-VNET" {
  name                = "DC-VNET"
  resource_group_name = azurerm_resource_group.My-RG.name
  location            = var.location
  address_space       = ["10.10.0.0/16"]
  depends_on          = [azurerm_resource_group.My-RG]

  tags = {
    environment = "Prod"
  }
}

resource "azurerm_subnet" "My-Subnet" {
  name                 = "DC-Subnet"
  resource_group_name  = azurerm_resource_group.My-RG.name
  virtual_network_name = azurerm_virtual_network.My-VNET.name
  address_prefixes     = ["10.10.0.0/24"]
}

resource "azurerm_public_ip" "My-PublicIP" {
  name                = "DC-PublicIP"
  resource_group_name = azurerm_resource_group.My-RG.name
  location            = var.location
  allocation_method   = "Static"
  depends_on          = [azurerm_resource_group.My-RG]

  tags = {
    environment = "Prod"
  }
}

resource "azurerm_network_interface" "My-Nic" {
  name                = "DC-Nic"
  resource_group_name = azurerm_resource_group.My-RG.name
  location            = var.location
  depends_on          = [azurerm_resource_group.My-RG]

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.My-Subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.10.0.4"
    public_ip_address_id          = azurerm_public_ip.My-PublicIP.id
  }

  tags = {
    environment = "Prod"
  }
}

resource "azurerm_virtual_machine" "My-VM" {
  name                  = "DC-VM"
  location              = var.location
  resource_group_name   = azurerm_resource_group.My-RG.name
  network_interface_ids = [azurerm_network_interface.My-Nic.id]
  vm_size               = "Standard_DS2_v2"
  depends_on            = [azurerm_resource_group.My-RG]

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
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

  os_profile_windows_config {
    provision_vm_agent = true
  }

  tags = {
    environment = "Prod"
  }
}


resource "azurerm_network_security_group" "My-NSG" {
  name                = var.network_security_group_name
  resource_group_name = azurerm_resource_group.My-RG.name
  location            = var.location
  depends_on          = [azurerm_resource_group.My-RG]

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
  resource_group_name         = azurerm_resource_group.My-RG.name
  network_security_group_name = var.network_security_group_name
  depends_on                  = [azurerm_network_security_group.My-NSG]
}

resource "azurerm_network_interface_security_group_association" "My-DC-NSG-Association" {
  network_interface_id      = azurerm_network_interface.My-Nic.id
  network_security_group_id = azurerm_network_security_group.My-NSG.id
}

output "public_ip" {
  value = azurerm_public_ip.My-PublicIP.ip_address
}
