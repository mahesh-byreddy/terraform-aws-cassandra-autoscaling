variable "region" {
   type = string
   default = "Not Valid"
}

variable "accountNumber" {
  type = string
  default = "Not Valid"
}

variable "email" {
    type = string
    default = "Not valid"
}

variable "kms_key_id" {
  description = "ID of KMS key to encrypt root device volume and S3 buckets"
  type = string
  default = ""
}