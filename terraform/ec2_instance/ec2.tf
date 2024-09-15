
resource "aws_instance" "ec2_server" {
  # for_each=var.resource_names["ec2_instance"]
  # name = format("%s-%s-%s",each.value["name"],var.environment,var.sequence)
  ami           = "ami-09efc42336106d2f2"
  instance_type = "c4.xlarge"
  vpc_security_group_ids = ["sg-05a3f941d919e01ee"]   # Reference the security group if needed
  subnet_id              = "subnet-009ea10fb3f5fb9ed" 
  tags = {
    Name = "ec2"
  }
}

# resource "aws_instance" "ec2_server" {
#    for_each = var.resource_names 
#    ami = "ami-09efc42336106d2f2" 
#    instance_type = "c4.xlarge"
#     tags = merge(var.tags, { Name = format("%s-%s-%s", each.value.name, var.environment, var.sequence) 
#     }
#     ) 
#   }