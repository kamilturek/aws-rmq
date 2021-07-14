packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "erlang_cookie" {
  type = string
}

source "amazon-ebs" "node" {
  ami_name      = "node"
  instance_type = "t2.micro"
  region        = "eu-central-1"
  source_ami_filter {
    filters = {
      name = "amzn2-ami-hvm-2.0*-x86_64-gp2"
    }
    most_recent = true
    owners      = ["amazon"]
  }
  ssh_username = "ec2-user"
}

build {
  sources = [
    "source.amazon-ebs.node"
  ]

  provisioner "shell" {
    pause_before = "10s"
    inline = [
      "sudo amazon-linux-extras install epel -y",
      "sudo yum update -y",
      "sudo yum install erlang -y",
      "sudo yum install rabbitmq-server -y",
      "sudo bash -c 'echo ${var.erlang_cookie} > /var/lib/rabbitmq/.erlang.cookie'",
      "sudo chown rabbitmq /var/lib/rabbitmq/.erlang.cookie",
      "sudo chmod 600 /var/lib/rabbitmq/.erlang.cookie",
    ]
  }
}
