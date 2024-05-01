
#resource "aws_default_vpc" "default" {} # This need to be added since AWS Provider v4.29+ to get VPC id

module "vpc-default" {
  source = "../aws_network"
}

resource "aws_security_group" "my_sg" {
  name   = "My Security Group"
  vpc_id = module.vpc-default.vpc_id # This need to be added since AWS Provider v4.29+ to set VPC id

  dynamic "ingress" {
    for_each = var.allow_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, { Name = "${var.common_tags["Environment"]} Server SecurityGroup" })

}
