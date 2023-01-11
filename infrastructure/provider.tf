terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.17.1"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.1.3"
    }

    local = {
      source  = "hashicorp/local"
      version = "2.0.0"
    }

    null = {
      source  = "hashicorp/null"
      version = "3.0.0"
    }

    template = {
      source  = "hashicorp/template"
      version = "2.2.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.2"
    }
  }

  required_version = "~> 1.3.7"
}

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  token      = var.aws_session_token
  region     = var.aws_region
  
  default_tags {
    tags = {
      service     = "${lower(local.cluster_name)}"
      env         =  var.app_environment
      dataclass   = "internal"
      createdBy   = "kolszewski"
      costcenter  = "governance"
    }
  }
}
