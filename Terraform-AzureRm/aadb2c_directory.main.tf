// provider 
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "=3.60.0"
    }
  }
}


provider "azurerm" {
  version = "=3.0.0"
  features {}
}

resource "azurerm_resource_group" "example" {
    name = "example-b2c-tenant-rg"
    location = "West US 2"
  
}



resource "azurerm_aadb2c_directory" "example" {
    country_code = "US"
    data_residency_location = "United States"
    display_name = "example-b2c-tenant" 
    domain_name = "exampleb2ctenatn.onmicrosoft.com"
    resource_group_name = azurerm_resource_group.example.name 
    sku_name = "PremiumP1"
}