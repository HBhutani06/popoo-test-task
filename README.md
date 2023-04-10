# global-rds-cluster

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Usage

```
resource "aws_rds_global_cluster" "this" {
  global_cluster_identifier = "global-rds"
  engine                    = "aurora-postgresql"
  engine_version            = "14.5"
  database_name             = "example_db"
  storage_encrypted         = true
}

resource "aws_db_subnet_group" "subnet_group" {
  name       = "subnate-group"
  subnet_ids = module.Networking1.private_subnet_id
}

resource "aws_db_subnet_group" "subnet_group-2" {
  provider = aws.secondary
  name       = "subnate-group"
  subnet_ids = module.Networking2.private_subnet_id
}

module "aurora_primary" {
  source                    = "terraform-aws-modules/rds-aurora/aws"
  name                      = "primary-rds"
  database_name             = aws_rds_global_cluster.this.database_name
  engine                    = aws_rds_global_cluster.this.engine
  engine_version            = aws_rds_global_cluster.this.engine_version
  global_cluster_identifier = aws_rds_global_cluster.this.id
  instance_class            = "db.r6g.large"
  instances                 = { for i in range(2) : i => {} }
  vpc_id                    = module.us-east-1.vpc_id
  db_subnet_group_name      = aws_db_subnet_group.subnet_group.id
  create_db_subnet_group    = false
  publicly_accessible       = false
  create_security_group     = true
  tags                      = local.tags

  storage_encrypted = true


  master_username = "ms"
  master_password = "Temp123456"
  port            = 5432

  preferred_maintenance_window    = "Mon:00:00-Mon:03:00"
  preferred_backup_window         = "03:00-06:00"
  enabled_cloudwatch_logs_exports = ["postgresql"]
  apply_immediately               = true

  backup_retention_period     = 1
  skip_final_snapshot         = true
  deletion_protection         = false
  auto_minor_version_upgrade  = false
  allow_major_version_upgrade = true

  performance_insights_enabled          = true
  performance_insights_retention_period = 7
  create_monitoring_role                = true
  monitoring_interval                   = 60
  monitoring_role_arn                   = "example-monitoring-role-name"
}

module "aurora_secondary" {
  source = "terraform-aws-modules/rds-aurora/aws"

  providers = { aws = aws.secondary }

  is_primary_cluster = false

  name                      = "secondary-rds"
  database_name             = aws_rds_global_cluster.this.database_name
  engine                    = aws_rds_global_cluster.this.engine
  engine_version            = aws_rds_global_cluster.this.engine_version
  global_cluster_identifier = aws_rds_global_cluster.this.id
  instance_class            = "db.r6g.large"
  instances                 = { for i in range(2) : i => {} }
  vpc_id                    = module.us-east-2.vpc_id
  db_subnet_group_name      = aws_db_subnet_group.subnet_group-2.name
  create_db_subnet_group    = false
  publicly_accessible       = false
  create_security_group     = true
  tags                      = local.tags

  storage_encrypted = true
  port = 5432

  preferred_maintenance_window    = "Mon:00:00-Mon:03:00"
  preferred_backup_window         = "03:00-06:00"
  enabled_cloudwatch_logs_exports = ["postgresql"]
  apply_immediately               = true

  backup_retention_period     = 1
  skip_final_snapshot         = true
  deletion_protection         = false
  auto_minor_version_upgrade  = false
  allow_major_version_upgrade = true

  performance_insights_enabled          = true
  performance_insights_retention_period = 7
  create_monitoring_role                = true
  monitoring_interval                   = 60
  monitoring_role_arn                   = "example-monitoring-role-name"

  depends_on = [
    module.aurora_primary
  ]

  kms_key_id = aws_kms_key.secondary.arn
}
```
To initializa all the modules used in this global-cluster mudule run the init command
```
$terrafrom init
```
to preview the changes in terraform plans to make to your infrastructure execute following command
```
$ terrafrom plan 
```
optional if you want to see changes as per the environment type i.e. dev, stage, prod
```
$terrafrom plan -var-file parameter-staging.tfvars
```

once you preview the resources, run the apply command to create the resources
```
$terrafrom apply
```
or
```
$terraform apply -var-file parameter-staging.tfvars
```
To destroy all the resources created by this module, execute following command
```
$terrafrom destroy
```







## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.62.0 |
| <a name="provider_aws.secondary"></a> [aws.secondary](#provider\_aws.secondary) | 4.62.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_Networking1"></a> [Networking1](#module\_Networking1) | ./modules/vpc | n/a |
| <a name="module_Networking2"></a> [Networking2](#module\_Networking2) | ./modules/vpc | n/a |
| <a name="module_aurora_primary"></a> [aurora\_primary](#module\_aurora\_primary) | terraform-aws-modules/rds-aurora/aws | n/a |
| <a name="module_aurora_secondary"></a> [aurora\_secondary](#module\_aurora\_secondary) | terraform-aws-modules/rds-aurora/aws | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_db_subnet_group.subnet_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) | resource |
| [aws_db_subnet_group.subnet_group-2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) | resource |
| [aws_kms_key.primary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_kms_key.secondary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_rds_global_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_global_cluster) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.rds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_major_version_upgrade"></a> [allow\_major\_version\_upgrade](#input\_allow\_major\_version\_upgrade) | Enable to allow major engine version upgrades when changing engine versions. Defaults to `false` | `bool` | `true` | no |
| <a name="input_apply_immediately"></a> [apply\_immediately](#input\_apply\_immediately) | Specifies whether any cluster modifications are applied immediately, or during the next maintenance window. Default is `false` | `bool` | `true` | no |
| <a name="input_auto_minor_version_upgrade"></a> [auto\_minor\_version\_upgrade](#input\_auto\_minor\_version\_upgrade) | Indicates that minor engine upgrades will be applied automatically to the DB instance during the maintenance window. Default `true` | `bool` | `false` | no |
| <a name="input_backup_retention_period"></a> [backup\_retention\_period](#input\_backup\_retention\_period) | The days to retain backups for. Default `7` | `number` | `7` | no |
| <a name="input_create_db_subnet_group"></a> [create\_db\_subnet\_group](#input\_create\_db\_subnet\_group) | Determines whether to create the database subnet group or use existing | `bool` | `false` | no |
| <a name="input_create_monitoring_role"></a> [create\_monitoring\_role](#input\_create\_monitoring\_role) | Determines whether to create the IAM role for RDS enhanced monitoring | `bool` | `true` | no |
| <a name="input_create_security_group"></a> [create\_security\_group](#input\_create\_security\_group) | Determines whether to create security group for RDS cluster | `bool` | `true` | no |
| <a name="input_database_name"></a> [database\_name](#input\_database\_name) | The name of the Database | `string` | `"example_db"` | no |
| <a name="input_db_subnet_group_name"></a> [db\_subnet\_group\_name](#input\_db\_subnet\_group\_name) | The name of the subnet group name (existing or created) | `string` | `""` | no |
| <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection) | If the DB instance should have deletion protection enabled. The database can't be deleted when this value is set to `true`. The default is `false` | `bool` | `false` | no |
| <a name="input_elasticip_name"></a> [elasticip\_name](#input\_elasticip\_name) | Explicit values to use in the Name tag on eip | `string` | `"eip"` | no |
| <a name="input_enabled_cloudwatch_logs_exports"></a> [enabled\_cloudwatch\_logs\_exports](#input\_enabled\_cloudwatch\_logs\_exports) | Set of log types to export to cloudwatch. If omitted, no logs will be exported. The following log types are supported: `audit`, `error`, `general`, `slowquery`, `postgresql` | `list(string)` | <pre>[<br>  "postgresql"<br>]</pre> | no |
| <a name="input_engine"></a> [engine](#input\_engine) | The database engine to use | `string` | `"aurora-postgresql"` | no |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | The engine version to use | `string` | `"14.5"` | no |
| <a name="input_global_cluster_identifier"></a> [global\_cluster\_identifier](#input\_global\_cluster\_identifier) | The name of the global RDS cluster | `string` | `"global-rds"` | no |
| <a name="input_instance_class"></a> [instance\_class](#input\_instance\_class) | The compute and memory capacity of each DB instance in the Multi-AZ DB cluster, for example db.m6g.xlarge. Not all DB instance classes are available in all AWS Regions, or for all database engines | `string` | `"db.r6g.large"` | no |
| <a name="input_instances"></a> [instances](#input\_instances) | Map of cluster instances and any specific/overriding attributes to be created | `any` | `{}` | no |
| <a name="input_master_password"></a> [master\_password](#input\_master\_password) | Password for the master DB user. Note - when specifying a value here, 'create\_random\_password' should be set to `false` | `string` | `"Temp1234"` | no |
| <a name="input_master_username"></a> [master\_username](#input\_master\_username) | Username for the master DB user | `string` | `"root"` | no |
| <a name="input_monitoring_interval"></a> [monitoring\_interval](#input\_monitoring\_interval) | The interval, in seconds, between points when Enhanced Monitoring metrics are collected for instances. Set to `0` to disable. Default is `0` | `number` | `60` | no |
| <a name="input_monitoring_role_arn"></a> [monitoring\_role\_arn](#input\_monitoring\_role\_arn) | IAM role used by RDS to send enhanced monitoring metrics to CloudWatch | `string` | `"example-monitoring-role-name"` | no |
| <a name="input_nat_gateway_name"></a> [nat\_gateway\_name](#input\_nat\_gateway\_name) | Additional tags for the NAT gateway | `string` | `"ngw-1"` | no |
| <a name="input_performance_insights_enabled"></a> [performance\_insights\_enabled](#input\_performance\_insights\_enabled) | Specifies whether Performance Insights is enabled or not | `bool` | `true` | no |
| <a name="input_performance_insights_retention_period"></a> [performance\_insights\_retention\_period](#input\_performance\_insights\_retention\_period) | Amount of time in days to retain Performance Insights data. Either 7 (7 days) or 731 (2 years) | `number` | `7` | no |
| <a name="input_port"></a> [port](#input\_port) | The port on which the DB accepts connections | `string` | `"5432"` | no |
| <a name="input_preferred_backup_window"></a> [preferred\_backup\_window](#input\_preferred\_backup\_window) | The daily time range during which automated backups are created if automated backups are enabled using the `backup_retention_period` parameter. Time in UTC | `string` | `"03:00-06:00"` | no |
| <a name="input_preferred_maintenance_window"></a> [preferred\_maintenance\_window](#input\_preferred\_maintenance\_window) | The weekly time range during which system maintenance can occur, in (UTC) | `string` | `"Mon:00:00-Mon:03:00"` | no |
| <a name="input_primary_cluster_name"></a> [primary\_cluster\_name](#input\_primary\_cluster\_name) | Name used for primary cluster | `string` | `"primary-rds"` | no |
| <a name="input_primary_cluster_region"></a> [primary\_cluster\_region](#input\_primary\_cluster\_region) | region used for primary cluster | `string` | `"us-east-1"` | no |
| <a name="input_primary_db_subnet_group_name"></a> [primary\_db\_subnet\_group\_name](#input\_primary\_db\_subnet\_group\_name) | primary cluster's subnet group name | `string` | `"sg-1"` | no |
| <a name="input_primary_vpc_cidr"></a> [primary\_vpc\_cidr](#input\_primary\_vpc\_cidr) | (Optional) The IPv4 CIDR block for the VPC. CIDR can be explicitly set or it can be derived from IPAM using `ipv4_netmask_length` & `ipv4_ipam_pool_id` | `string` | `"10.0.0.0/16"` | no |
| <a name="input_primary_vpc_internet_gateway_name"></a> [primary\_vpc\_internet\_gateway\_name](#input\_primary\_vpc\_internet\_gateway\_name) | Additional tags for the internet gateway | `string` | `"igw"` | no |
| <a name="input_primary_vpc_name"></a> [primary\_vpc\_name](#input\_primary\_vpc\_name) | Name to be used on all the resources as identifier | `string` | `"vpc-rds"` | no |
| <a name="input_primary_vpc_private_subnet_availability_zone"></a> [primary\_vpc\_private\_subnet\_availability\_zone](#input\_primary\_vpc\_private\_subnet\_availability\_zone) | public subnets'AZ | `list(string)` | <pre>[<br>  "us-east-1a",<br>  "us-east-1b"<br>]</pre> | no |
| <a name="input_primary_vpc_private_subnet_cidr"></a> [primary\_vpc\_private\_subnet\_cidr](#input\_primary\_vpc\_private\_subnet\_cidr) | A list of public subnets inside the VPC | `list(string)` | <pre>[<br>  "10.0.48.0/20",<br>  "10.0.64.0/20"<br>]</pre> | no |
| <a name="input_primary_vpc_public_subnet_availability_zone"></a> [primary\_vpc\_public\_subnet\_availability\_zone](#input\_primary\_vpc\_public\_subnet\_availability\_zone) | public subnets'AZ | `list(string)` | <pre>[<br>  "us-east-1a",<br>  "us-east-1b"<br>]</pre> | no |
| <a name="input_primary_vpc_public_subnet_cidr"></a> [primary\_vpc\_public\_subnet\_cidr](#input\_primary\_vpc\_public\_subnet\_cidr) | A list of public subnets inside the VPC | `list(string)` | <pre>[<br>  "10.0.0.0/20"<br>]</pre> | no |
| <a name="input_private_route_table_name"></a> [private\_route\_table\_name](#input\_private\_route\_table\_name) | Additional tags for the Route private table | `string` | `"private-rt"` | no |
| <a name="input_private_subnet_name"></a> [private\_subnet\_name](#input\_private\_subnet\_name) | Explicit values to use in the Name tag on private subnets. If empty, Name tags are generated | `string` | `"private-subnets"` | no |
| <a name="input_public_route_table_name"></a> [public\_route\_table\_name](#input\_public\_route\_table\_name) | Additional tags for the public route table | `string` | `"public-rt"` | no |
| <a name="input_public_subnet_name"></a> [public\_subnet\_name](#input\_public\_subnet\_name) | Explicit values to use in the Name tag on public subnets. If empty, Name tags are generated | `string` | `"public-subnets"` | no |
| <a name="input_publicly_accessible"></a> [publicly\_accessible](#input\_publicly\_accessible) | Determines whether instances are publicly accessible. Default false | `bool` | `false` | no |
| <a name="input_secondary_cluster_name"></a> [secondary\_cluster\_name](#input\_secondary\_cluster\_name) | Name used for secondary cluster | `string` | `"secondary-rds"` | no |
| <a name="input_secondary_cluster_region"></a> [secondary\_cluster\_region](#input\_secondary\_cluster\_region) | region used for secondary cluster | `string` | `"us-east-2"` | no |
| <a name="input_secondary_db_subnet_group_name"></a> [secondary\_db\_subnet\_group\_name](#input\_secondary\_db\_subnet\_group\_name) | primary cluster's subnet group name | `string` | `"sg-2"` | no |
| <a name="input_secondary_vpc_cidr"></a> [secondary\_vpc\_cidr](#input\_secondary\_vpc\_cidr) | The IPv4 CIDR block for the VPC. CIDR can be explicitly set or it can be derived from IPAM using `ipv4_netmask_length` & `ipv4_ipam_pool_id` | `string` | `"10.1.0.0/16"` | no |
| <a name="input_secondary_vpc_internet_gateway_name"></a> [secondary\_vpc\_internet\_gateway\_name](#input\_secondary\_vpc\_internet\_gateway\_name) | Additional tags for the internet gateway | `string` | `"igw"` | no |
| <a name="input_secondary_vpc_name"></a> [secondary\_vpc\_name](#input\_secondary\_vpc\_name) | Name to be used on all the resources as identifier | `string` | `"vpc-rds"` | no |
| <a name="input_secondary_vpc_private_subnet_availability_zone"></a> [secondary\_vpc\_private\_subnet\_availability\_zone](#input\_secondary\_vpc\_private\_subnet\_availability\_zone) | public subnets'AZ | `list(string)` | <pre>[<br>  "us-east-2a",<br>  "us-east-2b"<br>]</pre> | no |
| <a name="input_secondary_vpc_private_subnet_cidr"></a> [secondary\_vpc\_private\_subnet\_cidr](#input\_secondary\_vpc\_private\_subnet\_cidr) | A list of public subnets inside the VPC | `list(string)` | <pre>[<br>  "10.1.48.0/20",<br>  "10.1.64.0/20"<br>]</pre> | no |
| <a name="input_secondary_vpc_public_subnet_availability_zone"></a> [secondary\_vpc\_public\_subnet\_availability\_zone](#input\_secondary\_vpc\_public\_subnet\_availability\_zone) | public subnets'AZ | `list(string)` | <pre>[<br>  "us-east-2a",<br>  "us-east-2b"<br>]</pre> | no |
| <a name="input_secondary_vpc_public_subnet_cidr"></a> [secondary\_vpc\_public\_subnet\_cidr](#input\_secondary\_vpc\_public\_subnet\_cidr) | A list of public subnets inside the VPC | `list(string)` | <pre>[<br>  "10.1.0.0/20"<br>]</pre> | no |
| <a name="input_skip_final_snapshot"></a> [skip\_final\_snapshot](#input\_skip\_final\_snapshot) | Determines whether a final snapshot is created before the cluster is deleted. If true is specified, no snapshot is created | `bool` | `true` | no |
| <a name="input_storage_encrypted"></a> [storage\_encrypted](#input\_storage\_encrypted) | Specifies whether the DB instance is encrypted | `bool` | `true` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | <pre>{<br>  "Name": "global_cluster"<br>}</pre> | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of the VPC where to create security group | `string` | `""` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
