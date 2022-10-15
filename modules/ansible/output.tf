output "ansible_private_ip" {
  value = aws_instance.PACD_ansible_node.private_ip
}