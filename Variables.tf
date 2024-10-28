#root variables
variable "location" {}
variable "resource_group_name" {}

#Networking module variables
variable "virtual_network_name" {}
variable "address_space" {}
variable "subnet_name" {}
variable "subnet_address_prefixes" {}
variable "public_ip_name" {}

#Stroage-Account module variables
variable "storage_account_name" {}
variable "storage_container_name" {}
variable "storage_blob_name" {}
variable "stroage_blob_source" {}
variable "script_file_name" {}

#VM module variables
variable "DC-VM-NIC-Name" {}
variable "DC-IP-Config-Name" {}
variable "DC-PrivateIP" {}
variable "DC-VM-Name" {}
variable "DC-VM-Size" {}
variable "DC-Computer-Name" {}
variable "DC-VM-localAdmin" {}
variable "DC-VM-localAdmin-PW" {}
variable "DC-NSG-Name" {}
variable "DC-VM-Extension-name" {}