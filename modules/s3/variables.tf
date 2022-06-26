variable accountNumber { 
  type = string 
}

variable bucketName    { 
  type = string 
}

variable loggingBucket { 
  type = string 
}

variable "kms_key_id" {
  description = "ID of KMS key to encrypt root device volume and S3 buckets"
  type = string
  default = ""
}

variable isLoggingBucket { 
  type = bool
  default = false
}

variable accountName {
  type = string
  default = "Not Valid"
}