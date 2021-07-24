data "aws_ami" "node" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["node-ami"]
  }
}

resource "aws_iam_instance_profile" "node_profile" {
  name = "node-profile"
  role = aws_iam_role.node_role.name
}

resource "aws_launch_configuration" "node_launch_config" {
  name                 = "node-launch-config"
  image_id             = data.aws_ami.node.image_id
  instance_type        = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.node_profile.id
  key_name             = "kamil"
  security_groups      = [aws_security_group.node_sg.id]

  user_data = <<EOF
#!/bin/bash
sudo service rabbitmq-server start
sudo rabbitmqctl set_policy "ha-all" '.*' '{"ha-mode": "all"}' 
EOF
}

resource "aws_autoscaling_group" "broker_asg" {
  name = "broker-asg"

  max_size         = 2
  min_size         = 1
  desired_capacity = 2

  availability_zones        = ["eu-central-1a", "eu-central-1b"]
  launch_configuration      = aws_launch_configuration.node_launch_config.name
  wait_for_capacity_timeout = 0
}
