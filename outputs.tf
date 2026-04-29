output "env" {
  value = var.env
}

output "id" {
  value = azurerm_monitor_action_group.pcq-loader-failure-action-group-slack.id
}