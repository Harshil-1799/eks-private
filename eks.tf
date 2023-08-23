# IAM Role for EKS Cluster
resource "aws_iam_role" "eks_cluster_role" {
  name = "eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "eks.amazonaws.com",
        },
      },
    ],
  })
}

# IAM Role for EKS Node Group 1
resource "aws_iam_role" "node_group_1" {
  name = "eks-node-group-1-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com",
        },
      },
    ],
  })
}

# IAM Role for EKS Node Group 2
resource "aws_iam_role" "node_group_2" {
  name = "eks-node-group-2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com",
        },
      },
    ],
  })
}

# IAM Role Policy Attachments for Node Groups
resource "aws_iam_role_policy_attachment" "node_group_1_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.node_group_1.name
}

resource "aws_iam_role_policy_attachment" "node_group_2_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.node_group_2.name
}

# EKS Cluster
resource "aws_eks_cluster" "my_cluster" {
  name     = "my-eks-cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn

  version = "1.27"

  vpc_config {
    security_group_ids = ["security-group-id"]  # Replace with your security group ID
    subnet_ids = [
      aws_subnet.public_subnet_1.id,
      aws_subnet.public_subnet_2.id,
    ]
  }

  depends_on = [
    aws_iam_role_policy_attachment.node_group_1_policy_attachment,
    aws_iam_role_policy_attachment.node_group_2_policy_attachment,
  ]
}

# Node Group 1
resource "aws_eks_node_group" "node_group_1" {
  cluster_name    = aws_eks_cluster.my_cluster.name
  node_group_name = "node-group-1"
  node_role_arn   = aws_iam_role.node_group_1.arn

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  subnet_ids = [
    aws_subnet.public_subnet_1.id,
    aws_subnet.public_subnet_2.id,
  ]
}

# Node Group 2
resource "aws_eks_node_group" "node_group_2" {
  cluster_name    = aws_eks_cluster.my_cluster.name
  node_group_name = "node-group-2"
  node_role_arn   = aws_iam_role.node_group_2.arn

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  subnet_ids = [
    aws_subnet.public_subnet_1.id,
    aws_subnet.public_subnet_2.id,
  ]
}

# Launch Template for Node Groups
resource "aws_launch_template" "node_group_1" {
  # Configuration for launch template of node group 1
  # ...
}

resource "aws_launch_template" "node_group_2" {
  # Configuration for launch template of node group 2
  # ...
}

# IAM Instance Profiles for Node Groups
resource "aws_iam_instance_profile" "node_group_1" {
  # Configuration for instance profile of node group 1
  # ...
}

resource "aws_iam_instance_profile" "node_group_2" {
  # Configuration for instance profile of node group 2
  # ...
}
