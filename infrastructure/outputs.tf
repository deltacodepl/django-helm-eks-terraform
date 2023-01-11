
output "vpc_id" {
    description = "ID of the VPC"
    value = module.vpc.vpc_id
}

output "cluster_name" {
    description = "NOQA"
    value = local.cluster_name
}