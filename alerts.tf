locals {
  alert_resource_group_name = "pcq-shared-${var.env}"
}

module "pcq-consolidation-fail-action-group-slack" {
  source   = "git@github.com:hmcts/cnp-module-action-group"
  location = "global"
  env      = var.env
  resourcegroup_name     = local.alert_resource_group_name
  action_group_name      = "PCQ Consolidation Fail Slack Alert - ${var.env}"
  short_name             = "pcq-alert"
  email_receiver_name    = "PCQ Consolidation Service Failure Alert"
  email_receiver_address = "alerts-monitoring-bbac7vjnaaknbv4uixozinjim@hmcts-reform.slack.com"
}

module "pcq-consolidation-service-failures-alert" {
  source                     = "git@github.com:hmcts/cnp-module-metric-alert"
  location                   = var.appinsights_location
  app_insights_name          = "pcq-${var.env}"
  alert_name                 = "pcq-consolidation-service-${var.env}-failures-alert"
  alert_desc                 = "Triggers when pcq consolidation service fail to run"
  app_insights_query         = "traces | where message !contains 'Error executing Consolidation service' or
  message contains 'Completed the consolidation service job successfully'"
  custom_email_subject       = "Alert: PCQ Consolidation Service failure in pcq-${var.env}"
  ##run every 1 hrs for early alert
  frequency_in_minutes       = 60
  # window of 1 day as data extract needs to run daily
  time_window_in_minutes     = 1440
  severity_level             = "2"
  action_group_name          = module.pcq-consolidation-fail-action-group-slack.action_group_name
  trigger_threshold_operator = "GreaterThan"
  trigger_threshold          = 0
  resourcegroup_name         = local.alert_resource_group_name
  enabled                    = var.enable_alerts
  common_tags                = var.common_tags
}