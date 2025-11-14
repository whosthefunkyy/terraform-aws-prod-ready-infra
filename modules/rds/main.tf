resource "aws_db_subnet_group" "this" {
  name       = "${var.env}-db-subnet-group"
  subnet_ids = var.subnets

  tags = {
    Name = "${var.env}-db-subnet-group"
  }
}

resource "aws_db_instance" "this" {
  identifier              = "${var.env}-db"
  allocated_storage       = 20
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  db_name                 = var.db_name
  username                = var.db_username
  password                = var.db_password

  vpc_security_group_ids  = var.vpc_security_group_ids
  db_subnet_group_name    = aws_db_subnet_group.this.name
  skip_final_snapshot     = true

  tags = {
    Name = "${var.env}-rds"
  }
}
