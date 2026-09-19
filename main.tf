#terraform configuration
terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = ">=2.2.0"
    }
  }
}

#credentials and provider configuration
provider "aws" {
  region     = "us-east-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

module "Compute" {
  source               = "./modules/Compute"
  public_subnet_id     = module.Networking.public_subnet_id
  security_group_id    = module.Security.security_group_id
  iam_instance_profile = module.Security.ec2_instance_profile_name
  log_group_name       = module.Logging_pipeline.log_group_name
}

module "Lambda_functions" {
  source          = "./modules/Lambda_functions"
  s3_bucket_arn   = module.Storage.s3_bucket_arn
  s3_bucket_id    = module.Storage.s3_bucket_id
  lambda_role_arn = module.Security.lambda_role_arn
  log_group_arn   = module.Logging_pipeline.log_group_arn
  log_group_name  = module.Logging_pipeline.log_group_name
  sns_topic_arn   = module.Messaging.sns_topic_arn
}

module "Logging_pipeline" {
  source = "./modules/Logging_pipeline"
}

module "Messaging" {
  source         = "./modules/Messaging"
}

module "Monitoring" {
  source                     = "./modules/Monitoring"
  ec2_instance1_id           = module.Compute.instance1_id
  ec2_instance2_id           = module.Compute.instance2_id
  sns_topic_arn              = module.Messaging.sns_topic_arn
  sns_topic_name             = module.Messaging.sns_topic_name
  log_group_name             = module.Logging_pipeline.log_group_name
  log_delivery_function_name = module.Lambda_functions.log_delivery_function_name
  log_analysis_function_name = module.Lambda_functions.log_analysis_function_name
  remediation_function_name  = module.Lambda_functions.remediation_function_name
  aws_region                 = "us-east-1"
}

module "Networking" {
  source = "./modules/Networking"
}

module "Security" {
  source = "./modules/Security"
  vpc_id = module.Networking.vpc_id
}

module "Storage" {
  source = "./modules/Storage"
}
