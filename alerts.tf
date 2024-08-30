module "pcq-consolidation-fail-action-group-slack-email" {
  source                 = "git@github.com:hmcts/cnp-module-action-group"
  location               = "global"
  env                    = var.env
  resourcegroup_name     = azurerm_resource_group.rg.name
  action_group_name      = "PCQ Consolidation Fail Slack Email Alert - ${var.env}"
  short_name             = "pcq-alert"
  email_receiver_name    = "PCQ Consolidation Service Failure Alert"
  email_receiver_address = data.azurerm_key_vault_secret.pcqFailureAlertEmail.value
}

module "pcq-consolidation-service-failures-alert" {
  source               = "git@github.com:hmcts/cnp-module-metric-alert"
  location             = "uksouth"
  app_insights_name    = "pcq-${var.env}"
  alert_name           = "pcq-consolidation-service-${var.env}-failures-alert"
  alert_desc           = "Triggers when pcq consolidation service fail to run"
  app_insights_query   = "traces | where message contains 'Error executing Consolidation service'"
  custom_email_subject = "Alert: PCQ Consolidation Service failure in pcq-${var.env}"
  ##run every 6 hrs for early alert
  frequency_in_minutes = "360"
  # window of 1 day as data extract needs to run daily
  time_window_in_minutes     = "1440"
  severity_level             = "2"
  action_group_name          = module.pcq-consolidation-fail-action-group-slack-email.action_group_name
  trigger_threshold_operator = "GreaterThan"
  trigger_threshold          = "0"
  resourcegroup_name         = azurerm_resource_group.rg.name
  enabled                    = var.enable_consolidation_alerts
  common_tags                = var.common_tags
}

module "pcq-disposer-fail-action-group-slack" {
  source                 = "git@github.com:hmcts/cnp-module-action-group"
  location               = "global"
  env                    = var.env
  resourcegroup_name     = azurerm_resource_group.rg.name
  action_group_name      = "PCQ Disposer Fail Slack Alert - ${var.env}"
  short_name             = "pcq-disposer"
  email_receiver_name    = "PCQ Disposer Service Failure Alert"
  email_receiver_address = data.azurerm_key_vault_secret.pcqFailureAlertEmail.value
}

module "pcq-disposer-service-failures-alert" {
  source               = "git@github.com:hmcts/cnp-module-metric-alert"
  location             = "uksouth"
  app_insights_name    = "pcq-${var.env}"
  alert_name           = "pcq-disposer-service-${var.env}-failures-alert"
  alert_desc           = "Triggers when pcq disposer service fail to run"
  app_insights_query   = "traces | where message contains 'Error executing PCQ Disposer service' | where toint(dayofweek(timestamp)/1d) < 5"
  custom_email_subject = "Alert: PCQ Disposer Service failure in pcq-${var.env}"
  ##run every day as disposer runs only once
  frequency_in_minutes = var.disposer_frequency_in_minutes
  # window of 1 day as disposer run daily once
  time_window_in_minutes     = var.disposer_time_window_in_minutes
  severity_level             = "2"
  action_group_name          = module.pcq-disposer-fail-action-group-slack.action_group_name
  trigger_threshold_operator = "GreaterThan"
  trigger_threshold          = "0"
  resourcegroup_name         = azurerm_resource_group.rg.name
  enabled                    = var.enable_disposer_alerts
  common_tags                = var.common_tags
}

module "pcq-disposer-summary-action-group-slack" {
  source                 = "git@github.com:hmcts/cnp-module-action-group"
  location               = "global"
  env                    = var.env
  resourcegroup_name     = azurerm_resource_group.rg.name
  action_group_name      = "PCQ Disposer Summary Slack Alert - ${var.env}"
  short_name             = "pcq-sum"
  email_receiver_name    = "PCQ Disposer Service Summary Alert"
  email_receiver_address = data.azurerm_key_vault_secret.pcqDisposerSummaryAlertEmail.value
}

