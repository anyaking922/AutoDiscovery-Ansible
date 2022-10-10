
output "JenkinsIP" {
  value = aws_instance.PETAD1_Jenkins_Host.public_ip
}

output "DockerIP" {
  value = aws_instance.PETAD1_Docker_Host.public_ip
}


output "AnsibleIP" {
  value = aws_instance.PETAD1_Ansible_Host.public_ip
}

output "SonarIP" {
  value = aws_instance.Sonarqube_Server.public_ip
}







