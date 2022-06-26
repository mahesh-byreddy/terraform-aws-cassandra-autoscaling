resource "aws_security_group" "cassandra_cluster_sg" {
  
  name        = "cassandra_cluster_sg"
  description = "Cassandra cluster security group controls Internode communication and access to/from vpc endpoint sgs"

    ingress {
    from_port   = 9042
    to_port     = 9042
    protocol    = "tcp"
    description = "CSQLSH port"
    cidr_blocks = var.allowed_ranges
  }

  ingress {
    from_port   = 9160
    to_port     = 9160
    protocol    = "tcp"
    description = "Cassandra Thrift port"
    cidr_blocks = var.allowed_ranges
  }

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    description = "allows traffic from the SG itself for TCP"
    self        = true
  }

  ingress {
    from_port   = 7199
    to_port     = 7199
    protocol    = "tcp"
    description = "allow traffic for TCP 7199 (JMX)"
    cidr_blocks = var.allowed_ranges
  }

  ingress {
    from_port   = 7000
    to_port     = 7000
    protocol    = "tcp"
    description = "7000 Inter-node cluster"
    cidr_blocks = var.allowed_ranges
  }

  ingress {
    from_port   = 7001
    to_port     = 7001
    protocol    = "tcp"
    description = "Inter-node cluster SSL"
    cidr_blocks = var.allowed_ranges
  }
  egress {
    from_port         = 0
    to_port           = 65535
    protocol          = "tcp"
    # tfsec:ignore:AWS009
    cidr_blocks       = [ "0.0.0.0/0" ]
    # tfsec:ignore:AWS009
    ipv6_cidr_blocks  = [ "::/0" ]
    description       = "Allow Cluster outbound TCP4"

  }

   egress {
    from_port         = 0
    to_port           = 65535
    protocol          = "udp"
    # tfsec:ignore:AWS009
    cidr_blocks       = [ "0.0.0.0/0" ]
    # tfsec:ignore:AWS009
    ipv6_cidr_blocks  = [ "::/0" ]
    description       = "Allow Cluster outbound UDP"

  }
 
  vpc_id = var.vpc_id
}




  
#   ##configure vpc endpoint sg to allow access from cassandra secondary sg to the endpoint

# resource "aws_security_group_rule" "cassandra-ingress-rule-ec2" {
#   depends_on = [
#     aws_security_group.cassandra_cluster_sg
#   ]
#   description              = "Allows cassandra cluster group to communicate to  ec2 vpc endpoint SG"
#   type                     = "ingress"
#   from_port                = 443
#   to_port                  = 443
#   protocol                 = "tcp"
#   #security_group_id        =  data.aws_vpc_endpoint.ec2-endpoint.security_group_ids
#   security_group_id = var.security_group_id
#   source_security_group_id = aws_security_group.cassandra_cluster_sg.id
# }

# resource "aws_security_group_rule" "cassandra-ingress-rule-ec2-messages" {
#   depends_on = [
#     aws_security_group.cassandra_cluster_sg
#   ]
#   description              = "Allows cassandra cluster group to communicate to  ec2-messages vpc endpoint SG"
#   type                     = "ingress"
#   from_port                = 443
#   to_port                  = 443
#   protocol                 = "tcp"
#   #security_group_id        = one(data.aws_vpc_endpoint.ec2messages-endpoint.security_group_ids)
#   security_group_id = var.security_group_id
#   source_security_group_id = aws_security_group.cassandra_cluster_sg.id
# }

# resource "aws_security_group_rule" "cassandra-ingress-rule-ssm-messages" {
#   depends_on = [
#     aws_security_group.cassandra_cluster_sg
#   ]
#   description              = "Allows cassandra cluster group to communicate to  ssm-messages vpc endpoint SG"
#   type                     = "ingress"
#   from_port                = 443
#   to_port                  = 443
#   protocol                 = "tcp"
#   #security_group_id        = one(data.aws_vpc_endpoint.ssmmessages-endpoint.security_group_ids)
#   security_group_id = var.security_group_id
#   source_security_group_id = aws_security_group.cassandra_cluster_sg.id
# }

# resource "aws_security_group_rule" "cassandra-ingress-rule-ssm" {
#   depends_on = [
#     aws_security_group.cassandra_cluster_sg
#   ]
#   description              = "Allows cassandra cluster group to communicate to  ssm vpc endpoint SG"
#   type                     = "ingress"
#   from_port                = 443
#   to_port                  = 443
#   protocol                 = "tcp"
#   #security_group_id        = one(data.aws_vpc_endpoint.ssm-endpoint.security_group_ids)
#   security_group_id = var.security_group_id
#   source_security_group_id = aws_security_group.cassandra_cluster_sg.id
# }

# resource "aws_security_group_rule" "cassandra-ingress-rule-secretsmanager" {
#   depends_on = [
#     aws_security_group.cassandra_cluster_sg
#   ]
#   description              = "Allows cassandra cluster group to communicate to  secretsmanager vpc endpoint SG"
#   type                     = "ingress"
#   from_port                = 443
#   to_port                  = 443
#   protocol                 = "tcp"
#   #security_group_id        = one(data.aws_vpc_endpoint.secretsmanager-endpoint.security_group_ids)
#   security_group_id = var.security_group_id
#   source_security_group_id = aws_security_group.cassandra_cluster_sg.id
# }

# resource "aws_security_group_rule" "cassandra-ingress-rule-logs" {
#   depends_on = [
#     aws_security_group.cassandra_cluster_sg
#   ]
#   description              = "Allows cassandra cluster group to communicate to  logs vpc endpoint SG"
#   type                     = "ingress"
#   from_port                = 443
#   to_port                  = 443
#   protocol                 = "tcp"
#   #security_group_id        = one(data.aws_vpc_endpoint.logs-endpoint)
#   security_group_id = var.security_group_id
#   source_security_group_id = aws_security_group.cassandra_cluster_sg.id
# }