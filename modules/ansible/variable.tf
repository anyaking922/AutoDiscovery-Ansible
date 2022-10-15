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