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


resource "azurerm_virtual_network" "VNet1" {
  name                = "VNet1"
  address_space       = ["10.0.0.0/16"]
  location            = local.location
  resource_group_name = azurerm_resource_group.wec1.name
}

resource "azurerm_subnet" "SBN1" {
  name                 = "SBN1"
  resource_group_name  = azurerm_resource_group.wec1.name
  virtual_network_name = azurerm_virtual_network.VNet1.name
  address_prefixes     = ["10.0.0.0/17"]

  depends_on = [ azurerm_virtual_network.VNet1 ]
}

resource "azurerm_subnet" "SBN2" {
  name                 = "SBN2"
  resource_group_name  = azurerm_resource_group.wec1.name
  virtual_network_name = azurerm_virtual_network.VNet1.name
  address_prefixes     = ["10.0.128.0/17"]

  depends_on = [ azurerm_virtual_network.VNet1 ]
}



resource "azurerm_network_interface" "NIVM1" {
  name                = "NIVM1"
  location            = local.location
  resource_group_name = azurerm_resource_group.wec1.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.SBN1.id
    private_ip_address_allocation = "Dynamic"
  }
depends_on = [ azurerm_subnet.SBN1 ]
  
}


resource "azurerm_network_interface" "NIVM2" {
  name                = "NIVM2"
  location            = local.location
  resource_group_name = azurerm_resource_group.wec1.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.SBN2.id
    private_ip_address_allocation = "Dynamic"
  }
depends_on = [ azurerm_subnet.SBN2 ]
  
}



resource "azurerm_windows_virtual_machine" "VM1" {
  name                = "VM1"
  resource_group_name = local.resource_group
  location            = local.location
  size                = "Standard_D2s_v3"
  admin_username      = "VMusr1"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.NIVM1.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
depends_on = [ azurerm_network_interface.NIVM1 ]

}

resource "azurerm_windows_virtual_machine" "VM2" {
  name                = "VM2"
  resource_group_name = local.resource_group
  location            = local.location
  size                = "Standard_D2s_v3"
  admin_username      = "VMusr2"
  admin_password      = "New@@a@@word123?"
  network_interface_ids = [
    azurerm_network_interface.NIVM2.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
depends_on = [ azurerm_network_interface.NIVM2 ]

}
