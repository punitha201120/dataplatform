@echo off
setlocal enabledelayedexpansion

rem Initialize Terraform with backend config
if [ -f terraform/eks2/backend-config-acco-dev.hcl ]; then
    terraform init -backend-config=terraform/eks2/backend-config-acco-dev.hcl
else
    echo "Backend config file not found!"
    exit 1
fi


rem Grant execute permission to generate-tfvars.sh (skip on Windows since it's not needed)
rem chmod +x ./generate-tfvars.sh

rem Use PowerShell to fetch VPC ID, Subnet IDs, and CIDR Block
for /f "tokens=*" %%i in ('powershell -command "(aws ec2 describe-vpcs | ConvertFrom-Json).Vpcs | Where-Object { $_.Tags.Value -eq 'default_network-dev-000' } | Select-Object -ExpandProperty VpcId"') do (
    set vpc_id=%%i
)

rem Fetch Subnet IDs for the given VPC ID
for /f "tokens=*" %%i in ('powershell -command "(aws ec2 describe-subnets --filters Name=vpc-id,Values=!vpc_id! | ConvertFrom-Json).Subnets | Select-Object -ExpandProperty SubnetId"') do (
    set subnet_ids=!subnet_ids! %%i
)

rem Fetch CIDR Block for the given VPC ID
for /f "tokens=*" %%i in ('powershell -command "(aws ec2 describe-vpcs --vpc-ids !vpc_id! --query 'Vpcs[0].CidrBlock' --output text)"') do (
    set cidr_block=%%i
)

rem Create dynamic.tfvars file
echo vpc_id = "!vpc_id!" > dynamic.tfvars
echo subnet_ids = ["!subnet_ids!"] >> dynamic.tfvars
echo cidr_blocks = ["!cidr_block!"] >> dynamic.tfvars

rem Output contents of dynamic.tfvars
echo dynamic.tfvars file created with the following content:
type dynamic.tfvars

rem Run Terraform plan and apply using the generated dynamic.tfvars
terraform plan -var-file=terraform/eks2/variables.acco.dev.tfvars -var-file=dynamic.tfvars
terraform apply -var-file=terraform/eks2/variables.acco.dev.tfvars -var-file=dynamic.tfvars -auto-approve

rem Delete dynamic.tfvars after applying Terraform
del dynamic.tfvars
echo dynamic.tfvars file has been deleted.

endlocal
