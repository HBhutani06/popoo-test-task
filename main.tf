data "aws_caller_identity" "current" {}

resource "aws_rds_global_cluster" "this" {
  global_cluster_identifier = var.global_cluster_identifier
  engine                    = var.engine
  engine_version            = var.engine_version
  database_name             = var.database_name
  storage_encrypted         = var.storage_encrypted
}

module "aurora_primary" {
  source                    = "terraform-aws-modules/rds-aurora/aws"
  name                      = var.primary_cluster_name
  database_name             = aws_rds_global_cluster.this.database_name
  engine                    = aws_rds_global_cluster.this.engine
  engine_version            = aws_rds_global_cluster.this.engine_version
  global_cluster_identifier = aws_rds_global_cluster.this.id
  instance_class            = var.instance_class
  instances                 = { for i in range(2) : i => {} }
  vpc_id                    = module.us-east-1.vpc_id
  db_subnet_group_name      = aws_db_subnet_group.subnet_group.id
  publicly_accessible       = var.publicly_accessible
  create_security_group     = var.create_security_group
  tags                      = var.tags

  storage_encrypted = var.storage_encrypted


  master_username = var.master_username
  master_password = var.master_password
  port            = var.port

  preferred_maintenance_window    = var.preferred_maintenance_window
  preferred_backup_window         = var.preferred_backup_window
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
  apply_immediately               = var.apply_immediately

  backup_retention_period     = var.backup_retention_period
  skip_final_snapshot         = var.skip_final_snapshot
  deletion_protection         = var.deletion_protection
  auto_minor_version_upgrade  = var.auto_minor_version_upgrade
  allow_major_version_upgrade = var.allow_major_version_upgrade

  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_retention_period = var.performance_insights_retention_period
  create_monitoring_role                = var.create_monitoring_role
  monitoring_interval                   = var.monitoring_interval
  monitoring_role_arn                   = var.monitoring_role_arn

  kms_key_id = aws_kms_key.primary.arn
}

module "aurora_secondary" {
  source = "terraform-aws-modules/rds-aurora/aws"

  providers = { aws = aws.secondary }

  is_primary_cluster = false

  name                      = var.secondary_cluster_name
  database_name             = aws_rds_global_cluster.this.database_name
  engine                    = aws_rds_global_cluster.this.engine
  engine_version            = aws_rds_global_cluster.this.engine_version
  global_cluster_identifier = aws_rds_global_cluster.this.id
  instance_class            = var.instance_class
  instances                 = { for i in range(2) : i => {} }
  vpc_id                    = module.us-east-2.vpc_id
  db_subnet_group_name      = aws_db_subnet_group.subnet_group.id
  publicly_accessible       = var.publicly_accessible
  create_security_group     = var.create_security_group
  tags                      = var.tags

  storage_encrypted = var.storage_encrypted
  port            = var.port

  preferred_maintenance_window    = var.preferred_maintenance_window
  preferred_backup_window         = var.preferred_backup_window
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
  apply_immediately               = var.apply_immediately

  backup_retention_period     = var.backup_retention_period
  skip_final_snapshot         = var.skip_final_snapshot
  deletion_protection         = var.deletion_protection
  auto_minor_version_upgrade  = var.auto_minor_version_upgrade
  allow_major_version_upgrade = var.allow_major_version_upgrade

  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_retention_period = var.performance_insights_retention_period
  create_monitoring_role                = var.create_monitoring_role
  monitoring_interval                   = var.monitoring_interval
  monitoring_role_arn                   = var.monitoring_role_arn

  depends_on = [
    module.aurora_primary
  ]

  kms_key_id = aws_kms_key.secondary.arn
}