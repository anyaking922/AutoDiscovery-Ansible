# Jenkins ELB related variables 
variable "elb_name" {
  default = ""
}
variable "elb_tag" {
  default = ""
}
variable "subnet-id" {
  default = ""
}
variable "jenkins-sg1" {
  default = ""
}
variable "jenkins-instance" {
  default = ""
}

#Docker Load Balancer Variables
variable "tg_name" {
  default = ""
}
variable "vpc-id" {
  default = ""
}
variable "docker_instance" {
  default = ""
}
variable "alb_name" {
  default = ""
}
variable "docker_sg1" {
  default = ""
}
variable "subnet_id_docker" {
  default = ""
}
variable "docker_tag" {
  default = ""
}

