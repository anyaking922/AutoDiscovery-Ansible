#Create a Jenkins Server
resource "aws_instance" "PACD_jenkins" {
    ami = var.ami_name
    instance_type = var.instance_type
    subnet_id = var.subnet-id
    key_name = var.key-id
    vpc_security_group_ids  = var.vpc-sg1 #[aws_security_group.PACD_SG1.id]
    user_data = <<-EOF
    #!/bin/bash
    exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
    sudo yum update -y
    sudo yum install wget -y
    sudo yum install git -y
    sudo yum install maven -y
    sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
    sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
    sudo yum upgrade -y
    sudo yum install jenkins java-11-openjdk-devel -y
    sudo systemctl daemon-reload
    sudo systemctl start jenkins
    sudo systemctl enable jenkins
    sudo yum install -y yum-utils
    sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
    sudo yum install docker-ce docker-ce-cli containerd.io -y
    sudo systemctl start docker
    sudo systemctl enable docker
    sudo usermod -aG docker jenkins
    sudo usermod -aG docker ec2-user
    echo "license_key: eu01xxa5bd785023c6cea76f602efd91e1a7NRAL" | sudo tee -a /etc/newrelic-infra.yml
    sudo curl -o /etc/yum.repos.d/newrelic-infra.repo https://download.newrelic.com/infrastructure_agent/linux/yum/amazonlinux/2/x86_64/newrelic-infra.repo
    sudo yum -q makecache -y --disablerepo='*' --enablerepo='newrelic-infra'
    sudo yum install newrelic-infra -y
    EOF 
    tags = {
      Name = var.name-tag
    }
}