module "pcq-disposer-service-summary-alert" {
  source               = "git@github.com:hmcts/cnp-module-metric-alert"
  location             = "uksouth"
  app_insights_name    = "pcq-${var.env}"
  alert_name           = "pcq-disposer-service-${var.env}-summary-alert"
  alert_desc           = "Alert when PCQ disposer run"
  app_insights_query   = "traces | where message contains 'Deleting old PCQs for real... number to delete' | where toint(dayofweek(timestamp)/1d) < 5"
  custom_email_subject = "Alert: PCQ Disposer Service Summary in pcq-${var.env}"
  ##run every day as disposer runs only once
  frequency_in_minutes = var.disposer_frequency_in_minutes
  # window of 1 day as disposer run daily once
  time_window_in_minutes     = var.disposer_time_window_in_minutes
  severity_level             = "2"
  action_group_name          = module.pcq-disposer-summary-action-group-slack.action_group_name
  trigger_threshold_operator = "GreaterThan"
  trigger_threshold          = "0"
  resourcegroup_name         = azurerm_resource_group.rg.name
  enabled                    = var.enable_summary_alerts
  common_tags                = var.common_tags
}

module "pcq-consolidation-summary-action-group-slack" {
  source                 = "git@github.com:hmcts/cnp-module-action-group"
  location               = "global"
  env                    = var.env
  resourcegroup_name     = azurerm_resource_group.rg.name
  action_group_name      = "PCQ Consolidation Summary Slack Alert - ${var.env}"
  short_name             = "pcq-conso"
  email_receiver_name    = "PCQ Consolidation Service Summary Alert"
  email_receiver_address = data.azurerm_key_vault_secret.pcqDisposerSummaryAlertEmail.value
}

module "pcq-consolidation-service-summary-alert" {
  source               = "git@github.com:hmcts/cnp-module-metric-alert"
  location             = "uksouth"
  app_insights_name    = "pcq-${var.env}"
  alert_name           = "pcq-consolidation-service-${var.env}-summary-alert"
  alert_desc           = "Alert when PCQ consolidation run and present summary"
  app_insights_query   = "traces | where message contains 'Consolidation Service Case Matching Summary :'"
  custom_email_subject = "Alert: PCQ Consolidation Service Summary in pcq-${var.env}"
  ##run every day as consolidation runs only once
  frequency_in_minutes = var.disposer_frequency_in_minutes
  # window of 1 day as consolidation run daily once
  time_window_in_minutes     = var.disposer_time_window_in_minutes
  severity_level             = "2"
  action_group_name          = module.pcq-consolidation-summary-action-group-slack.action_group_name
  trigger_threshold_operator = "GreaterThan"
  trigger_threshold          = "0"
  resourcegroup_name         = azurerm_resource_group.rg.name
  enabled                    = var.enable_summary_alerts
  common_tags                = var.common_tags
}

module "pcq-loader-failure-action-group-slack" {
  source                 = "git@github.com:hmcts/cnp-module-action-group"
  location               = "global"
  env                    = var.env
  resourcegroup_name     = azurerm_resource_group.rg.name
  action_group_name      = "PCQ Loader Failure Slack Alert - ${var.env}"
  short_name             = "pcq-loader"
  email_receiver_name    = "PCQ Loader Service Failure Alert"
  email_receiver_address = data.azurerm_key_vault_secret.pcqFailureAlertEmail.value
}

module "pcq-loader-service-failure-alert" {
  source               = "git@github.com:hmcts/cnp-module-metric-alert"
  location             = "uksouth"
  app_insights_name    = "pcq-${var.env}"
  alert_name           = "pcq-loader-service-${var.env}-failure-alert"
  alert_desc           = "Alert when PCQ Loader Service fail to run"
  app_insights_query   = "traces | where message contains 'Error executing Pcq Loader'"
  custom_email_subject = "Alert: PCQ Loader Service failure in pcq-${var.env}"
  ##run every 15 mins as Loader runs every 15 mins
  frequency_in_minutes = "15"
  # window of 15mins
  time_window_in_minutes     = "15"
  severity_level             = "2"
  action_group_name          = module.pcq-loader-failure-action-group-slack.action_group_name
  trigger_threshold_operator = "GreaterThan"
  trigger_threshold          = "0"
  resourcegroup_name         = azurerm_resource_group.rg.name
  enabled                    = var.enable_loader_alerts
  common_tags                = var.common_tags
}