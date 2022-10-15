# EC2 related variables 
variable "ami_name" {
    default = "" # In Eu-west-1 region
}

variable "instance_type" {
    default = ""   # For heavy application
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

variable "vpc-sg1" {
    default = ""
}