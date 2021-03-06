variable "resource_group_name" {
  description = "Resource group to contains all resource for this module"
}

variable "location" {
  default     = "southeastasia"
  description = "Default location for this module"
}

variable "logic_app_name" {
  default     = "logicapp"
  description = "Name for logic app"
}