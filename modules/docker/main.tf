#create Docker Server
resource "aws_instance" "Docker_Server" {
  ami                         = var.ami_name
  instance_type               = var.instance_type
  subnet_id                   = var.subnet-id
  vpc_security_group_ids      = var.Docker_SG
  key_name                    = var.key-id
  

  user_data = <<-EOF
#!/bin/bash
    exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
    sudo yum update -y
    sudo yum upgrade -y
    sudo yum install -y yum-utils
    sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
    sudo yum install docker-ce docker-ce-cli containerd.io -y
    sudo systemctl start docker
    sudo usermod -aG docker ec2-user
    echo "license_key: eu01xxa5bd785023c6cea76f602efd91e1a7NRAL" | sudo tee -a /etc/newrelic-infra.yml
    sudo curl -o /etc/yum.repos.d/newrelic-infra.repo https://download.newrelic.com/infrastructure_agent/linux/yum/amazonlinux/2/x86_64/newrelic-infra.repo
    sudo yum -q makecache -y --disablerepo='*' --enablerepo='newrelic-infra'
    sudo yum install newrelic-infra -y
EOF

  tags = {
    Name = "Docker_Server"
  }
}


