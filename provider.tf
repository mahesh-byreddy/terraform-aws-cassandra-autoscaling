terraform {
   
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.8.0"
    }
    tls = {
      source = "hashicorp/tls"
      version = "~> 3.3.0"
    }
  }

}

#Main Provider 

provider "aws" {
  
  region     = var.region
  #profile    = "mainregion"

  assume_role {
    role_arn = "arn:aws:iam::${var.accountNumber}:role/devops-dev-deployment-role"
    session_name = "devops-dev-session"
  }
    
}

# #DR Provider

# provider "aws" {
  
#   alias   = "dr"
#   region  = var.drRegion
#   profile = "disasterrecovery"

#   assume_role {
#     role_arn = "arn:aws:iam::${var.accountNumber}:role/devops-ss-deployment-role"
#     session_name = "devops-session"
#   }

# }
