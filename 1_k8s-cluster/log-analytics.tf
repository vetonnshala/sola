resource "azurerm_log_analytics_workspace" "insights" {
  name                = "logs-solaborate"
  location            = azurerm_resource_group.solaborate-rg.location
  resource_group_name = azurerm_resource_group.solaborate-rg.name
  retention_in_days   = 30
}