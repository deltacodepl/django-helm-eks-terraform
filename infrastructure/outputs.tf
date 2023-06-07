
output "vpc_id" {
    description = "ID of the VPC"
    value = module.vpc.vpc_id
}

output "cluster_name" {
    description = "NOQA"
    value = module.eks.cluster_name
}

output "lbc_helm_metadata" {
  description = "Metadata Block outlining status of the deployed release."
  value       = helm_release.aws_load_balancer_controller.metadata
}