terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.77.0"
    }
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



