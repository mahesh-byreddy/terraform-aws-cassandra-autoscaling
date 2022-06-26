resource "aws_ssm_maintenance_window" "cassandra-maintenance-window" {
  name     = "cassandra-maintenance-window"
  schedule = "cron(0 1  *  *  ?  * )"  #Every day at 6:00 AM UTC which is 2:00 AM EST
  duration = 2
  cutoff   = 1
  schedule_timezone = "America/Atikokan"   #EST in IANA format
}

resource "aws_ssm_maintenance_window_target" "cassandra_seed_node" {
  window_id     = aws_ssm_maintenance_window.cassandra-maintenance-window.id
  name          = "cassandra-maintenance-window-target"
  description   = "Cassandra instance in us-east-1a is the maintenance window target"
  resource_type = "INSTANCE"

  targets {
    key    = "tag:Name"
    values = ["cassandra-node-1a"]
  }
}

resource "aws_ssm_maintenance_window_task" "cassandra_backup_keyspaces" {
  max_concurrency = 2
  max_errors      = 1
  priority        = 1
  task_arn        = "AWS-RunRemoteScript"
  task_type       = "RUN_COMMAND"
  window_id       = aws_ssm_maintenance_window.cassandra-maintenance-window.id

  targets {
    key    = "WindowTargetIds"
    values = [aws_ssm_maintenance_window_target.cassandra_seed_node.id]
  }

  task_invocation_parameters {
    run_command_parameters {
      document_version = "$LATEST"
      timeout_seconds      = 600
      
      parameter {
         name = "sourceType"  
         values = ["S3"]
      }
      parameter {
         name = "sourceInfo"  
         values = ["{\"path\":\"https://cnc-${var.accountName}-${var.environment}-cassandra-storage.s3.amazonaws.com/cassandraBackup.sh\"}"]
      }

      parameter {
         name = "commandLine"  
         values = ["sh cassandraBackup.sh -c \"axway_${var.environment}_cluster\" -s \"xaxway_${var.environment}_api_${var.environment}-SNAPSHOT\" -b \"cnc-${var.accountName}-${var.environment}-cassandra-priam-s3\" -k \"xaxway_${var.environment}_api_${var.environment}\""]
      }
      parameter {
         name = "workingDirectory"  
         values = ["/home"]
      }
      parameter {
         name = "executionTimeout"  
         values = [3600]
      }
      
      
       
    }
  }
}
