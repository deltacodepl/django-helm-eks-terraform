########################################
## VPC - Variables ##
########################################

variable "vpc_cidr" {
  type        = string
  description = "CDIR of VPC"
  default     = "10.0.0.0/16"
}

variable "route53_hosted_zone" {
  type = string
}

variable "eks_addons" {
  type = list(object({
    name = string
    version = string
  }))


  default = [ {
    name = "coredns"
    # version = "v1.10.1-eksbuild.1"
    version = "v1.9.3-eksbuild.2"
  },
  {
    name = "kube-proxy"
    # version = "v1.27.1-eksbuild.1"
    version = "v1.25.9-eksbuild.1"
  },
  {
    name = "vpc-cni"
    version = "v1.12.6-eksbuild.2"
  },
  {
    name = "aws-ebs-csi-driver"
    version = "v1.19.0-eksbuild.2"
  } ]

}

variable "auth_users" {
  type = list(object( {
    username = string
    rolearn = string
    groups = string
  }))

  
}