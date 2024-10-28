
resource "azurerm_network_interface" "My-Nic" {
  name                = var.DC-VM-NIC-Name
  resource_group_name = var.resource_group_name
  location            = var.location

  ip_configuration {
    name                          = var.DC-IP-Config-Name
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.DC-PrivateIP
    public_ip_address_id          = var.PublicIP_id
  }
}

resource "azurerm_virtual_machine" "My-VM" {
  name                  = var.DC-VM-Name
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.My-Nic.id]
  vm_size               = var.DC-VM-Size

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
    managed_disk_type = "StandardSSD_LRS"
  }
  os_profile {
    computer_name  = var.DC-Computer-Name
    admin_username = var.DC-VM-localAdmin
    admin_password = var.DC-VM-localAdmin-PW
  }

  os_profile_windows_config {
    provision_vm_agent = true
  }
}


resource "azurerm_network_security_group" "My-NSG" {
  name                = var.DC-NSG-Name
  resource_group_name = var.resource_group_name
  location            = var.location
}

resource "azurerm_network_security_rule" "My-NSGRule-Inbound" {
  name                        = "DC-InboundNSGRule"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.My-NSG.name
}

resource "azurerm_network_interface_security_group_association" "My-DC-NSG-Association" {
  network_interface_id      = azurerm_network_interface.My-Nic.id
  network_security_group_id = azurerm_network_security_group.My-NSG.id
}


resource "azurerm_virtual_machine_extension" "My-VMExtension" {
  name                 = var.DC-VM-Extension-name
  virtual_machine_id   = azurerm_virtual_machine.My-VM.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"
  depends_on           = [var.Storage_blob]
  settings             = <<SETTINGS
 {
 "fileUris": ["https://${var.storage_account_name}.blob.core.windows.net/${var.storage_container_name}/${var.script_file_name}"],
  "commandToExecute": "powershell -ExecutionPolicy Unrestricted -file ${var.script_file_name}"
 }
SETTINGS
}