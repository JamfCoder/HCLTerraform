provider "azurerm" {
  version = "=3.60.0"
  features {}
}

data "azurerm_resource_group" "example" {
  name = "TestResource"
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