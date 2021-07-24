resource "aws_iam_role" "node_role" {
  name        = "node-role"
  description = "Enables node to discover its peers inside ASG"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  inline_policy {
    name = "peer-discovery-policy"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Action = [
            "autoscaling:DescribeAutoScalingInstances",
            "ec2:DescribeInstances"
          ],
          Resource = "*"
        }
      ]
    })
  }
}
