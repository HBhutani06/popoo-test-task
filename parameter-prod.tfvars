primary_cluster_region = "us-east-1"
secondary_cluster_region = "us-east-2"
primary_vpc_cidr = "10.0.0.0/16"
secondary_vpc_cidr = "10.1.0.0/16"
primary_vpc_name = "prod-vpc-rds"
secondary_vpc_name = "prod-vpc-rds"
public_subnet_name = "prod-public-subnets"
primary_vpc_public_subnet_cidr = ["10.0.0.0/20"]
secondary_vpc_public_subnet_cidr = ["10.1.0.0/20"]
primary_vpc_public_subnet_availability_zone = ["us-east-1a", "us-east-1b"]
secondary_vpc_public_subnet_availability_zone = ["us-east-2a", "us-east-2b"]
private_subnet_name = "prod-private-subnets"
primary_vpc_private_subnet_cidr = ["10.0.48.0/20","10.0.64.0/20"]
primary_vpc_private_subnet_availability_zone = ["us-east-1a", "us-east-1b"]
secondary_vpc_private_subnet_cidr = ["10.1.48.0/20","10.1.64.0/20"]
secondary_vpc_private_subnet_availability_zone = ["us-east-2a", "us-east-2b"]
elasticip_name = "prod-eip"
primary_vpc_internet_gateway_name = "prod-igw"
secondary_vpc_internet_gateway_name = "prod-igw"
nat_gateway_name = "prod-ngw-1"
private_route_table_name = "prod-private-rt"
public_route_table_name = "prod-public-rt"

################################################################################
# DB Subnate Group
################################################################################

primary_db_subnet_group_name = "prod-sg-1"
secondary_db_subnet_group_name = "prod-sg-2"

################################################################################
# RDS Cluster
################################################################################

global_cluster_identifier = "prod-global-rds"
engine = "aurora-postgresql"
engine_version =  "14.5"
database_name = "prod-example_db"
storage_encrypted = "true"
primary_cluster_name = "prod-primary-rds"
secondary_cluster_name = "prod-secondary-rds"
instance_class = "db.r6g.large"
db_subnet_group_name = "prod-db_subnets_group"
create_db_subnet_group = "false"
publicly_accessible = "false"
create_security_group = "true"
tags = {
    Name = "prod-global_cluster"
  }
master_username = "root"
master_password = "Temp1234"
port = "5432"
preferred_maintenance_window = "Mon:00:00-Mon:03:00"
preferred_backup_window = "03:00-06:00"
enabled_cloudwatch_logs_exports = ["postgresql"]
apply_immediately = "true"
backup_retention_period = "7"
skip_final_snapshot = "true"
deletion_protection = "false"
auto_minor_version_upgrade = "false"
allow_major_version_upgrade = "true"
performance_insights_enabled = "true"
performance_insights_retention_period = "7"
create_monitoring_role = "true"
monitoring_interval = "60"
monitoring_role_arn = "example-monitoring-role-name"