module "cassandra" {
  
 source        = "./modules/cassandra"
    
 environment     = var.environment
 region          = var.region
 instance_type   = var.instance_type
 vpc_id          = var.vpc_id
 ami             = var.ami
 allowed_ranges  = var.allowed_ranges  #ipv4 cidr block of Vpc itself
 template-file   = var.template-file
 private_ips     = var.private_ips
 common_tags     = var.common_tags
 accountName     = var.accountName
 accountNumber   = var.accountNumber
 az_identifier   = var.az_identifier
 availability_zones = var.availability_zones
 kms_key_id       = "eab8d59a-bac2-4a2a-9d7c-572cefc5992b" # module.kms.kms_key_id
 role_name      = "ec2-cassandra-cluster-node-role"
 security_group_id = module.vpc_endpoints.security_group_id
 
  depends_on = [
 # module.kms,
 # module.ssm_parameters,
  module.vpc_endpoints
  ]
}

# module "kms" {
#   source = "./modules/kms"
#   alias           = "terraform-test-kms"
#   accountNumber   = var.accountNumber
# }


module "vpc_endpoints" {
  source = "./modules/vpc_endpoints"

  environment = var.environment
  region      = var.region
  vpc_id      = var.vpc_id

}



# module "ssm_document" {

#  source = "./modules/ssm_document"

#  common_tags = var.common_tags
#  private_ips = var.private_ips
#  axway_user_name = var.axway_user_name
#  environment = var.environment
#  depends_on = [
#   module.cassandra
#   ]
  
# }

# module "ssm_parameters" {

#   source = "./modules/ssm_parameters"
# }

# module "maintenance_window" {

#   source = "./modules/maintenance_window"

#   accountName     = var.accountName
#   environment     = var.environment

#   depends_on = [
#     module.cassandra
#   ]

# }

# module "cloudwatch" {

#   source = "./modules/cloudwatch"

#   sns_topic_arn = module.sns_topic.sns_topic_arn
#   az_identifier = var.az_identifier

#   depends_on = [
#     module.cassandra,
#     module.sns_topic
#   ]

# }

# module "sns_topic" {

#   source = "./modules/sns_topic"

#   accountNumber   = var.accountNumber
#   region          = var.region
#   kms_key_id       = module.kms.kms_key_id

#   depends_on = [
#     module.kms
#   ]
# }











