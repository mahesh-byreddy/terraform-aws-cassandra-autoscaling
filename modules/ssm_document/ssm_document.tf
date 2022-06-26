
resource "aws_ssm_document" "cassandra_setup_document" {
 
  name          = "cassandra_setup"
  document_type = "Command"

  content =<<DOC
{
	"schemaVersion": "2.2",
	"description": "Bootstrap cassandra instances after initial launch ",
	"parameters": {},
	"mainSteps": [
    {
		  "action": "aws:runShellScript",
		  "name": "Bootstrap_instances",
		  "inputs": {
			  "runCommand": [
				    "sudo service cassandra stop",
			     	"sudo systemctl enable cassandra",
				    "sudo service cassandra start",
					"systemctl status cassandra"
			]

		}
	}]
}
 DOC   
}


resource "aws_ssm_association" "cassandra_bootstrap_instance_association" {
 
  name = aws_ssm_document.cassandra_setup_document.name

   #count = length(var.private_ips)
  
  targets {
    key    = "tag:Name"
    values = ["cassandra-node-1a","cassandra-node-1b","cassandra-node-1c"]
  }
}

resource "aws_ssm_document" "cassandra_create_axway_user" {
 
  name          = "cassandra_create_axway_user"
  document_type = "Command"

  content =<<DOC
{
	"schemaVersion": "2.2",
	"description": "Create Axway user for Cassandra Cluster",
	"parameters": {},
	"mainSteps": [
    {
		  "action": "aws:runShellScript",
		  "name": "createAxwayUserAndRemoveDefaultUser",
		  "inputs": {
			  "runCommand": [
				    "PASSWORD=$(aws secretsmanager --region us-east-1 get-secret-value --secret-id saaxway_${var.environment}/password --query 'SecretString' --output text)",
					"export SSL_CERTFILE=/opt/cassandra/conf/ca.crt.pem; cqlsh -e \"ALTER KEYSPACE \"system_auth\" WITH REPLICATION = { 'class': 'SimpleStrategy', 'replication_factor': 3 };\" ${var.private_ips[0]} -u cassandra -p cassandra --ssl",
			     	"export SSL_CERTFILE=/opt/cassandra/conf/ca.crt.pem; cqlsh -e \"CREATE USER ${var.axway_user_name} WITH PASSWORD '$PASSWORD' SUPERUSER;\"  ${var.private_ips[0]} -u cassandra -p cassandra --ssl",     
				    "export SSL_CERTFILE=/opt/cassandra/conf/ca.crt.pem; cqlsh -e \"ALTER USER cassandra WITH PASSWORD 'cassandra' NOSUPERUSER;\" ${var.private_ips[0]} -u ${var.axway_user_name} -p $PASSWORD --ssl",
					"export SSL_CERTFILE=/opt/cassandra/conf/ca.crt.pem; cqlsh -e \"LIST USERS;\" ${var.private_ips[0]} -u ${var.axway_user_name} -p $PASSWORD --ssl"
			]

		}
	}]
}
 DOC   
}

resource "aws_ssm_association" "cassandra_create_user_association" {
 
  depends_on = [aws_ssm_association.cassandra_bootstrap_instance_association]
  name = aws_ssm_document.cassandra_create_axway_user.name
  
  targets {
    key    = "tag:Name"
    values = ["cassandra-node-1a"]
  }

 
}