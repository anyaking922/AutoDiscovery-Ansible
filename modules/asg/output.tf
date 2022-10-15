output "ami-from-instance" {
  value = aws_ami_from_instance.docker_host_AMI.id
}