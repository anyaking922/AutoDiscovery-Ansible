# Create Jenkins and Docker_host Security Group
resource "aws_security_group" "PACD_SG1" {
  name        = var.sg1_name
  description = "Allow TLS inbound traffic"
  vpc_id      = var.vpc-id

  ingress {
    description = "SSH from PACD_VPC"
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = "tcp"
    cidr_blocks = var.my_system
  }

  ingress {
    description = "Allow custom_http from PACD_VPC"
    from_port   = var.Custom_http
    to_port     = var.Custom_http
    protocol    = "tcp"
    cidr_blocks = var.my_system
  }

  ingress {
    description = "Allow http from PACD_VPC"
    from_port   = var.http_port
    to_port     = var.http_port
    protocol    = "tcp"
    cidr_blocks = var.my_system
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.my_system
  }
  tags = {
    Name = var.sg1_name
  }
}

# Create Bastion_host and Ansible_node Security Group
resource "aws_security_group" "PACD_SG2" {
  name        = var.sg2_name
  description = "Allow TLS inbound traffic"
  vpc_id      = var.vpc-id

  ingress {
    description = "SSH from PACD_VPC"
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = "tcp"
    cidr_blocks = var.my_system
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.my_system
  }
  tags = {
    Name = var.sg2_name
  }
}

# Create  Security Group
resource "aws_security_group" "PACD_SG3" {
  name        = var.sg3_name
  description = "Allow TLS inbound traffic"
  vpc_id      = var.vpc-id

  ingress {
    description = "SSH from PACD_VPC"
    from_port   = var.mysql
    to_port     = var.mysql
    protocol    = "tcp"
    cidr_blocks = var.my_system
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.my_system
  }
  tags = {
    Name = var.sg3_name
  }
}
