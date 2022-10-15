output "ansible_private_ip" {
  value = aws_instance.PACJAD_ansible_node.private_ip
}