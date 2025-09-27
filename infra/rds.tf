data "aws_subnets" "default_all" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "aws_db_subnet_group" "this" {
  name       = "${var.project}-db-subnets"
  subnet_ids = data.aws_subnets.default_all.ids
  tags = {
    Name = "${var.project}-db-subnets"
  }
}

resource "aws_db_instance" "postgres" {
  identifier        = var.project
  engine            = "postgres"
  instance_class    = var.db_instance_class
  allocated_storage = 20
  storage_type      = "gp3"

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password


  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name   = aws_db_subnet_group.this.name

  publicly_accessible = false
  skip_final_snapshot = true
  deletion_protection = false
}
