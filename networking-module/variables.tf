variable "resource_group_name" {
    description = "name of resource group"
    type        = string
}

variable "location" {
    description = "location of resources"
    type        = string
}

variable "vnet_address_space" {
    description = "Address space for the Virtual Network (VNet)."
    type        = list(string)
    default     = ["10.0.0.0/16"]
}
