########################################
## VPC - Variables ##
########################################

variable "vpc_cidr" {
  type        = string
  description = "CDIR of VPC"
  default     = "10.0.0.0/16"
}
