terraform {
  required_version = ">= 1.6"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}



provider "aws" {
  region = var.aws_region
}


module "network" {
  source       = "../../modules/network"
  project_name = var.project_name
  environment  = var.environment
}

module "security" {
  source       = "../../modules/security"
  project_name = var.project_name
  environment  = var.environment
  vpc_id        = module.network.vpc_id
  db_secret_arn = module.database.db_secret_arn
}


module "database" {
  source          = "../../modules/database"
  project_name    = var.project_name
  environment     = var.environment
  vpc_id          = module.network.vpc_id
  private_subnets = module.network.private_subnets
  db_sg           = module.security.db_sg_id
}

module "compute" {
  source         = "../../modules/compute"
  project_name   = var.project_name
  environment    = var.environment
  vpc_id          = module.network.vpc_id
  public_subnets  = module.network.public_subnets
  private_subnets = module.network.private_subnets
  alb_sg          = module.security.alb_sg_id

  ecs_execution_role_arn = module.security.ecs_execution_role_arn
  ecs_task_role_arn      = module.security.ecs_task_role_arn
  db_secret_arn          = module.database.db_secret_arn
  domain_name            = "digikraaft.com"
  hosted_zone_id         = "Z00000000000000000000" # MOCK ZONE ID
}




module "observability" {
  source       = "../../modules/observability"
  project_name = var.project_name
  environment  = var.environment
}