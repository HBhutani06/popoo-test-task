module "us-east-1" {
  source               = "./modules/vpc"
  vpc_cidr                         = var.primary_vpc_cidr
  vpc_name                         = var.primary_vpc_name
  public_subnet_name               = var.public_subnet_name
  public_subnet_cidr               = var.primary_vpc_public_subnet_cidr
  public_subnet_availability_zone  = var.primary_vpc_public_subnet_availability_zone
  private_subnet_name              = var.private_subnet_name
  private_subnet_cidr              = var.primary_vpc_private_subnet_cidr
  private_subnet_availability_zone = var.primary_vpc_private_subnet_availability_zone
  elasticip_name                   = var.elasticip_name
  internet_gateway_name            = var.primary_vpc_internet_gateway_name
  nat_gateway_name                 = var.nat_gateway_name
  private_route_table_name         = var.private_route_table_name
  public_route_table_name          = var.public_route_table_name
}

module "us-east-2" {
  source               = "./modules/vpc"

  providers = { aws = aws.secondary } 

  vpc_cidr                         = var.secondary_vpc_cidr
  vpc_name                         = var.secondary_vpc_name
  public_subnet_name               = var.public_subnet_name
  public_subnet_cidr               = var.secondary_vpc_public_subnet_cidr
  public_subnet_availability_zone  = var.secondary_vpc_public_subnet_availability_zone
  private_subnet_name              = var.private_subnet_name
  private_subnet_cidr              = var.secondary_vpc_private_subnet_cidr
  private_subnet_availability_zone = var.secondary_vpc_private_subnet_availability_zone
  elasticip_name                   = var.elasticip_name
  internet_gateway_name            = var.secondary_vpc_internet_gateway_name
  nat_gateway_name                 = var.nat_gateway_name
  private_route_table_name         = var.private_route_table_name
  public_route_table_name          = var.public_route_table_name
}