variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "public_subnets" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "private_subnets" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "alb_sg" {
  description = "Security Group ID for ALB"
  type        = string
}

variable "container_image" {
  description = "Docker image to run"
  type        = string
  default     = "nginx:latest"
}

variable "container_port" {
  description = "Port exposed by the container"
  type        = number
  default     = 80
}

variable "ecs_execution_role_arn" {
  description = "ARN of the ECS execution role"
  type        = string
}

variable "ecs_task_role_arn" {
  description = "ARN of the ECS task role"
  type        = string
}

variable "db_secret_arn" {
  description = "ARN of the database secret"
  type        = string
}

variable "domain_name" {
  description = "Domain name for the application (e.g., example.com)"
  type        = string
}

variable "hosted_zone_id" {
  description = "Route53 Hosted Zone ID for the domain"
  type        = string
}
