locals {
  # subnet_ids = tomap({
  #   "10.188.161.80" = data.aws_subnet.AZA.id,
  #   "10.188.164.75" = data.aws_subnet.AZB.id,
  #   "10.188.167.90" =data.aws_subnet.AZC.id
  #   })

  subnets = concat([data.aws_subnet.AZA.id],[data.aws_subnet.AZB.id],[data.aws_subnet.AZC.id])
}


resource "aws_network_interface" "cassandra_network_interface" {
  
   # for_each        = local.subnet_ids
    count          = length(var.private_ips)
    private_ips     = [var.private_ips[count.index]]
    #subnet_id       = element(concat(tolist(data.aws_subnet.AZA.id), tolist(data.aws_subnet.AZB.id), tolist(data.aws_subnet.AZC.id)),count.index)
    subnet_id = local.subnets[count.index]
    #subnet_id       = element(concat(data.aws_subnet.AZA.id),(data.aws_subnet.AZB.id),(data.aws_subnet.AZC.id),count.index)
    security_groups = [aws_security_group.cassandra_cluster_sg.id,var.security_group_id]
                      # data.aws_vpc_endpoint.ec2-endpoint.security_group_ids,
                      # data.aws_vpc_endpoint.ec2messages-endpoint.security_group_ids,
                      # data.aws_vpc_endpoint.ssm-endpoint.security_group_ids,
                      # data.aws_vpc_endpoint.ssmmessages-endpoint.security_group_ids,
                      # data.aws_vpc_endpoint.secretsmanager-endpoint.security_group_ids,
                      # data.aws_vpc_endpoint.logs-endpoint.security_group_ids]
  }
 

#creating an instance profile for ec2 instances using existing role
resource "aws_iam_instance_profile" "ec2-cassandra-cluster-node-role" {
    name = "ec2-cassandra-cluster-node-role"
    role = var.role_name
}

resource "aws_launch_template" "cassandra_launch_template" {

  depends_on     = [aws_network_interface.cassandra_network_interface, aws_iam_instance_profile.ec2-cassandra-cluster-node-role]
  count          = length(var.private_ips)
  name           = "cassandra_launch_template-${var.az_identifier[count.index]}"
  ebs_optimized  = true  
  image_id       = var.ami
  instance_type  = var.instance_type

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_type = "gp2"
      volume_size = 10
      delete_on_termination = true
      encrypted = false
      #kms_key_id = "arn:aws:kms:us-east-1:${var.accountNumber}:key/${var.kms_key_id}" 
    }
  }

   monitoring {
    enabled = true
  }

  iam_instance_profile {
    arn = aws_iam_instance_profile.ec2-cassandra-cluster-node-role.arn
  }

  network_interfaces {
      device_index = 0
      network_interface_id = aws_network_interface.cassandra_network_interface[count.index].id
  }

user_data = base64encode(<<HERE
#!/bin/bash
yum update -y
yum install amazon-cloudwatch-agent -y
sudo amazon-linux-extras install collectd -y
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c ssm:AmazonCloudWatch-linux-config
yum install curl
yum install java-1.8.0-openjdk -y
aws s3 cp s3://platform-devops-test-data/cassandra-2.2.12-1.noarch.rpm /home


cd /home
rpm --import public_key

yum install cassandra-2.2.12-1.noarch.rpm -y
/etc/init.d/cassandra start
systemctl daemon-reload
service cassandra stop

rm -rf /var/lib/cassandra/data/system/*


read -d '' CONTENT << EOF
${templatefile("${path.module}/template/cassandra.tmpl", {
 private_ip = "${aws_network_interface.cassandra_network_interface[count.index].private_ip}",
 seeds = "${var.private_ips[0]}" 
 })}
EOF

echo "$CONTENT" > /etc/cassandra/conf/cassandra.yaml

mkdir -p /opt/cassandra/conf
cd /opt/cassandra/conf


aws secretsmanager --region ${var.region} get-secret-value --secret-id cassandra/keystorebinary --query 'SecretBinary' --output text | base64 --decode >> .keystore
aws secretsmanager --region ${var.region} get-secret-value --secret-id cassandra/truststorebinary --query 'SecretBinary' --output text | base64 --decode >> .truststore
aws secretsmanager --region ${var.region} get-secret-value --secret-id cassandra/crtpem --query 'SecretBinary' --output text | base64 --decode >> ca.crt.pem
aws secretsmanager --region ${var.region} get-secret-value --secret-id cassandra/keypem --query 'SecretBinary' --output text | base64 --decode >> ca.key.pem

sudo chown -R cassandra:cassandra /opt/cassandra/conf

ESCAPED_REPLACE=$(aws secretsmanager --region ${var.region} get-secret-value --secret-id cassandra/password --query 'SecretString' --output text "$REPLACE" | sed -e 's/[\/&]/\\&/g')
sed -i "s/changeme/$ESCAPED_REPLACE/g" /etc/cassandra/conf/cassandra.yaml

yum update -y

cd /etc/cassandra/conf
mv cassandra-topology.properties cassandra-tops.topology
sed -i 's/dc1/${var.region}/g' cassandra-rackdc.properties
sed -i 's/rack1/${var.az_identifier[count.index]}/g' cassandra-rackdc.properties

sudo systemctl enable cassandra
sudo service cassandra start

HERE   
)
  metadata_options {
    
    http_endpoint = "enabled"
    http_tokens = "optional"
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "cassandra-node-${var.az_identifier[count.index]}"
      owner = "mahesh.byreddy@moodys.com"
      provisioned_by = "byreddym"
      revenue = "n"
      lob_division = "mra-esg"
      application = "devops-poc"

    }
  }
}


# resource "aws_autoscaling_group" "cassandra_asg" {
  
#   count             = length(var.private_ips)
#   depends_on        = [aws_network_interface.cassandra_network_interface, aws_launch_template.cassandra_launch_template]
#   name              = "cassandra-instances-autoscaling-group-${var.az_identifier[count.index]}"
#   max_size          = 1
#   min_size          = 1
#   desired_capacity  = 1
#   health_check_type = "EC2"
#   availability_zones = [var.availability_zones[count.index]]
 
#   launch_template  {
    
#     id      = aws_launch_template.cassandra_launch_template[count.index].id
#     version = aws_launch_template.cassandra_launch_template[count.index].latest_version

#   }

# }

resource "aws_instance" "cassandra" {
  count             = length(var.private_ips)
  depends_on        = [aws_network_interface.cassandra_network_interface, aws_launch_template.cassandra_launch_template]
  availability_zone = var.availability_zones[count.index]

  launch_template  {
    
    id      = aws_launch_template.cassandra_launch_template[count.index].id
    version = aws_launch_template.cassandra_launch_template[count.index].latest_version

  }


}