resource "aws_sns_topic" "cassandra_nodes_alerts" {
 
  name              = "cassandra_nodes_alerts"
  kms_master_key_id = "arn:aws:kms:us-east-1:${var.accountNumber}:key/${var.kms_key_id}"
  display_name      = "Axway-Cassandra-ALERT"

  policy = <<EOT
    {
  "Version": "2008-10-17",
  "Id": "__default_policy_ID",
  "Statement": [
    {
      "Sid": "Cassandra_sns_topic",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": [
        "SNS:Publish",
        "SNS:RemovePermission",
        "SNS:SetTopicAttributes",
        "SNS:DeleteTopic",
        "SNS:ListSubscriptionsByTopic",
        "SNS:GetTopicAttributes",
        "SNS:Receive",
        "SNS:AddPermission",
        "SNS:Subscribe"
      ],
      "Resource": "arn:aws:sns:${var.region}:${var.accountNumber}:cassandra_nodes_alerts",
      "Condition": {
        "StringEquals": {
          "AWS:SourceOwner": ${var.accountNumber}
        }
      }
    },
    {
      "Sid": "__console_sub_0",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": [
        "SNS:Subscribe",
        "SNS:Receive"
      ],
      "Resource": "arn:aws:sns:${var.region}:${var.accountNumber}:cassandra_nodes_alerts"
    }
  ]
}
  EOT
}

#resource "aws_sns_topic_subscription" "cassandra_nodes_alerts_target" {
  
 # depends_on = [aws_sns_topic.cassandra_nodes_alerts]
  #topic_arn = "arn:aws:sns:${var.region}:${var.accountNumber}:cassandra_nodes_alerts"
  #protocol  = "email"
  #endpoint  = var.email
#}