output "jenkins_private_ip" {
  value = aws_instance.PACJAD_jenkins.private_ip
}

output "jenkins-instance" {
  value = aws_instance.PACJAD_jenkins.id
}