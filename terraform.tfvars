#Root module variables
location            = "France Central"
resource_group_name = "DC-RG"

#Networking module variables
virtual_network_name    = "DC-VNET"
address_space           = ["10.0.0.0/8"]
subnet_name             = "DC-Subnet"
subnet_address_prefixes = ["10.1.0.0/16"]
public_ip_name          = "MyPublicIP"

#Storage-Account module variables
storage_account_name   = "bastawisistorageaccount"
storage_container_name = "mycontainer"
storage_blob_name      = "blobforscript"
stroage_blob_source    = "./Storage-Account/scriptforad.ps1"
script_file_name       = "scriptforad.ps1"

#VM module variables
DC-VM-NIC-Name       = "DC-VM-NIC"
DC-IP-Config-Name    = "DC-IP-Config"
DC-PrivateIP         = "10.1.0.4"
DC-VM-Name           = "DC"
DC-VM-Size           = "Standard_DS2_v2"
DC-Computer-Name     = "DC"
DC-VM-localAdmin     = "admiin"
DC-NSG-Name          = "DC-VM-NSG"
DC-VM-Extension-name = "DC-VM-Extension"

