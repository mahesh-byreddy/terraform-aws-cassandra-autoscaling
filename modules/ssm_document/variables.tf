variable "common_tags" {
  description = "Implements the common tags scheme"
  type        = map(string)
}

variable "private_ips" {
  type        = list(any)
  description = "List of ips for the cassandra nodes"
}

variable "axway_user_name" {
  type = string
  description = "User that Axway uses to connect to cassandra"
}

variable "environment" {
  description = "Environment Identifier for dev/test/prod"
  default     = ""
}