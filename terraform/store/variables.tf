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
  type= string
  default="000"
}
