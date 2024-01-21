variable "client_id" {
    description = "Azure client ID"
    type        = string
    sensitive   = true
}

variable "client_secret" {
    description = "Azure client secret"
    type        = string
    sensitive   = true
}

variable "subscription_id" {
    description = "Azure subscription ID"
    type        = string
}

variable "tenant_id" {
    description = "Azure tenant ID"
    type        = string
}

variable "module_location" {
    description = "Location of modules"
    type        = string
    default     = "UK South"
}
