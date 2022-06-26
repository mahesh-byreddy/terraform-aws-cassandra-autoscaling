variable "environment" {
  description = "Environment Identifier for dev/test/prod"
  default     = ""
}

variable "region" {
  description = "Region Identifier. e.g. us-east-1"
  type        = string
  default     = ""
}


variable "drRegion" {
   type = string
   default = "us-west-2"
}


variable "vpc_id" {
  description = "The id for the vpc"
  type        = string
  validation {
    condition     = length(var.vpc_id) > 12 && substr(var.vpc_id, 0, 4) == "vpc-"
    error_message = "The AMI ids need to start with ami- and is at least 12 characters."
  }
}
