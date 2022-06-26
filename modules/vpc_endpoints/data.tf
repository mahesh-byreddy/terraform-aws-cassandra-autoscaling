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
