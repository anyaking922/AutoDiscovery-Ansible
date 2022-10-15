resource "aws_instance" "PACJAD_Bastian_Host" {
  ami                         = var.ami_name
  instance_type               = var.instance_type
  subnet_id                   = var.sub1_id
  key_name                    = var.key-id
  vpc_security_group_ids      = var.Bastian_SG
  associate_public_ip_address = true


tags = {
    Name = "PACJAD_Bastian_Host"
  }

  provisioner "file" {
      source = "/Users/nwabuko/Desktop/Pet-Adoption-Containerisation-Project-With-Ansible-Auto-discovery-using-Jenkins-pipeline-Team-1/modules/secrets/Pap_key"
      destination = "/home/ec2-user/Keypair"
  }
  connection {
      type = "ssh"
      host = self.public_ip
      user = "ec2-user"
      private_key = file("/Users/nwabuko/Desktop/Pet-Adoption-Containerisation-Project-With-Ansible-Auto-discovery-using-Jenkins-pipeline-Team-1/modules/secrets/Pap_key")
  }
}