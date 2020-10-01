provider "azurerm" {
  version = "2.29.0"
  features {}
  skip_provider_registration = true
}

provider "azurerm" {
  alias           = "aks-infra"
  subscription_id = "${var.aks_infra_subscription_id}"
  features {}
  skip_provider_registration = true
}

provider "azurerm" {
  alias           = "aks-preview"
  subscription_id = "${var.aks_preview_subscription_id}"
  features {}
}

provider "azurerm" {
  alias           = "mgmt"
  subscription_id = "${var.mgmt_subscription_id}"
  features {}
}
