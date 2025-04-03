variable "budget_name" {
  description = "Name of the 'Monthly' budget to be set"
  type        = string
}

variable "budget_limit" {
  description = "The monthly cost limit to be set for the budget"
  type        = string
  default     = "10"

  validation {
    condition     = can(tonumber(var.budget_limit))
    error_message = "The budget limit must be a valid number represented as a string"
  }
}

variable "budget_email_list" {
  type        = list(string)
  description = "List of Email addresses for notifications in list format"
}
