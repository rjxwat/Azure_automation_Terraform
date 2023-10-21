terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.77.0"
    }
  }
}

provider "azurerm" {
    subscription_id = "e6c53357-7186-450c-a856-36e02ed9bee5"
    client_id = "894961f1-0942-4322-a7e5-1ff90da005f9"
    client_secret = "BY.8Q~xxpgMCHh8He~UfPrBqoClZZN52V0rTNaf-"
    tenant_id = "89095e62-86bd-45b3-9414-364373853d58"
  
  features {
    
  }
}


locals {
  resource_group="wec1"
  location="Central US"
}
 resource "azurerm_resource_group" "wec1" {
    name=local.resource_group
    location = local.location
   
 }



 resource "azurerm_virtual_network" "VNET1" {
  name                = "VNET1"
  location            = local.location
  resource_group_name = azurerm_resource_group.wec1.name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]

  subnet {
    name           = "subnet1"
    address_prefix = "10.0.0.0/20"
  }

}



