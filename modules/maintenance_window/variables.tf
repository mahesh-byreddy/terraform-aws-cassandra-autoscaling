variable "accountName" {
  description = "The name of the account"
  type = string
  default = "not valid"
}

variable "environment" {
  description = "Environment Identifier for dev/test/prod"
  default     = ""
}
