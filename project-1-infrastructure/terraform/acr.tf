resource "azurerm_container_registry" "main" {
  name                = "8byteassignmentacr"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = "Basic"
  admin_enabled       = false
}