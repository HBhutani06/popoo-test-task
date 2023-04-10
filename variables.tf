variable "primary_cluster_region" {
  description = "region used for primary cluster"
  type        = string
  default     = "us-east-1"
}

variable "secondary_cluster_region" {
  description = "region used for secondary cluster"
  type        = string
  default     = "us-east-2"
}


variable "primary_vpc_cidr" {
  description = "(Optional) The IPv4 CIDR block for the VPC. CIDR can be explicitly set or it can be derived from IPAM using `ipv4_netmask_length` & `ipv4_ipam_pool_id`"
  type        = string
  default     = "10.0.0.0/16"
}

variable "secondary_vpc_cidr" {
  description = "The IPv4 CIDR block for the VPC. CIDR can be explicitly set or it can be derived from IPAM using `ipv4_netmask_length` & `ipv4_ipam_pool_id`"
  type        = string
  default     = "10.1.0.0/16"
}

variable "primary_vpc_name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = "vpc-rds"
}

variable "secondary_vpc_name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = "vpc-rds"
}

variable "public_subnet_name" {
  description = "Explicit values to use in the Name tag on public subnets. If empty, Name tags are generated"
  type = string
  default = "public-subnets"
}

variable "primary_vpc_public_subnet_cidr" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = ["10.0.0.0/20"]
}

variable "secondary_vpc_public_subnet_cidr" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = ["10.1.0.0/20"]
}

variable "primary_vpc_public_subnet_availability_zone" {
  description = "public subnets'AZ"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "secondary_vpc_public_subnet_availability_zone" {
  description = "public subnets'AZ"
  type        = list(string)
  default     = ["us-east-2a", "us-east-2b"]
}

variable "private_subnet_name" {
  description = "Explicit values to use in the Name tag on private subnets. If empty, Name tags are generated"
  type = string
  default = "private-subnets"
}

variable "primary_vpc_private_subnet_cidr" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = ["10.0.48.0/20","10.0.64.0/20"]
}

variable "primary_vpc_private_subnet_availability_zone" {
  description = "public subnets'AZ"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "secondary_vpc_private_subnet_cidr" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = ["10.1.48.0/20","10.1.64.0/20"]
}

variable "secondary_vpc_private_subnet_availability_zone" {
  description = "public subnets'AZ"
  type        = list(string)
  default     = ["us-east-2a", "us-east-2b"]
}

variable "elasticip_name" {
  description = "Explicit values to use in the Name tag on eip"
  type        = string
  default     = "eip"
}

variable "primary_vpc_internet_gateway_name" {
  description = "Additional tags for the internet gateway"
  type        = string
  default     = "igw"
}

variable "secondary_vpc_internet_gateway_name" {
  description = "Additional tags for the internet gateway"
  type        = string
  default     = "igw"
}

variable "nat_gateway_name" {
  description = "Additional tags for the NAT gateway"
  type        = string
  default     = "ngw-1"
}

variable "private_route_table_name" {
  description = "Additional tags for the Route private table"
  type        = string
  default     = "private-rt"
}

variable "public_route_table_name" {
  description = "Additional tags for the public route table"
  type        = string
  default     = "public-rt"
}

################################################################################
# DB Subnate Groupt
################################################################################

variable "primary_db_subnet_group_name" {
  description = "primary cluster's subnet group name"
  default = "sg-1"
}

variable "secondary_db_subnet_group_name" {
  description = "primary cluster's subnet group name"
  default = "sg-2"
}


################################################################################
# RDS Cluster
################################################################################

variable "global_cluster_identifier" {
  description = "The name of the global RDS cluster"
  type        = string
  default = "global-rds"
}

variable "engine" {
  description = "The database engine to use"
  type        = string
  default     = "aurora-postgresql"
}

variable "engine_version" {
  description = "The engine version to use"
  type        = string
  default     =  "14.5"
}

variable "database_name" {
  description = "The name of the Database"
  type        = string
  default     = "example_db"
}

variable "storage_encrypted" {
  description = "Specifies whether the DB instance is encrypted"
  type        = bool
  default     = true
}

variable "primary_cluster_name" {
  description = "Name used for primary cluster"
  type        = string
  default     = "primary-rds"
}

