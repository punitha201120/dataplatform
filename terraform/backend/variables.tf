variable "environment" {
 type = string
 default = "tfstate" 
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
