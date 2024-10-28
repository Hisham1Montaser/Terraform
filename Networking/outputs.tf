output "subnet_id" {
    value= azurerm_subnet.My-Subnet.id
}

output "PublicIP_id" {
  value= azurerm_public_ip.My-PublicIP.id
}