terraform {
  backend "azurerm" {
    resource_group_name = "My-RG"
    storage_account_name = "bastawisiterraformsa"
    container_name = "mytfstate"
    key = "terraform.tfstate"
  }
}