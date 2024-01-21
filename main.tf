terraform {
    required_providers {
        azurerm = {
            source  = "hashicorp/azurerm"
            version = "=3.0.0"
        }
    }
}

provider "azurerm" {
    skip_provider_registration = true
    features                   {}
    client_id                  = var.client_id
    client_secret              = var.client_secret
    subscription_id            = var.subscription_id
    tenant_id                  = var.tenant_id
}

module "networking_module" {
    source              = "./networking-module"
    resource_group_name = "networking-resource-group"
    location            = var.module_location
    vnet_address_space  = ["10.0.0.0/16"]
}

module "cluster_module" {
    source                      = "./aks-cluster-module"
    aks_cluster_name            = "terraform-aks-cluster"
    cluster_location            = var.module_location
    dns_prefix                  = "myaks-project"
    kubernetes_version          = "1.26.6"
    service_principal_client_id = var.client_id
    service_principal_secret    = var.client_secret
    vnet_id                     = module.networking_module.vnet_id
    control_plane_subnet_id     = module.networking_module.control_plane_subnet_id
    worker_node_subnet_id       = module.networking_module.worker_node_subnet_id
    resource_group_name         = module.networking_module.resource_group_name
    depends_on                  = [module.networking_module]
}
