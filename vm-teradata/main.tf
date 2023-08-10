provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "teradata-vm-example"
  location = "eastus"
}

resource "azurerm_virtual_network" "example" {
  name                = "teradata-vnet-example"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "example" {
  name                 = "teradata-subnet-example"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_interface" "example" {
  name                = "teradata-nic-example"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "teradata-nic-ipconfig-example"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "example" {
  name                  = "teradata-vm-example"
  location              = azurerm_resource_group.example.location
  resource_group_name   = azurerm_resource_group.example.name
  network_interface_ids = [azurerm_network_interface.example.id]
  vm_size               = "Standard_DS2_v2"

  storage_image_reference {
    publisher = "teradata"
    offer     = "teradata-database"
    sku       = "td-byol"
    version   = "latest"
  }

  os_profile {
    computer_name  = "teradata-vm"
    admin_username = "adminuser"
    admin_password = "Password123!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  provisioner "remote-exec" {
    inline = [
      "echo Teradata installation commands here"
    ]
  }
}
