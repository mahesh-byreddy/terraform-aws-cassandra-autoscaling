resource "aws_cloudwatch_metric_alarm" "autoscaling-instance-cpu-utilization"{
  count                     = length(var.az_identifier)
  alarm_name                = "autoscaling-instance-cpu-utilization"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "80"
  alarm_description         = "This metric monitors ec2 cpu utilization of corresponding Autoscaling group"
  insufficient_data_actions = []
  treat_missing_data        = "notBreaching"
  alarm_actions             = [var.sns_topic_arn]

  dimensions  = {
      AutoScalingGroupName = "cassandra-instances-autoscaling-group-${var.az_identifier[count.index]}"
  }
}

resource "aws_cloudwatch_metric_alarm" "autoscaling-group-size"{
  count                     = length(var.az_identifier)
  alarm_name                = "autoscaling-group-total-instances"
  comparison_operator       = "LessThanThreshold"
  evaluation_periods        = "1"
  metric_name               = "GroupInServiceInstances"
  namespace                 = "AWS/EC2"
  period                    = "60"  #In seconds
  statistic                 = "Average"
  threshold                 = "1"
  alarm_description         = "This metric monitors Autoscaling group size"
  insufficient_data_actions = []
  treat_missing_data        = "notBreaching"
  alarm_actions             = [var.sns_topic_arn]
  dimensions  = {
      AutoScalingGroupName = "cassandra-instances-autoscaling-group-${var.az_identifier[count.index]}"
  }
}

resource "aws_cloudwatch_metric_alarm" "autoscaling-instance-statuscheck"{
  count                     = length(var.az_identifier)
  alarm_name                = "autoscaling-group-total-instances"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "StatusCheckFailed_Instance"
  namespace                 = "AWS/EC2"
  period                    = "60"  #In seconds
  statistic                 = "Average"
  threshold                 = "1"
  alarm_description         = "This metric monitors status checks for of Instances in Autoscaling group"
  insufficient_data_actions = []
  treat_missing_data        = "notBreaching"
  alarm_actions             = [var.sns_topic_arn]

  dimensions  = {
      AutoScalingGroupName = "cassandra-instances-autoscaling-group-${var.az_identifier[count.index]}"
  }
}