variable "environment" {
  description = "Environment Identifier for dev/test/prod"
  default     = ""
}

variable accountName {
  description = "Account name eg: Axway, Rnch etc"
  type = string
}

variable "availability_zones" {
  description = "List of AZ names"
  type = list(string)
  default = ["us-east-1a","us-east-1b","us-east-1c"]
}


variable "region" {
  description = "Region Identifier. e.g. us-east-1"
  type        = string
  default     = ""
}

########======================================##########
variable "instance_type" {
  description = "aws instance type and class"
  type        = string
}

variable "common_tags" {
  description = "Implements the common tags scheme"
  type        = map(string)
}

variable "allowed_ranges" {
  description = "Allowed ranges that can access the cluster"
  type        = list(any)
}

variable "az_identifier" {
  type = list(string)
  default = ["1a","1b","1c","1d"]
}

variable "template-file" {
  type    = string
  default = "cassandra.tmpl"
}

variable "ami" {
  description = "Contains information to select desired AWS AMI"
}

variable "vpc_id" {
  description = "The id for the vpc"
  type        = string
  validation {
    condition     = length(var.vpc_id) > 12 && substr(var.vpc_id, 0, 4) == "vpc-"
    error_message = "The AMI ids need to start with ami- and is at least 12 characters."
  }
}

variable "private_ips" {
  type        = list(any)
  description = "List of ips for the cassandra nodes"
}


variable "kms_key_id" {
  description = "ID of KMS key to encrypt root device volume and S3 buckets"
  type = string
  default = ""
}

variable "accountNumber" {
  type = number
  description = "Account Number"
}

variable "role_name" {
  description = "The IAM role of cassandra cluster"
  type = string
  default = ""
}

variable "security_group_id" {
  description = "The security group ID"
  type = string
  default = ""
  
}