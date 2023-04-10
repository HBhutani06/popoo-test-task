resource "aws_eip" "elastic_ip" {
  tags = {
    Name = var.elasticip_name
  }
}