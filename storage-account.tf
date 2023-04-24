locals {
  storage_account_name         = "${var.product}shared${var.env}"
  mgmt_network_name            = "cft-ptl-vnet"
  mgmt_network_rg_name         = "cft-ptl-network-rg"
  
  vnet_name                    = "cft-${var.env}-vnet"
  vnet_resource_group_name     = "cft-${var.env}-network-rg"

  standard_subnets = [
    data.azurerm_subnet.jenkins_subnet.id,
    data.azurerm_subnet.aks-00-mgmt.id,
    data.azurerm_subnet.aks-01-mgmt.id,
    data.azurerm_subnet.aks-00-infra.id,
    data.azurerm_subnet.aks-01-infra.id
  ]

  preview_subnets  = var.env == "aat" ? [data.azurerm_subnet.aks-00-preview.id, data.azurerm_subnet.aks-01-preview.id] : []
  cft_prod_subnets = var.env == "prod" ? [data.azurerm_subnet.aks-00-prod.id, data.azurerm_subnet.aks-01-prod.id] : []
  sa_subnets       = concat(local.standard_subnets, local.preview_subnets, local.cft_prod_subnets)
}

// pcq blob Storage Account
module "pcq_storage_account" {
  source                   = "git@github.com:hmcts/cnp-module-storage-account?ref=master"
  env                      = var.env
  storage_account_name     = local.storage_account_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = var.location
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "ZRS"
  access_tier              = "Hot"

  // enable_blob_encryption    = true
  // enable_file_encryption    = true
  enable_https_traffic_only = true

  sftp_enabled = var.enable_sftp

  // Tags
  common_tags  = var.common_tags
  team_contact = var.team_contact
  destroy_me   = var.destroy_me

  sa_subnets = local.sa_subnets
}

resource "azurerm_storage_management_policy" "pcq_lifecycle_rules" {
  storage_account_id = module.pcq_storage_account.storageaccount_id

  rule {
    name    = "pcqExpirationRule"
    enabled = true
    filters {
      blob_types = ["blockBlob"]
    }
    actions {
      base_blob {
        tier_to_archive_after_days_since_modification_greater_than = 90
        tier_to_cool_after_days_since_modification_greater_than    = 90
        delete_after_days_since_modification_greater_than          = 90
      }
    }
  }
}

data "azurerm_virtual_network" "mgmt_vnet" {
  provider            = azurerm.mgmt
  name                = local.mgmt_network_name
  resource_group_name = local.mgmt_network_rg_name
}

data "azurerm_subnet" "jenkins_subnet" {
  provider             = azurerm.mgmt
  name                 = "iaas"
  virtual_network_name = data.azurerm_virtual_network.mgmt_vnet.name
  resource_group_name  = data.azurerm_virtual_network.mgmt_vnet.resource_group_name
}

data "azurerm_subnet" "aks-00-mgmt" {
  provider             = azurerm.mgmt
  name                 = "aks-00"
  virtual_network_name = data.azurerm_virtual_network.mgmt_vnet.name
  resource_group_name  = data.azurerm_virtual_network.mgmt_vnet.resource_group_name
}

data "azurerm_subnet" "aks-01-mgmt" {
  provider             = azurerm.mgmt
  name                 = "aks-01"
  virtual_network_name = data.azurerm_virtual_network.mgmt_vnet.name
  resource_group_name  = data.azurerm_virtual_network.mgmt_vnet.resource_group_name
}

data "azurerm_virtual_network" "aks_core_vnet" {
  provider            = azurerm.aks-infra
  name                = local.vnet_name
  resource_group_name = local.vnet_resource_group_name
}

data "azurerm_subnet" "aks-00-infra" {
  provider             = azurerm.aks-infra
  name                 = "aks-00"
  virtual_network_name = data.azurerm_virtual_network.aks_core_vnet.name
  resource_group_name  = data.azurerm_virtual_network.aks_core_vnet.resource_group_name
}

