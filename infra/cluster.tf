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
