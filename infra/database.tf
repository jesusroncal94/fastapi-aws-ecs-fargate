resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-database"
  subnet_ids = aws_subnet.private[*].id
}

resource "aws_db_instance" "main" {
  identifier             = "${var.project_name}-database"
  engine                 = "postgres"
  engine_version         = "16"
  instance_class         = var.db_instance_class
  allocated_storage      = 20
  storage_encrypted      = true
  db_name                = "shortener"
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.database.id]
  publicly_accessible    = false
  skip_final_snapshot    = true
  apply_immediately      = true
}

resource "aws_secretsmanager_secret" "database_url" {
  name                    = "${var.project_name}/database-url"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "database_url" {
  secret_id = aws_secretsmanager_secret.database_url.id
  secret_string = format(
    "postgresql+asyncpg://%s:%s@%s:5432/%s",
    var.db_username,
    var.db_password,
    aws_db_instance.main.address,
    aws_db_instance.main.db_name,
  )
}
