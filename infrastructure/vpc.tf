data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  # https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.18.1"

  name                 = "${var.app_name}-vpc"
  cidr                 = "10.0.0.0/16"
  azs                  = local.azs
  private_subnets      = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 10)]
  public_subnets       = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k)]
  
  enable_nat_gateway   = true
  single_nat_gateway   = true
  one_nat_gateway_per_az = false
  enable_dns_support   = true
  enable_dns_hostnames = true
  
  
  # for auto service discovery
  tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
  }
}
