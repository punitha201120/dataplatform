resource "aws_db_instance" "postgress" {
  for_each = var.resource_names["rds"]  # Correcting the key to "rds"

  allocated_storage      = 10
  storage_type           = "gp2"
  engine                 = "postgres"
  engine_version         = "16.4"
  instance_class         = "db.t3.micro"
  identifier              = "mypgdb"           # Unique identifier for PostgreSQL instance
  username                = var.user         # PostgreSQL username
  password                = var.password      # PostgreSQL password
  vpc_security_group_ids  = ["sg-05a3f941d919e01ee"]
  db_subnet_group_name    = aws_db_subnet_group.default.name 
  skip_final_snapshot     = true               # Skip final snapshot when deleting

  # Optional configurations for enhanced functionality
  publicly_accessible     = false              # Ensure the DB is private (false by default)
  multi_az                = false              # True when we need the azs
  auto_minor_version_upgrade = true            # Automatically upgrade minor versions
#   backup_retention_period = 7                  # Number of days to retain backups
}

resource "aws_db_subnet_group" "default" {
  name       = "my-db-subnet-group"
  subnet_ids = ["subnet-08708a9cd4a448ec3", "subnet-0fb52af5151ae567d"]

  tags = {
    Name = "My DB Subnet Group"
  }
}

