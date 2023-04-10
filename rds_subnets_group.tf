resource "aws_db_subnet_group" "subnet_group" {
  name       = var.primary_db_subnet_group_name
  subnet_ids = module.us-east-1.private_subnet_id
}

resource "aws_db_subnet_group" "subnet_group-2" {
  provider = aws.secondary
  name       = var.secondary_db_subnet_group_name
  subnet_ids = module.us-east-2.private_subnet_id
}