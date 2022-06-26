# resource "aws_vpc_endpoint" "s3" {
# 	vpc_id = var.vpc_id
# 	service_name = "com.amazonaws.${var.region}.s3"
# }

resource "aws_vpc_endpoint" "ec2" {
	depends_on = [
	  aws_security_group.endpoint-sg
	]
	vpc_id = var.vpc_id
	service_name = "com.amazonaws.${var.region}.ec2"
	vpc_endpoint_type = "Interface"
	subnet_ids = [data.aws_subnet.AZA.id,data.aws_subnet.AZB.id,data.aws_subnet.AZC.id]

	security_group_ids = [
		aws_security_group.endpoint-sg.id
	]
}

resource "aws_vpc_endpoint" "ec2-messages" {
	depends_on = [
	  aws_security_group.endpoint-sg
	]
	vpc_id = var.vpc_id
	service_name = "com.amazonaws.${var.region}.ec2messages"
	vpc_endpoint_type = "Interface"
	subnet_ids = [data.aws_subnet.AZA.id,data.aws_subnet.AZB.id,data.aws_subnet.AZC.id]

	security_group_ids = [
		aws_security_group.endpoint-sg.id
	]
}

resource "aws_vpc_endpoint" "ssm-messages" {
	depends_on = [
	  aws_security_group.endpoint-sg
	]
	vpc_id = var.vpc_id
	service_name = "com.amazonaws.${var.region}.ssmmessages"
	vpc_endpoint_type = "Interface"
	subnet_ids = [data.aws_subnet.AZA.id,data.aws_subnet.AZB.id,data.aws_subnet.AZC.id]

	security_group_ids = [
		aws_security_group.endpoint-sg.id
	]
}


resource "aws_vpc_endpoint" "ssm" {
	depends_on = [
	  aws_security_group.endpoint-sg
	]
	vpc_id = var.vpc_id
	service_name = "com.amazonaws.${var.region}.ssm"
	vpc_endpoint_type = "Interface"
	subnet_ids = [data.aws_subnet.AZA.id,data.aws_subnet.AZB.id,data.aws_subnet.AZC.id]

	security_group_ids = [
		aws_security_group.endpoint-sg.id
	]
}

resource "aws_vpc_endpoint" "secretsmanager" {
	depends_on = [
	  aws_security_group.endpoint-sg
	]
	vpc_id = var.vpc_id
	service_name = "com.amazonaws.${var.region}.secretsmanager"
	vpc_endpoint_type = "Interface"
	subnet_ids = [data.aws_subnet.AZA.id,data.aws_subnet.AZB.id,data.aws_subnet.AZC.id]

	security_group_ids = [
		aws_security_group.endpoint-sg.id
	]
}

resource "aws_vpc_endpoint" "logs" {
	depends_on = [
	  aws_security_group.endpoint-sg
	]
	vpc_id = var.vpc_id
	service_name = "com.amazonaws.${var.region}.logs"
	vpc_endpoint_type = "Interface"
	subnet_ids = [data.aws_subnet.AZA.id,data.aws_subnet.AZB.id,data.aws_subnet.AZC.id]

	security_group_ids = [
		aws_security_group.endpoint-sg.id
	]
}

