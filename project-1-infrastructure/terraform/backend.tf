terraform {
  backend "azurerm" {
    resource_group_name  = "8byte-tfstate-rg"
    storage_account_name = "8bytetfstate12345"
    container_name       = "tfstate"
    key                  = "8byte-assignment.tfstate"
  }
}