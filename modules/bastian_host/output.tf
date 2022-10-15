output "bastian_host_ip" {
  value = aws_instance.PACD_Bastian_Host.public_ip
}