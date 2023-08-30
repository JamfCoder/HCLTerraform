
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

// Create an SQL Server
resource "azurerm_sql_server" "example" {
  name                         = "demo-mssql-server"
  resource_group_name          = data.azurerm_resource_group.example.name
  location                     = data.azurerm_resource_group.example.location
  version                      = "12.0"
  administrator_login          = "adminuser"
  administrator_login_password = "password"
}

// Create a database in the SQL Server

resource "azurerm_sql_database" "example" {
  name                = "demo-mssql-database"
  resource_group_name = data.azurerm_resource_group.example.name
  location            = data.azurerm_resource_group.example.location
  server_name         = azurerm_sql_server.example.name
  edition             = "Standard"
  collation           = "SQL_Latin1_General_CP1_CI_AS"
  requested_service_objective_name = "S0"
}

resource "azurerm_sql_firewall_rule" "example" {
  name                = "FirewallRule1"
  resource_group_name = data.azurerm_resource_group.example.name
  server_name         = azurerm_sql_server.example.name
  start_ip_address    = "IP_ADDRESS_TO_ALLOW"
  end_ip_address      = "IP_ADDRESS_TO_ALLOW"
}
// create app service 

resource "azurerm_app_service_plan" "appserviceplan" {
    name                = "demo-app-service-plan"
    location            = data.azurerm_resource_group.example.location
    resource_group_name = data.azurerm_resource_group.example.name
    kind                = "Windows"
    reserved            = false
  
    sku {
      tier = "Standard"
      size = "S1"
    }
}
  

resource "azurerm_app_service" "appservice" {
    name                = "demo-bookstoreapi"
    location            = data.azurerm_resource_group.example.location
    resource_group_name = data.azurerm_resource_group.example.name
    app_service_plan_id = azurerm_app_service_plan.appserviceplan.id

    connection_string {
    name  = "demo-mssql-database"
    type  = "SQLServer"
    value = "serverconnectionstring" 
  }
  
}