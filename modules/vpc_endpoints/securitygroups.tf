resource "aws_security_group" "endpoint-sg" {
	
	name = "vpc_endpoint_sg"
	description = "Allow traffic from endpoint to resources inside vpc"
	vpc_id = var.vpc_id

	ingress  {
		from_port = 443
		to_port = 443
		protocol = "tcp"
		cidr_blocks = [data.aws_vpc.existing.cidr_block]
	}

	egress  {
		from_port = 0
		to_port = 0
		protocol = "-1"
		cidr_blocks   = ["0.0.0.0/0"]
    	ipv6_cidr_blocks = ["::/0"]
	}
}