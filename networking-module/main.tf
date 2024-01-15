terraform {
    required_providers {
        azurerm = {
            source  = "hashicorp/azurerm"
            version = "=3.0.0"
        }
    }
}

resource "azurerm_resource_group" "networking" {
    name = var.resource_group_name
    location = var.location
}

resource "azurerm_virtual_network" "aks_vnet" {
    name                = "aks-vnet"
    address_space       = var.vnet_address_space
    location            = azurerm_resource_group.networking.location
    resource_group_name = azurerm_resource_group.networking.name
}

resource "azurerm_subnet" "control_plane_subnet" {
    name                 = "control-plane-subnet"
    resource_group_name  = azurerm_resource_group.networking.name
    virtual_network_name = azurerm_virtual_network.aks_vnet.name
    address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "worker_node_subnet" {
    name                 = "worker-node-subnet"
    resource_group_name  = azurerm_resource_group.networking.name
    virtual_network_name = azurerm_virtual_network.aks_vnet.name
    address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_security_group" "aks_nsg" {
    name                = "aks-nsg"
    location            = azurerm_resource_group.networking.location
    resource_group_name = azurerm_resource_group.networking.name
}

resource "azurerm_network_security_rule" "kube_apiserver" {
    name                        = "kube-apiserver-rule"
    priority                    = 1001
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "443"
    source_address_prefix       = "90.193.197.24"
    destination_address_prefix  = "*"
    resource_group_name         = azurerm_resource_group.networking.name
    network_security_group_name = azurerm_network_security_group.aks_nsg.name
}

resource "azurerm_network_security_rule" "ssh" {
    name                        = "ssh-rule"
    priority                    = 1002
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "22"
    source_address_prefix       = "90.193.197.24"
    destination_address_prefix  = "*"
    resource_group_name         = azurerm_resource_group.networking.name
    network_security_group_name = azurerm_network_security_group.aks_nsg.name
}