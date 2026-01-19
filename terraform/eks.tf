module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "21.0"

  name               = var.cluster_name
  kubernetes_version = "1.33"

  addons = {
    coredns    = {}
    kube-proxy = {}
    vpc-cni = {
      before_compute = true
    }
  }

  # Optional
  endpoint_public_access = true

  # Optional: Adds the current caller identity as an administrator via cluster access entry
  # enable_cluster_creator_admin_permissions = true

  access_entries = {
    devops-lead = {
      principal_arn = "arn:aws:iam::839087537051:user/devops-user"
      policy_associations = {
        admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy" # Use IAM Role instead of User for better security
          access_scope = {
            type = "cluster" # <-- This gives access to the entire cluster
          }
        }
      }
    }
  }

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_groups = {
    node-1 = {
      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
      capacity_type  = "ON_DEMAND"
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["m7i-flex.large"]

      min_size     = 1
      max_size     = 10
      desired_size = 1
    }
    node-2 = {
      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
      capacity_type  = "ON_DEMAND"
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["m7i-flex.large"]

      min_size     = 1
      max_size     = 10
      desired_size = 1
    }
  }
}
/*
  eks_managed_node_groups = {
    on-demand = {
      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
      capacity_type  = "ON_DEMAND"
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["m7i-flex.large"]

      min_size     = 1
      max_size     = 10
      desired_size = 1
      #disk_size    = 50
      labels = {
        workload = "critical"
        type     = "on-demand"
      }
    }
    spot = {
      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
      capacity_type  = "SPOT"
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["m7i-flex.large", "c7i-flex.large"]

      min_size     = 1
      max_size     = 10
      desired_size = 1
      #disk_size    = 50
      labels = {
        workload = "non-critical"
        type     = "spot"
      }
      taints = {
        spot = {
          key    = "spot"
          value  = "true"
          effect = "NO_SCHEDULE"
        }
      }
    }
  }
*/
