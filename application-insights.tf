module "application_insights" {
  source = "git@github.com:hmcts/terraform-module-application-insights?ref=4.x"

  env                 = var.env
  product             = var.product
  location            = var.appinsights_location
  application_type    = var.application_type
  resource_group_name = azurerm_resource_group.rg.name
  common_tags         = var.common_tags
}

moved {
  from = azurerm_application_insights.appinsights
  to   = module.application_insights.azurerm_application_insights.this
}
resource "azurerm_key_vault_secret" "appInsights-InstrumentationKey" {
  name         = "AppInsightsInstrumentationKey"
  value        = module.application_insights.instrumentation_key
  key_vault_id = module.pcq-vault.key_vault_id
}

resource "azurerm_key_vault_secret" "app_insights_connection_string" {
  name         = "app-insights-connection-string"
  value        = module.application_insights.connection_string
  key_vault_id = module.pcq-vault.key_vault_id
}
