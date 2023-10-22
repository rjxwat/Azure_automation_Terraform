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
    public_ip_address_id = azurerm_public_ip.ip_add1.id
  }
depends_on = [ azurerm_subnet.SBN1 ,azurerm_public_ip.ip_add1]
  
}


resource "azurerm_network_interface" "NIVM2" {
  name                = "NIVM2"
  location            = local.location
  resource_group_name = azurerm_resource_group.wec1.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.SBN2.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.ip_add2.id

  }
depends_on = [ azurerm_subnet.SBN2 ,azurerm_public_ip.ip_add1]
  
}



resource "azurerm_windows_virtual_machine" "VM1" {
  name                = "VM1"
  resource_group_name = local.resource_group
  location            = local.location
  size                = "Standard_D2s_v3"
  admin_username      = "VMusr1"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.NIVM1.id
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

    
  # provisioner "remote-exec" {
  #   inline = [
  #     "Install-WindowsFeature -Name Web-Server -IncludeManagementTools",
  #     "New-Item -Path 'C:\\inetpub\\wwwroot\\' -Name 'index.html' -ItemType 'file' -Value 'Hello VM1'"
  #   ]
  # }

  # provisioner "file" {
  #   source      = "webpage1.html"
  #   destination = "C:/inetpub/wwwroot/webpage1.html"
  # }

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

resource "azurerm_public_ip" "ip_add1" {
  name="ip_add1"
  resource_group_name = local.resource_group
  location = local.location
  allocation_method = "Static"
  depends_on = [ azurerm_resource_group.wec1 ]
  
}

resource "azurerm_public_ip" "ip_add2" {
  name="ip_add2"
  resource_group_name = local.resource_group
  location = local.location
  allocation_method = "Static"
  depends_on = [ azurerm_resource_group.wec1 ]
}


# new -----------------------------------------------------------new

resource "azurerm_storage_account" "store" {
  name                     = "storage1gxp"
  resource_group_name      = local.resource_group
  location                 = local.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  depends_on = [ azurerm_resource_group.wec1  ]
}

resource "azurerm_storage_container" "data" {
  name                  = "data"
  storage_account_name  = azurerm_storage_account.store.name
  container_access_type = "blob"

  depends_on=[
    azurerm_storage_account.store
    ]
}
# --------------------------------------------------storage 2
resource "azurerm_storage_account" "store2" {
  name                     = "storage2gxp"
  resource_group_name      = local.resource_group
  location                 = local.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  depends_on = [ azurerm_resource_group.wec1  ]
}

resource "azurerm_storage_container" "data2" {
  name                  = "data2"
  storage_account_name  = azurerm_storage_account.store2.name
  container_access_type = "blob"

  depends_on=[
    azurerm_storage_account.store2
    ]
}

# Here we are uploading our IIS Configuration script as a blob
# to the Azure storage account

resource "azurerm_storage_blob" "IIS_config" {
  name                   = "IIS_Config.ps1"
  storage_account_name   = azurerm_storage_account.store.name
  storage_container_name = azurerm_storage_container.data.name
  type                   = "Block"
  source                 = "IIS_Config.ps1"

   depends_on=[azurerm_storage_container.data]
}

resource "azurerm_storage_blob" "IIS_config2" {
  name                   = "IIS_Config2.ps1"
  storage_account_name   = azurerm_storage_account.store2.name
  storage_container_name = azurerm_storage_container.data2.name
  type                   = "Block"
  source                 = "IIS_Config2.ps1"

   depends_on=[azurerm_storage_container.data2]
}

resource "azurerm_virtual_machine_extension" "vm_extension1" {
  name                 = "vm_extension1"
  virtual_machine_id   = azurerm_windows_virtual_machine.VM1.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"
  depends_on = [
    azurerm_storage_blob.IIS_config
  ]
  settings = <<SETTINGS
    {
        "fileUris": ["https://${azurerm_storage_account.store.name}.blob.core.windows.net/data/IIS_Config.ps1"],
          "commandToExecute": "powershell -ExecutionPolicy Unrestricted -file IIS_Config.ps1"     
    }
SETTINGS

}

resource "azurerm_virtual_machine_extension" "vm_extension25" {
  name                 = "vm_extension25"
  virtual_machine_id   = azurerm_windows_virtual_machine.VM2.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"
  depends_on = [
    azurerm_storage_blob.IIS_config2
  ]
  settings = <<SETTINGS
    {
        "fileUris": ["https://${azurerm_storage_account.store2.name}.blob.core.windows.net/data2/IIS_Config2.ps1"],
          "commandToExecute": "powershell -ExecutionPolicy Unrestricted -file IIS_Config2.ps1"     
    }
SETTINGS

}

# load balancer-------------------Rip me 
resource "azurerm_network_security_group" "security" {
  name                = "security"
  location            = local.location
  resource_group_name = local.resource_group

# We are creating a rule to allow traffic on port 80
  security_rule {
    name                       = "Allow_HTTP"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  depends_on = [ azurerm_network_interface.NIVM1,azurerm_network_interface.NIVM2 ]
}

resource "azurerm_subnet_network_security_group_association" "association" {
  subnet_id                 = azurerm_subnet.SBN1.id
  network_security_group_id = azurerm_network_security_group.security.id
  depends_on = [
    azurerm_network_security_group.security
  ]
}

resource "azurerm_subnet_network_security_group_association" "association2" {
  subnet_id                 = azurerm_subnet.SBN2.id
  network_security_group_id = azurerm_network_security_group.security.id
  depends_on = [
    azurerm_network_security_group.security
  ]
}
