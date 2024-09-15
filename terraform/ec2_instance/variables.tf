variable "environment" {
 type = string
 default = "ec1" 
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

variable "tags" {
  type = map(string)
  default = {
    Name = "MyEC2Instance"
    Environment = "dev"
  }
}
variable "sequence" {
  type = string
  default="000"
}