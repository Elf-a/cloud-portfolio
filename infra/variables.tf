variable "aws_region" {
  type        = string
  description = "AWS region (e.g. eu-central-1, eu-north-1)"
  default     = "eu-north-1"
}

variable "env" {
  type        = string
  description = "Environment name"
  default     = "prod"
}

variable "project" {
  type        = string
  description = "Project tag/name prefix"
  default     = "cloud-portfolio"
}

variable "db_name" {
  type    = string
  default = "laravel"
}

variable "db_username" {
  type    = string
  default = "laravel"
}

variable "db_password" {
  type    = string
  default = "laraveldemo"
}

variable "db_instance_class" {
  type    = string
  default = "db.t4g.micro"
}