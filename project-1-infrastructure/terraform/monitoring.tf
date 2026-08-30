# Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "main" {
  name                = "8byte-assignment-law"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}


# Azure Monitor Agent
resource "azurerm_virtual_machine_extension" "azure_monitor_agent" {
  name                       = "AzureMonitorLinuxAgent"
  virtual_machine_id         = azurerm_linux_virtual_machine.app.id
  publisher                  = "Microsoft.Azure.Monitor"
  type                       = "AzureMonitorLinuxAgent"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true
}


# Data Collection Rule
resource "azurerm_monitor_data_collection_rule" "main" {
  name                = "8byte-assignment-dcr"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  kind                = "Linux"

  destinations {
    log_analytics {
      workspace_resource_id = azurerm_log_analytics_workspace.main.id
      name                  = "law"
    }
  }

  data_flow {
    streams = [
      "Microsoft-Perf",
      "Microsoft-Syslog"
    ]

    destinations = ["law"]
  }

  data_sources {
    performance_counter {
      name                          = "basic-metrics"
      streams                       = ["Microsoft-Perf"]
      sampling_frequency_in_seconds = 60

      counter_specifiers = [
        "\\Processor(*)\\% Processor Time",
        "\\Memory(*)\\Used Memory MBytes",
        "\\Logical Disk(*)\\% Used Space"
      ]
    }

    syslog {
      name           = "linux-syslog"
      streams        = ["Microsoft-Syslog"]
      facility_names = ["*"]

      log_levels = [
        "Warning",
        "Error",
        "Critical",
        "Alert",
        "Emergency"
      ]
    }
  }
}


# Associate DCR with VM
resource "azurerm_monitor_data_collection_rule_association" "vm" {
  name                    = "8byte-assignment-dcr-association"
  target_resource_id      = azurerm_linux_virtual_machine.app.id
  data_collection_rule_id = azurerm_monitor_data_collection_rule.main.id
}


# Application Insights
resource "azurerm_application_insights" "app" {
  name                = "8byte-assignment-appinsights"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  workspace_id        = azurerm_log_analytics_workspace.main.id
  application_type    = "web"
}