module "eks" {

  # Mention the source for the Terraform module form Terraform Registry.
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

# Lets give our EKS cluster a Name and the Kubernetes vertion to be used
  cluster_name    = var.deployment-name
  cluster_version = "1.28"

# This portion indicate that our cluster entpoint is accessible both from outside and inside the VPC 
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

# Here we are mentioning the VPC to use. 
# The subnets where mentioned to place the worker nodes in it.
  vpc_id     = aws_vpc.PG-EKS-VPC.id
  subnet_ids = [aws_subnet.PG-EKS-private-ap-south-1a.id , aws_subnet.PG-EKS-private-ap-south-1b.id, aws_subnet.PG-EKS-private-ap-south-1c.id]

# Enable_irsa IAM role for Service Account this is the part where we connect from EKS pod to other AWS services 
# by leverage the use of IAM to attach role to kubernetes Service Account. 
# This will create an OpenID Connect Provider for EKS.
  enable_irsa = true

# the default addons
  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

# The EKS managed node groups will take care of the worker node patch, update and autoscaling using autoscaler
  eks_managed_node_groups = {

    spot = {
      desired_size = 3
      min_size     = 1
      max_size     = 5

      labels = {
        role = "spot"
      }

      instance_types = ["t3.medium"]
      capacity_type  = "SPOT"
    }
  }

  tags = {
    Name = "${var.deployment-name}"
  }
}