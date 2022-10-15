# SG related variables 
variable "sg1_name" {
    default = ""
}
variable "sg2_name" {
    default = ""
}
variable "sg3_name" {
    default = ""
}
variable "Custom_http" {
    default = 8080
}
variable "ssh_port" {
    default = 22
}
variable "http_port" {
    default = 80
}

variable "mysql" {
    default = 3306
}
variable "vpc_id" {
    default = "aws_vpc.PACJAD_VPC.id"
}

variable "my_system" {
    default = ["0.0.0.0/0"]
}

variable "my_system2" {
    default = "0.0.0.0/0"
}

variable "vpc-id" {
    default = ""
}