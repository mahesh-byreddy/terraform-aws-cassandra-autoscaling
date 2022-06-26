resource "aws_ssm_parameter" "amazoncloudwatch_linux_config_param" {
  name  = "AmazonCloudWatch-linux-config"
  type  = "String"
  tier  = "Advanced"
  value = jsonencode({
        "agent": {
                "metrics_collection_interval": 30,
                "run_as_user": "root"
        },
        "logs": {
                "logs_collected": {
                        "files": {
                                "collect_list": [
                                        {
                                                "file_path": "/var/log/cassandra/cassandra.log",
                                                "log_group_name": "/var/log/cassandra/cassandraLogs",
                                                "log_stream_name": "cassandraLogs_[{instance_id}]"
                                        },
                                        {
                                                "file_path": "/var/log/cassandra/system.log",
                                                "log_group_name": "/var/log/cassandra/cassandraSystemLogs",
                                                "log_stream_name": "cassandraSystemLogs_[{instance_id}]"
                                        },
                                        {
                                                "file_path": "/var/log/cloud-init-output.log",
                                                "log_group_name": "/var/log/cassandra/cloudInitLog",
                                                "log_stream_name": "CassandraCloudInitOutput_[{instance_id}]"
                                        }
                                ]
                        }
                }
        },
        "metrics": {
                "append_dimensions": {
                        "AutoScalingGroupName": "$${aws:AutoScalingGroupName}",
                        "ImageId": "$${aws:ImageId}",
                        "InstanceId": "$${aws:InstanceId}",
                        "InstanceType": "$${aws:InstanceType}"
                },
                "metrics_collected": {
                        "collectd": {
                                "metrics_aggregation_interval": 60
                        },
                        "cpu": {
                                "measurement": [
                                        "cpu_usage_idle",
                                        "cpu_usage_iowait",
                                        "cpu_usage_user",
                                        "cpu_usage_system"
                                ],
                                "metrics_collection_interval": 30,
                                "totalcpu": false
                        },
                        "disk": {
                                "measurement": [
                                        "used_percent",
                                        "inodes_free"
                                ],
                                "metrics_collection_interval": 30,
                                "resources": [
                                        "*"
                                ]
                        },
                        "diskio": {
                                "measurement": [
                                        "io_time",
                                        "write_bytes",
                                        "read_bytes",
                                        "writes",
                                        "reads"
                                ],
                                "metrics_collection_interval": 30,
                                "resources": [
                                        "*"
                                ]
                        },
                        "mem": {
                                "measurement": [
                                        "mem_used_percent"
                                ],
                                "metrics_collection_interval": 30
                        },
                        "netstat": {
                                "measurement": [
                                        "tcp_established",
                                        "tcp_time_wait"
                                ],
                                "metrics_collection_interval": 30
                        },
                        "statsd": {
                                "metrics_aggregation_interval": 60,
                                "metrics_collection_interval": 30,
                                "service_address": ":8125"
                        },
                        "swap": {
                                "measurement": [
                                        "swap_used_percent"
                                ],
                                "metrics_collection_interval": 30
                        }
                }
        }
   })
}
