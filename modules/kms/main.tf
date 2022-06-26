resource "aws_kms_key" "cassandra-kms-key" {
  description              = "KMS Key used for s3 bucket and EBS root volume encryption"
  enable_key_rotation      = true
  deletion_window_in_days  = 7
  is_enabled               = true
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  policy                   = data.aws_iam_policy_document.CMK_Policy.json
}

resource "aws_kms_alias" "cassandra-kms-key" {
  name          = "alias/${var.alias}"
  target_key_id = aws_kms_key.cassandra-kms-key.key_id
}


data "aws_iam_policy_document" "CMK_Policy" {
  statement {
    sid       = "Enable IAM User Permissions"
    actions   = ["kms:*"]
    resources = ["*"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.accountNumber}:root"]
    }
  }
  statement {
    sid       = "Enable Deployer Role Ownership"
    actions   = [
      "kms:Create*",
      "kms:Describe*",
      "kms:Enable*",
      "kms:List*",
      "kms:Put*",
      "kms:Update*",
      "kms:Revoke*",
      "kms:Disable*",
      "kms:Get*",
      "kms:Delete*",
      "kms:ScheduleKeyDeletion",
      "kms:CancelKeyDeletion",
      "kms:Decrypt",
      "kms:Encrypt",
      "kms:ReEncrypt*",
      "kms:RevokeGrant",
      "kms:GenerateDataKey",
      "kms:GenerateDataKeyWithoutPlaintext",
      "kms:DescribeKey"
    ]
    resources = ["*"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.accountNumber}:role/LOBAdmin",
                     "arn:aws:iam::${var.accountNumber}:role/devops-ss-deployment-role"]
    }
  }

 
   
}

#  statement {
#     sid = "Allow service-linked role use of the customer managed key"
#     principals  {
#         type = "AWS"
#         identifiers =  [ "arn:aws:iam::${var.accountNumber}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling" ]
#     }
#     actions = [
#           "kms:Encrypt",
#          "kms:Decrypt",
#          "kms:ReEncrypt*",
#          "kms:GenerateDataKey*",
#           "kms:DescribeKey"
#      ]
#     resources = ["*"]
    
#   }

# statement {
#     sid = "Allow attachment of persistent resources"
#     principals  {
#         type = "AWS"
#         identifiers = [ "arn:aws:iam::${var.accountNumber}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling" ]
#     }
#     actions = [
#           "kms:createGrant"
#      ]
#     resources = ["*"]  
#   }
# statement {
#     sid       = "Allow Grants for automation role"
#     actions   = [
#       "kms:CreateGrant",
#       "kms:ListGrants",
#       "kms:RetireGrant"
#     ]
#     resources = ["arn:aws:kms:us-east-1:232791766003:key/*"]
#     principals {
#       type        = "AWS"
#       identifiers = ["arn:aws:iam::${var.accountNumber}:role/LOBAdmin",
#                      "arn:aws:iam::${var.accountNumber}:role/devops-ss-deployment-role"]
#     }
#   }

# resource "aws_kms_grant" "kms_grant" {
#   name               = "cassandra-kms-grant"
#   key_id             = "arn:aws:kms:us-east-1:232791766003:key/c6a4fcd6-f437-42c9-a0fe-51822bff08da"
#   grantee_principal  = "arn:aws:iam::${var.accountNumber}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"
#   retiring_principal = "arn:aws:iam::${var.accountNumber}:role/devops-ss-deployment-role"
#   operations         = ["Decrypt", "ReEncryptFrom", "ReEncryptTo", "GenerateDataKey", "GenerateDataKeyWithoutPlaintext", "DescribeKey", "CreateGrant"]
#   retire_on_delete   = "true"
# }
