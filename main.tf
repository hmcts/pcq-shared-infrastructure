resource "azurerm_resource_group" "rg" {
  name     = "${var.product}-${var.env}"
  location = var.location
}

locals {
  tags = merge(var.common_tags,
    tomap({ "Team Contact" = "#pcq" })
  )
}
