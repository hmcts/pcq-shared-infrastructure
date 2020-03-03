module "pcq-vault" {
  source                     = "git@github.com:hmcts/cnp-module-key-vault?ref=master"
  name                       = "pcq-${var.env}"
  product                    = "${var.product}"
  env                        = "${var.env}"
  tenant_id                  = "${var.tenant_id}"
  object_id                  = "${var.jenkins_AAD_objectId}"
  resource_group_name        = "${azurerm_resource_group.rg.name}"

  # dcd_group_pcq_v2 group object ID
  product_group_object_id    = "731343b8-be79-4a97-b14e-60be786ad393"
  common_tags                = "${var.common_tags}"
  managed_identity_object_id = "${var.managed_identity_object_id}"
}

data "azurerm_key_vault" "pcq_key_vault" {
  name                = "pcq-${var.env}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
}

output "vaultName" {
  value = "${module.pcq-vault.key_vault_name}"
}
