data "aws_vpc" "existing" {
	id = var.vpc_id
}

data "aws_subnets" "existing" {
  filter{
    name = "vpc-id"
    values = [var.vpc_id]
  }
}


data "aws_subnet" "AZA" {
  vpc_id = var.vpc_id

 filter {
    name   = "tag:Name"
    values = ["mra-esg-nprd-useast1-1-app-1a"]
  }

}

data "aws_subnet" "AZB" {
  vpc_id = var.vpc_id

  filter {
    name   = "tag:Name"
    values = ["mra-esg-nprd-useast1-1-app-1b"]
  }

}

data "aws_subnet" "AZC" {
  vpc_id = var.vpc_id

  filter {
    name   = "tag:Name"
    values = ["mra-esg-nprd-useast1-1-app-1c"]
  }

}



# #Fetch endpoint sgs from sm ps
# data "aws_vpc_endpoint" "ec2-endpoint" {
#   vpc_id = var.vpc_id
#   service_name = "com.amazonaws.${var.region}.ec2"
# }

# data "aws_vpc_endpoint" "ec2messages-endpoint" {
#   vpc_id = var.vpc_id
#   service_name = "com.amazonaws.${var.region}.ec2messages"
# }

# data "aws_vpc_endpoint" "ssm-endpoint" {
#   vpc_id = var.vpc_id
#   service_name = "com.amazonaws.${var.region}.ssm"
# }

# data "aws_vpc_endpoint" "ssmmessages-endpoint" {
#   vpc_id = var.vpc_id
#   service_name = "com.amazonaws.${var.region}.ssmmessages"
# }

# data "aws_vpc_endpoint" "secretsmanager-endpoint" {
#   vpc_id = var.vpc_id
#   service_name = "com.amazonaws.${var.region}.secretsmanager"
# }

# data "aws_vpc_endpoint" "logs-endpoint" {
#   vpc_id = var.vpc_id
#   service_name = "com.amazonaws.${var.region}.logs"
# }