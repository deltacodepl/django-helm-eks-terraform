resource "random_string" "suffix" {
  length = 8
  special = false
}

data "aws_availability_zones" "available" {
  state = "available"
}


locals {

  # cluster_name = "${basename(path.cwd)}-${random_string.suffix.result}"
  cluster_name = "${var.app_name}"

  # numList = [1, 2, 3, 4, 5]
  # sumList = sum([for x in local.numList : x * 10 if x % 2 == 0])

  vpc_cidr = var.vpc_cidr
  azs      = slice(data.aws_availability_zones.available.names, 0, 2)

  node_group_name = "managed-ondemand"

}