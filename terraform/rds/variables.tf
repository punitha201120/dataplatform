variable "environment" {
 type = string
 default = "d1" 
}

variable "prefix" {
  type = string
}
variable "aws_region"{
  type = string
  default = "us-east-2"
}

variable resource_names {
  type        = any
}

variable tags {
  type = any
}
variable sequence {
  type = string
  default ="010"
}

variable user {
  description = "The username for the PostgreSQL instance"
  type        = string
}

variable password {
  description = "The password for the PostgreSQL instance"
  type        = string
  sensitive   = true    # This ensures that the password is handled securely
}
