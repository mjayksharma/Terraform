resource "azurerm_resource_group" "rg" {
  name = "Terraform_webapp"
  location = "West US 2"
  tags = {
    owner = "Mritunjay"
  }
}

resource "azurerm_virtual_network" "vnet" {
  name = "${var.prefix}-vnet1"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  address_space = ["10.0.0.0/16"]
  location = "${azurerm_resource_group.rg.location}"
  tags = {
    owner = "Mritunjay"
  }
}

resource "azurerm_subnet" "merasubnet" {
  name = "${var.prefix}-subnet1"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  address_prefix = "10.0.0.0/24"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
}

resource "azurerm_network_interface" "nic1" {
  name = "${var.prefix}-nic1"
  location = "${azurerm_resource_group.rg.location}"  
  resource_group_name = "${azurerm_resource_group.rg.name}"
  ip_configuration{
    name = "${var.prefix}-config"
    subnet_id = "${azurerm_subnet.merasubnet.id}"
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_security_group" "nsg" {
  name = "${var.prefix}-mjaynsg"
  location = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  security_rule{
    name = "allow80"
    priority = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    }
  tags={
    owner = "Mritunjay"
  }
}


resource "azurerm_public_ip" "pubip" {
  name = "${var.prefix}-pubip"
  location = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  allocation_method = "Static"
  tags = {
    owner = "Mritunjay"
  }
}

resource "azurerm_virtual_machine" "vm1" {
  name = "${var.prefix}-vm1"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  location = "${azurerm_resource_group.rg.location}"
  vm_size = "Standard_B1ls"
  network_interface_ids = ["${azurerm_network_interface.nic1.id}"]

    delete_data_disks_on_termination = true
    delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = "canonical"
    offer = "UbuntuServer"
    sku = "16.04-LTS"
    version = "latest"
    }

  storage_os_disk {
    name = "myosdisk1"
    caching = "ReadWrite"
    create_option = "FromImage"
    managed_disk_type = "Standard_LRS"
    }

  os_profile {
    computer_name = "Mjayhost"
    admin_username = "Mrityunjay"
    admin_password = "Mj@ykshr$321"
    }

  os_profile_linux_config {
    disable_password_authentication = false
    }

  tags= {
    owner = "Mritunjay"
    }
}