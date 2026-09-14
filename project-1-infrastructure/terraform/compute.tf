resource "azurerm_network_interface" "vm" {
  name                = "${var.project_name}-vm-nic"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.public.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "app" {
  name                = "${var.project_name}-vm"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  size                = "Standard_D2s_v3"
  admin_username      = "azureuser"
  computer_name       = "8byte-app-vm"

  network_interface_ids = [
    azurerm_network_interface.vm.id
  ]

  admin_password                  = var.vm_admin_password
  disable_password_authentication = false

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }

  custom_data = base64encode(<<-EOF
#!/bin/bash
set -e

apt-get update -y

# Install Docker
apt-get install -y docker.io curl ca-certificates apt-transport-https
systemctl enable docker
systemctl start docker

# Install Azure CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# Make sure nginx does not occupy port 80
systemctl stop nginx || true
systemctl disable nginx || true
EOF
  )

  identity {
    type = "SystemAssigned"
  }
}