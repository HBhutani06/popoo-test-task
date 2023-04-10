resource "aws_subnet" "public_subnet" {
  depends_on              = [aws_vpc.vpc]
  count                   = length(var.public_subnet_cidr)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_cidr[count.index]
  map_public_ip_on_launch = true
  availability_zone       = var.public_subnet_availability_zone[count.index]

  tags = {
    Name                     = "${var.public_subnet_name} ${count.index + 1}"
    "kubernetes.io/role/elb" = 1
  }
}


resource "aws_subnet" "private_subnet" {
  depends_on        = [aws_vpc.vpc]
  count             = length(var.private_subnet_cidr)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_cidr[count.index]
  availability_zone = var.private_subnet_availability_zone[count.index]

  tags = {
    Name = "${var.private_subnet_name} ${count.index + 1}"
  }
}