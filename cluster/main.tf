terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}

data "aws_ami" "node" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["node"]
  }
}

resource "aws_security_group" "node" {
  name = "node"

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_instance" "node" {
  ami                    = data.aws_ami.node.id
  instance_type          = "t2.micro"
  key_name               = "kamil"
  vpc_security_group_ids = [aws_security_group.node.id]
}
