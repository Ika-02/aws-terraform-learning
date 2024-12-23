terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 5.0"
        }
    }
}

# Configure the AWS Provider
provider "aws" {
    region     = "us-east-1"
    secret_key = var.aws_secret_key
    access_key = var.aws_access_key
}

variable "aws_secret_key" {
    description = "The AWS secret key"
    type        = string
    sensitive   = true
}

variable "aws_access_key" {
    description = "The AWS access key"
    type        = string
    sensitive   = true
}
