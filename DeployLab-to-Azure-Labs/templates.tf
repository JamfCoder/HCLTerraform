
data "azurerm_resource_group" "example" {
  name = "TestResource"
}

resource "azurerm_resource_group" "azurecelium" {
  name = "azurecelium"
  location = "canadacentral"
}

resource "azurerm_virtual_network" "azurecelium" {
  name                = "azurecelium"
  address_space       = ["192.168.10.0/24"]
  location            = azurerm_resource_group.azurecelium.location
  resource_group_name = azurerm_resource_group.azurecelium.name
}

resource "azurerm_subnet" "azurecelium" {
  name                 = "azurecelium"
  resource_group_name  = azurerm_resource_group.azurecelium.name
  virtual_network_name = azurerm_virtual_network.azurecelium.name
  address_prefixes       = ["192.168.10.0/24"]
}

resource "azurerm_kubernetes_cluster" "azurecilium" {
  name                = "azurecelium"
  location            = azurerm_resource_group.azurecelium.location
  resource_group_name = azurerm_resource_group.azurecelium.name
  dns_prefix          = "azurecelium"
  default_node_pool {
    name       = "azurecelium"
    node_count = 2
    vm_size    = "Standard_D2_v2"
    vnet_subnet_id = azurerm_subnet.azurecelium.id
  }
  identity {
    type = "SystemAssigned"
  }
  network_profile {
    pod_cidr            = "10.10.0.0/22"
    service_cidr        = "10.20.0.0/24"
    dns_service_ip      = "10.20.0.10"
    network_plugin      = "azure"
    network_plugin_mode = "overlay"
    ebpf_data_plane     = "cilium"
  }
}
