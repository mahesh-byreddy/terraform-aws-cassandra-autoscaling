variable "environment" {
  description = "Environment Identifier for dev/test/prod"
  type = string
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


variable accountNumber {
  description = "The AWS account ID"
  type    = string
  default = ""
}


variable accountName {
  description = "Account name eg: Axway, Rnch etc"
  type = string
  default = ""
}

variable "availability_zones" {
  description = "List of AZ names"
  type = list(string)
  default = ["us-east-1a","us-east-1b","us-east-1c"]
}


###=============Module Cassandra variables==============#####
variable "instance_type" {
  description = "aws instance type and class"
  type        = string
  default = ""
}

variable "common_tags" {
  description = "Implements the common tags scheme"
  type        = map(string)
  default = {
    "createdBy" = "Terraform"
  }
}

variable "allowed_ranges" {
  description = "Allowed ranges that can access the cluster"
  type        = list(any)
  default = [ ]
  
}

variable "template-file" {
  type    = string
  default = "cassandra.tmpl"
  description = "The template file name"
}

variable "ami" {
  description = "Contains information to select desired AWS AMI"
  type = string
  default = ""
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
  description = "List of ips for the cassandra nodes"
  type        = list(string)
  default = [ "not_valid" ]
  
}

variable "az_identifier" {
  description = "The Avaialbility zone identifier. Used to tag resources"
  type = list(string)
  default = ["1a","1b","1c"]
}


variable "sns_topic_arn" {
  description = "sns topic arn to push cloudwatch alerts"
  type = string
  default = ""
}

variable "kms_key_id" {
  description = "ID of KMS key to encrypt root device volume and S3 buckets"
  type = string
  default = ""
}

variable "email" {
    description = "The email to send notifications to"
    type = string
    default = "Not valid"
}

