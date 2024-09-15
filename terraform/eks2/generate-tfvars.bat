#!/bin/bash
terraform init -backend-config=backend-config-acco-dev.hcl
chmod +x ./generate-tfvars.sh

# Fetch VPC ID based on VPC tag name
vpc_id=$(aws ec2 describe-vpcs | jq -r '.Vpcs[] | select(.Tags[].Value == "default_network-dev-000") | .VpcId')

# Fetch Subnet IDs for the given VPC ID
subnet_ids=$(aws ec2 describe-subnets --filters "Name=vpc-id,Values=$vpc_id" | jq -r '.Subnets[].SubnetId' | jq -R -s 'split("\n") | map(select(length > 0))')

# Fetch CIDR block for the given VPC ID
cidr_blocks=$(aws ec2 describe-vpcs --vpc-ids $vpc_id --query "Vpcs[0].CidrBlock" --output text)

# Create the dynamic.tfvars file and populate it with the VPC ID, subnet IDs, and CIDR blocks
echo "vpc_id = \"$vpc_id\"" >> dynamic.tfvars
subnet_ids=$(echo $subnet_ids | jq -c '.')
echo "subnet_ids = $subnet_ids" >> dynamic.tfvars
echo "cidr_blocks = [\"$cidr_blocks\"]" >> dynamic.tfvars

# Output the contents of the dynamic.tfvars file
echo "dynamic.tfvars file created with the following content:"
cat dynamic.tfvars

# Plan the Terraform configuration with the dynamic.tfvars file
terraform plan -var-file variables.acco.dev.tfvars -var-file dynamic.tfvars
# Apply the Terraform configuration with the dynamic.tfvars file
terraform apply -var-file variables.acco.dev.tfvars -var-file dynamic.tfvars -auto-approve
# After applying the Terraform configuration, delete the dynamic.tfvars file
rm -f dynamic.tfvars
echo "dynamic.tfvars file has been deleted."





