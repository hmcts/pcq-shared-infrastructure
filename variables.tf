variable "product" {}

variable "location" {
  default = "UK South"
}

variable "appinsights_location" {
  default     = "UK South"
  description = "Location for Application Insights"
}

variable "common_tags" {
  type = map(string)
}

variable "env" {}

variable "application_type" {
  default     = "web"
  description = "Type of Application Insights (Web/Other)"
}

variable "tenant_id" {
  description = "(Required) The Azure Active Directory tenant ID that should be used for authenticating requests to the key vault. This is usually sourced from environemnt variables and not normally required to be specified."
}

variable "jenkins_AAD_objectId" {
  description = "(Required) The Azure AD object ID of a user, service principal or security group in the Azure Active Directory tenant for the vault. The object ID must be unique for the list of access policies."
}


variable "subscription" {}

variable "mgmt_subscription_id" {}

variable "aks_infra_subscription_id" {}

variable "aks_preview_subscription_id" {}

variable "name" {
  default = false
}

variable "managed_identity_object_id" {
  default = ""
}

variable "team_contact" {
  description = "The name of your Slack channel people can use to contact your team about your infrastructure"
  default     = "#pcq-support"
}

variable "destroy_me" {
  description = "Here be dragons! In the future if this is set to Yes then automation will delete this resource on a schedule. Please set to No unless you know what you are doing"
  default     = "No"
}

variable "enable_alerts" {
  default = false
}

variable "enable_consolidation_alerts" {
  default = false
}

variable "enable_disposer_alerts" {
  default = false
}

variable "disposer_frequency_in_minutes" {
  default = 1440
}

variable "disposer_time_window_in_minutes" {
  default = 1440
}