variable "vpc_name" {
  default = ""
}
variable "vpc_cidr" {
    default     = "10.0.0.0/16"
    description = "PACD_VPC"
}
variable "PACD_PUB_SN1_cidr" {
    default     = "10.0.0.0/24"
    description = "PACD_PUB_SN1"
}
variable "PACD_PUB_SN2_cidr" {
    default     = "10.0.1.0/24"
    description = "PACD_PUB_SN2"
}
variable "PACD_PRV_SN1_cidr" {
    default     = "10.0.2.0/24"
    description = "PACD_PRV_SN1"
}
variable "PACD_PRV_SN2_cidr"{
    default     = "10.0.3.0/24"
    description = "PACD_PRV_SN2"
}
variable "prv_subn1" {
    default = "PACD_PRV_SN1"
}
variable "prv_subn2" {
    default = "PACD_PRV_SN2"
}
variable "pub_subn1" {
    default = "PACD_PUB_SN1"
}
variable "pub_subn2" {
    default = "PACD_PUB_SN2"
}
variable "igw_name" {
    default = "PACD_IGW"
}
variable "nat_gateway" {
    default = "PACD_NAT_GW"
}
variable "route_pub_table" {
    default = "PACD_RT_Pub_SN"
}
variable "route_prv_table" {
    default = "PACD_RT_Prv_SN"
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

# variable "ami" {
#   default = "ami-09ce2fc392a4c0fbc"
# }

# variable "instance_type" {
#   default = "t2.medium"
# }


# EC2 ansible server 
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

variable "Docker_SG" {
    default = ""
}


variable "subnet-id001" {
    default = ""
}