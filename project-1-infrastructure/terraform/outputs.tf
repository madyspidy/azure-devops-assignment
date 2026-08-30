output "load_balancer_public_ip" {
  description = "Public IP address of the Azure Load Balancer"
  value       = azurerm_public_ip.lb.ip_address
}

output "vm_private_ip" {
  description = "Private IP address of the application VM"
  value       = azurerm_network_interface.vm.private_ip_address
}

output "postgresql_server_name" {
  description = "PostgreSQL Flexible Server name"
  value       = azurerm_postgresql_flexible_server.main.name
}

output "postgresql_fqdn" {
  description = "PostgreSQL Flexible Server FQDN"
  value       = azurerm_postgresql_flexible_server.main.fqdn
}