provider "azurerm" {
  version = "2.25.0"
  features {}
}

provider "azurerm" {
  alias           = "aks-infra"
  subscription_id = "${var.aks_infra_subscription_id}"
  features {}
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