data "azurerm_subnet" "aks-01-infra" {
  provider             = azurerm.aks-infra
  name                 = "aks-01"
  virtual_network_name = data.azurerm_virtual_network.aks_core_vnet.name
  resource_group_name  = data.azurerm_virtual_network.aks_core_vnet.resource_group_name
}

data "azurerm_virtual_network" "aks_prod_vnet" {
  provider            = azurerm.aks-prod
  name                = "cft-prod-vnet"
  resource_group_name = "cft-prod-network-rg"
}

data "azurerm_subnet" "aks-00-prod" {
  provider             = azurerm.aks-prod
  name                 = "aks-00"
  virtual_network_name = data.azurerm_virtual_network.aks_prod_vnet.name
  resource_group_name  = data.azurerm_virtual_network.aks_prod_vnet.resource_group_name
}

data "azurerm_subnet" "aks-01-prod" {
  provider             = azurerm.aks-prod
  name                 = "aks-01"
  virtual_network_name = data.azurerm_virtual_network.aks_prod_vnet.name
  resource_group_name  = data.azurerm_virtual_network.aks_prod_vnet.resource_group_name
}

data "azurerm_virtual_network" "aks_preview_vnet" {
  provider            = azurerm.aks-preview
  name                = "cft-preview-vnet"
  resource_group_name = "cft-preview-network-rg"
}

data "azurerm_subnet" "aks-00-preview" {
  provider             = azurerm.aks-preview
  name                 = "aks-00"
  virtual_network_name = data.azurerm_virtual_network.aks_preview_vnet.name
  resource_group_name  = data.azurerm_virtual_network.aks_preview_vnet.resource_group_name
}

data "azurerm_subnet" "aks-01-preview" {
  provider             = azurerm.aks-preview
  name                 = "aks-01"
  virtual_network_name = data.azurerm_virtual_network.aks_preview_vnet.name
  resource_group_name  = data.azurerm_virtual_network.aks_preview_vnet.resource_group_name
}

resource "azurerm_storage_container" "pcq_containers" {
  name                  = "pcq"
  storage_account_name  = module.pcq_storage_account.storageaccount_name
  container_access_type = "private"
}

resource "azurerm_storage_container" "pcq_rejected_container" {
  name                  = "pcq-rejected"
  storage_account_name  = module.pcq_storage_account.storageaccount_name
  container_access_type = "private"
}

// pcq blob Storage Account Vault Secrets
resource "azurerm_key_vault_secret" "storage_account_name" {
  name         = "pcq-storage-account-name"
  value        = module.pcq_storage_account.storageaccount_name
  key_vault_id = data.azurerm_key_vault.pcq_key_vault.id
}

resource "azurerm_key_vault_secret" "pcq_storageaccount_primary_access_key" {
  name         = "pcq-storage-account-primary-access-key"
  value        = module.pcq_storage_account.storageaccount_primary_access_key
  key_vault_id = data.azurerm_key_vault.pcq_key_vault.id
}

resource "azurerm_key_vault_secret" "pcq_storageaccount_secondary_access_key" {
  name         = "pcq-storage-account-secondary-access-key"
  value        = module.pcq_storage_account.storageaccount_secondary_access_key
  key_vault_id = data.azurerm_key_vault.pcq_key_vault.id
}

resource "azurerm_key_vault_secret" "pcq_storageaccount_primary_connection_string" {
  name         = "pcq-storage-account-primary-connection-string"
  value        = module.pcq_storage_account.storageaccount_primary_connection_string
  key_vault_id = data.azurerm_key_vault.pcq_key_vault.id
}

resource "azurerm_key_vault_secret" "pcq_storageaccount_secondary_connection_string" {
  name         = "pcq-storage-account-secondary-connection-string"
  value        = module.pcq_storage_account.storageaccount_secondary_connection_string
  key_vault_id = data.azurerm_key_vault.pcq_key_vault.id
}
