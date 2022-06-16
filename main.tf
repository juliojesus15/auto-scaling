# AWS ASG (AutoScaling Group)
# Terraform Version
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.18.0"
    }
  }
}

# Provider
provider "aws" {
  region     = "us-east-1"
  access_key = "AKIA2DBYZ2NYY3UYXUQS"
  secret_key = "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"
}

# Ubuntu AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    #values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

// Template
resource "aws_launch_template" "asg-template-t2micro" {
  name_prefix   = "asg-template-t2micro"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name = "cloudcomputing"
}

// ASG
resource "aws_autoscaling_group" "as-ubuntu" {
  availability_zones = ["us-east-1a"]
  desired_capacity   = 3
  max_size           = 3
  min_size           = 2

  launch_template {
    id      = aws_launch_template.asg-template-t2micro.id
    version =  "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "Node-CloudComputing"
    propagate_at_launch = true
  }
}