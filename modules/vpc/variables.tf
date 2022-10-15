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
    default = "eu-west-2a"
}
variable "az1b"{
    default = "eu-west-2b"
}
variable "my_system2"{
    default = "0.0.0.0/0"
}

