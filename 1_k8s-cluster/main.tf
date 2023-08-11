resource "azurerm_resource_group" "solaborate-rg" {
  location = local.location
  name     = local.resource_group_name
}

resource "azurerm_virtual_network" "vnet" {
  name                = "my-vnet"
  resource_group_name = azurerm_resource_group.solaborate-rg.name
  location            = azurerm_resource_group.solaborate-rg.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.solaborate-rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azuread_group" "aks_administrators" {
  display_name = "${local.aks_cluster_name}-administrators"
}

resource "azurerm_kubernetes_cluster" "aks" {
  dns_prefix          = local.aks_cluster_name
  kubernetes_version  = data.azurerm_kubernetes_service_versions.current.latest_version
  location            = azurerm_resource_group.solaborate-rg.location
  name                = local.aks_cluster_name
  node_resource_group = "${azurerm_resource_group.solaborate-rg.name}-aks"
  resource_group_name = azurerm_resource_group.solaborate-rg.name

    oms_agent {
      log_analytics_workspace_id = azurerm_log_analytics_workspace.insights.id
    }

  default_node_pool {
    availability_zones   = [1, 2, 3]
    enable_auto_scaling  = true
    max_count            = 3
    min_count            = 1
    name                 = "solapool1"
    orchestrator_version = data.azurerm_kubernetes_service_versions.current.latest_version
    # os_disk_size_gb      = 1024
    vm_size              = "Standard_DS2_v2"
  }

  identity { type = "SystemAssigned" }

  role_based_access_control_enabled = true 
}

resource "azurerm_windows_virtual_machine" "windows_vm" {
  name                  = "winsola"
  resource_group_name   = azurerm_resource_group.solaborate-rg.name
  location              = azurerm_resource_group.solaborate-rg.location
  size                  = "Standard_DS2_v2"
  admin_username        = var.aad_admin_username
  admin_password        = var.admin_password
  network_interface_ids = [azurerm_network_interface.windows_vm_nic.id]

  # os_disk {
  #   name                 = "osdisk"
  #   caching              = "ReadWrite"
  #   storage_account_type = "Standard_LRS"
  # }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter"
    version   = "latest"
  }
}

resource "azurerm_virtual_machine_extension" "aad_extension" {
  name                 = "aad-extension"
  virtual_machine_id   = azurerm_windows_virtual_machine.windows_vm.id
  publisher            = "Microsoft.Compute"
  type                 = "JsonADDomainExtension"
  type_handler_version = "1.3"

  settings = <<SETTINGS
    {
        "Name": "${local.aad_domain_name}",
        "OUPath": "OU=VMs,DC=vettonshalaagmail.onmicrosoft.com,DC=com",
        "User": "${var.aad_admin_username}",
        "Restart": "true",
        "Options": "3"
    }
SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
    {
        "Password": "${var.admin_password}"
    }
PROTECTED_SETTINGS
}

resource "azurerm_network_interface" "windows_vm_nic" {
  name                = "windowssolaborate"
  resource_group_name = azurerm_resource_group.solaborate-rg.name
  location            = azurerm_resource_group.solaborate-rg.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}
