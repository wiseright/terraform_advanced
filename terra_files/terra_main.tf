# terra_main.tf

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "eu-west-1"
}

resource "aws_security_group" "sg" {
  description = "test sg for terraform"
  vpc_id      = "vpc-0282dfd7758da30e5"
  dynamic "ingress" {
    for_each = var.security_groups
    content {
      description = ingress.value["name"]
      from_port   = ingress.value["from_port"]
      to_port     = ingress.value["to_port"]
      protocol    = ingress.value["protocol"]
      cidr_blocks = ingress.value["cidr_blocks"]
    }
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

# Generated with command: ssh-keygen.exe -t rsa -b 4096
resource "aws_key_pair" "deployer" {
  key_name   = "terra_key"
  public_key = file("./terra_key_03.pub")
}

resource "aws_instance" "app_server" {
  ami = var.ec2.os_type == "linux" ? var.linux_ami : var.ubuntu_ami
  instance_type = var.ec2.instance_type
  #associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.sg.id] 
  key_name = aws_key_pair.deployer.id
  root_block_device {
    delete_on_termination = true
    encrypted             = false
    volume_size           = var.ec2.volume_size
    volume_type           = var.ec2.volume_type
  }

  user_data = file("templates/${var.ec2.os_type}.sh")

  tags = {
    Name = var.instance_name
  }
}
