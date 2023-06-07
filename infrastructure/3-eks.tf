module "eks" {
  # https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest
  source          = "terraform-aws-modules/eks/aws"
  version         = "19.15.2"
  cluster_name    = local.cluster_name
  cluster_version = "1.25"
  
  subnet_ids      = module.vpc.private_subnets
  vpc_id          = module.vpc.vpc_id

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true
  enable_irsa = true

  eks_managed_node_group_defaults = {
    disk_size        = 25          # default volume size
    disk_type        = "gp3"        # gp3 ebs volume
    # disk_throughput  = 150          # min throughput
    # disk_iops        = 3000         # min iops for gp3
    # capacity_type    = "SPOT"
    eni_delete       = true         # delete eni on termination
    # key_name         = local.key    # default ssh keypair for nodes
    ebs_optimized    = true         # ebs optimized instance
    # ami_type         = "AL2_x86_64" # default ami type for nodes
    create_launch_template  = true
    enable_monitoring       = true
    update_default_version  = false
  }

  eks_managed_node_groups = {
    general = {
      desired_size = 1
      min_size     = 1
      max_size     = 2

      labels = {
        role = "general"
      }

      instance_types = ["t3.micro"]
      capacity_type  = "ON_DEMAND"
    }

    spot = {
      desired_size = 2
      min_size     = 1
      max_size     = 2

      labels = {
        role = "spot"
      }

      # taints = [{
      #   key    = "market"
      #   value  = "spot"
      #   effect = "NO_SCHEDULE"
      # }]

      taints = []
      instance_types = ["t3.medium"]
      capacity_type  = "SPOT"
    }
  }

  manage_aws_auth_configmap = true
  
  aws_auth_roles = [
    {
      rolearn  = module.eks_admins_iam_role.iam_role_arn
      username = module.eks_admins_iam_role.iam_role_name
      groups   = ["system:masters"]
    },
  ]

   # aws_auth_users =  local.auth_users
  
  # cluster_addons = {
  #   coredns = {
  #     preserve    = true
  #     most_recent = true

  #     timeouts = {
  #       create = "25m"
  #       delete = "10m"
  #     }
  #   }
  #   kube-proxy = {
  #     most_recent = true
  #   }
  #   vpc-cni = {
  #     most_recent = true
  #   }
  # }
}

resource "aws_eks_addon" "addons" {
  cluster_name = module.eks.cluster_name
  for_each = {for addon in var.eks_addons: addon.name => addon}
  addon_name = each.value.name
  addon_version = each.value.version
  resolve_conflicts = "OVERWRITE"
}


provider "kubernetes" {
  # host                   = data.aws_eks_cluster.cluster.endpoint
  host                     = module.eks.cluster_endpoint
  # cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  cluster_ca_certificate =  base64decode(module.eks.cluster_certificate_authority_data)
  # token                  = data.aws_eks_cluster_auth.default.token

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
    command     = "aws"
  }
}
