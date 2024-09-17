@echo off
setlocal enabledelayedexpansion

rem Grant execute permission to generate-tfvars.sh (skip on Windows since it's not needed)
rem chmod +x ./generate-tfvars.sh

rem Use PowerShell to fetch VPC ID
for /f "tokens=*" %%i in ('powershell -command "(aws ec2 describe-vpcs | ConvertFrom-Json).Vpcs | Where-Object { $_.Tags.Value -eq ''default_network-dev-000'' } | Select-Object -ExpandProperty VpcId"') do (
    set vpc_id=%%i
)

rem Initialize subnet_ids variable
set subnet_ids=

rem Fetch Subnet IDs for the given VPC ID and format them as a JSON array
for /f "tokens=*" %%i in ('powershell -command "(aws ec2 describe-subnets --filters Name=vpc-id,Values=!vpc_id! | ConvertFrom-Json).Subnets | Select-Object -ExpandProperty SubnetId"') do (
    set "subnet_ids=!subnet_ids!, \"%%i\""
)

rem Remove leading comma from the subnet_ids variable
set subnet_ids=!subnet_ids:~1!

rem Fetch CIDR Block for the given VPC ID
for /f "tokens=*" %%i in ('powershell -command "(aws ec2 describe-vpcs --vpc-ids !vpc_id! --query ''Vpcs[0].CidrBlock'' --output text)"') do (
    set cidr_block=%%i
)

rem Create dynamic.tfvars file
echo vpc_id = "!vpc_id!" > dynamic.tfvars
echo subnet_ids = [!subnet_ids!] >> dynamic.tfvars
echo cidr_blocks = ["!cidr_block!"] >> dynamic.tfvars

rem Output contents of dynamic.tfvars
type dynamic.tfvars

endlocal
