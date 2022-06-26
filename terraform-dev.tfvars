####Dev account######

environment = "dev"
region = "us-east-1"
vpc_id = "vpc-0684f3714233b88c9" 
accountNumber = "938540043867" 
accountName = "cassandra-test"
availability_zones = ["us-east-1a","us-east-1b","us-east-1c"]
drRegion = "us-west-2"
az_identifier = ["1a","1b","1c"]
#axway_user_name = "cassandradev"

## EC2 Variables
instance_type = "t3.medium" 
ami = "ami-0022f774911c1d690" #"ami-0dc2d3e4c0f9ebd18" # "ami-001ac54be1af30406" #Amazon Linux 2 Image
allowed_ranges = ["10.188.161.0/24","10.188.164.0/24","10.188.167.0/24"] # Private subnets' IPV4 CIDR blocks 
template-file = "template/cassandra.tmpl"

private_ips = ["10.188.161.82"]#,"10.188.164.76","10.188.167.91"]
 common_tags = {
        Name = "test-instances"
 }

email = "maheshreddy@example.com"

#sns_topic_arn = "arn:aws:sns:us-east-1:157856770060:cassandra-nodes-alarm"
#kms_key_id = "321bd45a-21e2-4220-94fd-353df4991b89"