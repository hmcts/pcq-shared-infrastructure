locals {
  ase_name = "core-compute-${var.env}"

  asp_capacity = "${var.env == "prod" || var.env == "sprod" || var.env == "aat" ? 2 : 1}"

  // I2 in prod like env, I1 everywhere else
  sku_size = "${var.env == "prod" || var.env == "sprod" || var.env == "aat" ? "I2" : "I1"}"
}

