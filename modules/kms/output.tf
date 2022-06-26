output "kms_key_id" {
  value = aws_kms_key.cassandra-kms-key.key_id
}