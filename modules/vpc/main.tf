#create VPC
resource "aws_vpc" "PACJAD_VPC" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = var.vpc_name
  }
}
#create private subnet 1
resource "aws_subnet" "PACJAD_PRV_SN1" {
  vpc_id            = aws_vpc.PACJAD_VPC.id
  cidr_block        = var.PACJAD_PRV_SN1_cidr
  availability_zone = var.az1a
  tags = {
    Name = var.prv_subn1
  }
}
# create private subnet 2
resource "aws_subnet" "PACJAD_PRV_SN2" {
  vpc_id            = aws_vpc.PACJAD_VPC.id
  cidr_block        = var.PACJAD_PRV_SN2_cidr
  availability_zone = var.az1b
  tags = {
    Name = var.prv_subn2
  }
}
# create pub subnet 1
resource "aws_subnet" "PACJAD_PUB_SN1" {
  vpc_id            = aws_vpc.PACJAD_VPC.id
  cidr_block        = var.PACJAD_PUB_SN1_cidr
  availability_zone = var.az1a
  tags = {
    Name = var.pub_subn1
  }
}
# create pub subnet 2
resource "aws_subnet" "PACJAD_PUB_SN2" {
  vpc_id            = aws_vpc.PACJAD_VPC.id
  cidr_block        = var.PACJAD_PUB_SN2_cidr
  availability_zone = var.az1b
  tags = {
    Name = var.pub_subn2
  }
}
# create an IGW
resource "aws_internet_gateway" "PACJAD_IGW" {
  vpc_id = aws_vpc.PACJAD_VPC.id

  tags = {
    Name = var.igw_name
  }
}
# creating the EIP
resource "aws_eip" "PACJAD_EIP" {
  depends_on = [aws_internet_gateway.PACJAD_IGW]
}
# creating the NAT gateway
resource "aws_nat_gateway" "PACJAD_NAT_GW" {
  allocation_id = aws_eip.PACJAD_EIP.id
  subnet_id     = aws_subnet.PACJAD_PUB_SN1.id

  tags = {
    Name = var.nat_gateway
  }
}
#create a public route table
resource "aws_route_table" "PACJAD_RT_Pub_SN" {
  vpc_id = aws_vpc.PACJAD_VPC.id

  route {
    cidr_block = var.my_system2
    gateway_id = aws_internet_gateway.PACJAD_IGW.id
  }
  tags = {
    Name = var.route_pub_table
  }
}
#create a private route table
resource "aws_route_table" "PACJAD_RT_Prv_SN" {
  vpc_id = aws_vpc.PACJAD_VPC.id

  route {
    cidr_block = var.my_system2
    gateway_id = aws_nat_gateway.PACJAD_NAT_GW.id
  }
  tags = {
    Name = var.route_prv_table
  }
}
#assiociation of route table to public SN 1 
resource "aws_route_table_association" "PACJAD_Public_RT_ass_01" {
  subnet_id      = aws_subnet.PACJAD_PUB_SN1.id
  route_table_id = aws_route_table.PACJAD_RT_Pub_SN.id
}

#assiociation of route table to Public SN 2
resource "aws_route_table_association" "PACJAD_Public_RT_ass_02" {
  subnet_id      = aws_subnet.PACJAD_PUB_SN2.id
  route_table_id = aws_route_table.PACJAD_RT_Pub_SN.id
}

#assiociation of route table to private SN 1 
resource "aws_route_table_association" "PACJAD_Private_RT_ass_01" {
  subnet_id      = aws_subnet.PACJAD_PRV_SN1.id
  route_table_id = aws_route_table.PACJAD_RT_Prv_SN.id
}

#assiociation of route table to private SN 2 
resource "aws_route_table_association" "PACJAD_Private_RT_ass_02" {
  subnet_id      = aws_subnet.PACJAD_PRV_SN2.id
  route_table_id = aws_route_table.PACJAD_RT_Prv_SN.id
}