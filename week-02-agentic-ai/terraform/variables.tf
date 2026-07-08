variable "region" {
  description = "AWS region for the deployment"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Name used for tagging and resource naming"
  type        = string
  default     = "portfolio-site"
}

variable "environment" {
  description = "Environment name for the deployment"
  type        = string
  default     = "production"
}

variable "domain_name" {
  description = "Optional custom domain name for the website"
  type        = string
  default     = ""
}
