output "key-pair" {
  value = aws_key_pair.PACD_key.id
}
output "key-name" {
  value = aws_key_pair.PACD_key.key_name
}
output "public-key" {
  value = aws_key_pair.PACD_key.public_key
}