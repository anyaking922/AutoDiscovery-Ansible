#create keypairs for ec2 instance
resource "aws_key_pair" "PACJAD_key" {
  key_name   = var.key_name
  public_key = var.public-key
}