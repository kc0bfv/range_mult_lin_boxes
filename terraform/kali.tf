variable "kali_environ_portion_tag" {
  default = "kali"
}

variable "kali_private_subnet_number" {
  default = 0
}

resource "aws_subnet" "kali_private_subnet" {
  vpc_id               = aws_vpc.vpc.id
  cidr_block           = local.kali_ipv4_cidr_block
  ipv6_cidr_block      = local.kali_ipv6_cidr_block
  availability_zone_id = aws_subnet.admin_public_subnet.availability_zone_id

  map_public_ip_on_launch = false

  tags = {
    Environment = var.environ_tag
    EnvPortion  = var.kali_environ_portion_tag
  }
}

resource "aws_route_table" "kali_private_route_table" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block           = "0.0.0.0/0"
    network_interface_id = aws_network_interface.jump_host_private_int.id
    #instance_id = aws_instance.jump_host.id
  }
  route {
    ipv6_cidr_block      = "::/0"
    network_interface_id = aws_network_interface.jump_host_private_int.id
    #instance_id = aws_instance.jump_host.id
  }
  tags = {
    Environment = var.environ_tag
    EnvPortion  = var.kali_environ_portion_tag
  }
}

resource "aws_route_table_association" "kali_private_rt_assoc" {
  subnet_id      = aws_subnet.kali_private_subnet.id
  route_table_id = aws_route_table.kali_private_route_table.id
}

resource "aws_key_pair" "kali_key" {
  key_name   = "kali_key"
  public_key = file("kali_key.pub")

  tags = {
    Environment = var.environ_tag
    EnvPortion  = var.kali_environ_portion_tag
  }
}

resource "aws_instance" "kali_host" {
  count                  = var.kali_count
  ami                    = var.kali_ami
  instance_type          = var.medium_machine
  subnet_id              = aws_subnet.kali_private_subnet.id
  ipv6_address_count     = 1
  vpc_security_group_ids = [aws_security_group.allow_everything.id]
  key_name               = aws_key_pair.kali_key.key_name
  depends_on             = [aws_internet_gateway.igw]

  root_block_device {
    volume_size = 24
  }

  tags = {
    Environment = var.environ_tag
    EnvPortion  = var.kali_environ_portion_tag
    Name        = "kali_host"
  }
}


locals {
  #kali_host_public_address  = aws_instance.kali_host.public_ip
  #kali_host_private_address = aws_instance.kali_host.private_ip
}

output "kali_host_public_addresses" {
  value = aws_instance.kali_host[*].public_ip
}

output "kali_host_private_address" {
  value = aws_instance.kali_host[*].private_ip
}
