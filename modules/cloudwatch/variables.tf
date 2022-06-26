variable "sns_topic_arn" {
  description = "sns topic arn to push cloudwatch alerts"
  type = string
  default = ""
}

variable "az_identifier" {
  description = "Availability zone identifier Eg: 1a"
  type = list(string)
 
}
