output "key-pair" {
  value = aws_key_pair.PACJAD_key.id
}
output "key-name" {
  value = aws_key_pair.PACJAD_key.key_name
}
output "public-key" {
  value = aws_key_pair.PACJAD_key.public_key
}