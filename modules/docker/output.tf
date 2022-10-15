output "docker_private_ip" {
  value = aws_instance.Docker_Server.private_ip
}
output "docker-instance" {
  value = aws_instance.Docker_Server.id
}