variable "aws_region" {
  description = "AWS region hosting the service"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Name prefix applied to every resource"
  type        = string
  default     = "shortener"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "container_port" {
  description = "Port the container listens on"
  type        = number
  default     = 8000
}

variable "image_tag" {
  description = "Tag of the image pushed to ECR"
  type        = string
  default     = "latest"
}

variable "desired_count" {
  description = "Number of Fargate tasks to keep running"
  type        = number
  default     = 2
}

variable "task_cpu" {
  description = "Fargate task CPU units"
  type        = number
  default     = 256
}

variable "task_memory" {
  description = "Fargate task memory in MiB"
  type        = number
  default     = 512
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t4g.micro"
}

variable "db_username" {
  description = "Master username for the PostgreSQL instance"
  type        = string
  default     = "shortener"
}

variable "db_password" {
  description = "Master password for the PostgreSQL instance"
  type        = string
  sensitive   = true
}

variable "log_retention_days" {
  description = "CloudWatch log retention"
  type        = number
  default     = 14
}
