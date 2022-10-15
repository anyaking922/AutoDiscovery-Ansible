variable "vpc_name" {
  default = ""
}
variable "vpc_cidr" {
    default     = "10.0.0.0/16"
    description = "PACJAD_VPC"
}
variable "PACJAD_PUB_SN1_cidr" {
    default     = "10.0.0.0/24"
    description = "PACJAD_PUB_SN1"
}
variable "PACJAD_PUB_SN2_cidr" {
    default     = "10.0.1.0/24"
    description = "PACJAD_PUB_SN2"
}
variable "PACJAD_PRV_SN1_cidr" {
    default     = "10.0.2.0/24"
    description = "PACJAD_PRV_SN1"
}
variable "PACJAD_PRV_SN2_cidr"{
    default     = "10.0.3.0/24"
    description = "PACJAD_PRV_SN2"
}
variable "prv_subn1" {
    default = "PACJAD_PRV_SN1"
}
variable "prv_subn2" {
    default = "PACJAD_PRV_SN2"
}
variable "pub_subn1" {
    default = "PACJAD_PUB_SN1"
}
variable "pub_subn2" {
    default = "PACJAD_PUB_SN2"
}
variable "igw_name" {
    default = "PACJAD_IGW"
}
variable "nat_gateway" {
    default = "PACJAD_NAT_GW"
}
variable "route_pub_table" {
    default = "PACJAD_RT_Pub_SN"
}
variable "route_prv_table" {
    default = "PACJAD_RT_Prv_SN"
}
variable "az1a"{
    default = "eu-west-1a"
}
variable "az1b"{
    default = "eu-west-1b"
}
variable "my_system2"{
    default = "0.0.0.0/0"
}

variable "ami" {
  default = ""
}
# ami-0ad8ecac8af5fc52b

# variable "instance_type" {
#   default = "t2.medium"
# }

variable "PATH_TO_PUBLIC_KEY" {
  default = "~/mykeypair/newkey.pub"
}

variable "PACPAAD_key" {
  default = "~/mykeypair/newkey"
}
#PATH_TO_PRIVATE_KEY

variable "sub1_id" {
    default = "aws_subnet.PACJAD_PUB_SN1.id"
}


variable "keyname" {
    default = "aws_key_pair.PACPAAD_key.key_name"
}

variable "Bastian_SG" {
    default = ""
}

#[aws_security_group.PE2EP_Team1_Ansible_SG.id]

variable "ami_name" {
    default = "" # In Eu-west-1 region
}

variable "instance_type" {
    default = ""   # For simple application
}

variable "key-id" {
    default = ""  
}

variable "name-tag" {
    default = ""
}

variable "subnet-id" {
    default = ""
}

variable "vpc-sg2" {
    default = ""
}