terraform {
   required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.29.0"
    }
}
}


resource "aws_cloudformation_stack" "s3-bucket" {
  name          = var.bucketName

  parameters    = {
    pProvisionedProductName = var.bucketName
    pBucketName             = var.bucketName
    pManagedKeyID           = var.kms_key_id
    pLoggingBucketName      = var.loggingBucket
    pLogDelivery            = var.isLoggingBucket

  }

  template_body = file("${path.module}/s3-template.yaml")
}
