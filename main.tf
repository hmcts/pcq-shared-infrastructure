provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.product}-${var.env}"
  location = var.location
}

locals {
  tags = merge(var.common_tags,
      map("Team Contact", "#rpe")
    )
}
