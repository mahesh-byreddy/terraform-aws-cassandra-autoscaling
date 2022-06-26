output "sns_topic_arn" {
  value = aws_sns_topic.cassandra_nodes_alerts.id
}