variable "secondary_cluster_name" {
  description = "Name used for secondary cluster"
  type        = string
  default     = "secondary-rds"
}

variable "instance_class" {
  description = "The compute and memory capacity of each DB instance in the Multi-AZ DB cluster, for example db.m6g.xlarge. Not all DB instance classes are available in all AWS Regions, or for all database engines"
  type        = string
  default     = "db.r6g.large"
}

variable "instances" {
  description = "Map of cluster instances and any specific/overriding attributes to be created"
  type        = any
  default     = {}
}

variable "vpc_id" {
  description = "ID of the VPC where to create security group"
  type        = string
  default     = ""
}

variable "db_subnet_group_name" {
  description = "The name of the subnet group name (existing or created)"
  type        = string
  default     = ""
}

variable "create_db_subnet_group" {
  description = "Determines whether to create the database subnet group or use existing"
  type        = bool
  default     = false
}

variable "publicly_accessible" {
  description = "Determines whether instances are publicly accessible. Default false"
  type        = bool
  default     = false
}

variable "create_security_group" {
  description = "Determines whether to create security group for RDS cluster"
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {
    Name = "global_cluster"
  }
}

variable "master_username" {
  description = "Username for the master DB user"
  type        = string
  default     = "root"
}

variable "master_password" {
  description = "Password for the master DB user. Note - when specifying a value here, 'create_random_password' should be set to `false`"
  type        = string
  default     = "Temp1234"
}

variable "port" {
  description = "The port on which the DB accepts connections"
  type        = string
  default     = "5432"
}

variable "preferred_maintenance_window" {
  description = "The weekly time range during which system maintenance can occur, in (UTC)"
  type        = string
  default     = "Mon:00:00-Mon:03:00"
}

variable "preferred_backup_window" {
  description = "The daily time range during which automated backups are created if automated backups are enabled using the `backup_retention_period` parameter. Time in UTC"
  type        = string
  default     = "03:00-06:00"
}

variable "enabled_cloudwatch_logs_exports" {
  description = "Set of log types to export to cloudwatch. If omitted, no logs will be exported. The following log types are supported: `audit`, `error`, `general`, `slowquery`, `postgresql`"
  type        = list(string)
  default     = ["postgresql"]
}

variable "apply_immediately" {
  description = "Specifies whether any cluster modifications are applied immediately, or during the next maintenance window. Default is `false`"
  type        = bool
  default     = true
}

variable "backup_retention_period" {
  description = "The days to retain backups for. Default `7`"
  type        = number
  default     = 7
}

variable "skip_final_snapshot" {
  description = "Determines whether a final snapshot is created before the cluster is deleted. If true is specified, no snapshot is created"
  type        = bool
  default     = true
}

variable "deletion_protection" {
  description = "If the DB instance should have deletion protection enabled. The database can't be deleted when this value is set to `true`. The default is `false`"
  type        = bool
  default     = false
}

variable "auto_minor_version_upgrade" {
  description = "Indicates that minor engine upgrades will be applied automatically to the DB instance during the maintenance window. Default `true`"
  type        = bool
  default     = false
}

variable "allow_major_version_upgrade" {
  description = "Enable to allow major engine version upgrades when changing engine versions. Defaults to `false`"
  type        = bool
  default     = true
}

variable "performance_insights_enabled" {
  description = "Specifies whether Performance Insights is enabled or not"
  type        = bool
  default     = true
}

variable "performance_insights_retention_period" {
  description = "Amount of time in days to retain Performance Insights data. Either 7 (7 days) or 731 (2 years)"
  type        = number
  default     = 7
}

variable "create_monitoring_role" {
  description = "Determines whether to create the IAM role for RDS enhanced monitoring"
  type        = bool
  default     = true
}

variable "monitoring_interval" {
  description = "The interval, in seconds, between points when Enhanced Monitoring metrics are collected for instances. Set to `0` to disable. Default is `0`"
  type        = number
  default     = 60
}

variable "monitoring_role_arn" {
  description = "IAM role used by RDS to send enhanced monitoring metrics to CloudWatch"
  type        = string
  default     = "example-monitoring-role-name"
}