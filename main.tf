# VPC
resource "aws_vpc" "PACD_VPC" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "PACD_VPC"
  }
}

# PUBLIC SUBNET 1
resource "aws_subnet" "PACD_PubSN1" {
  vpc_id            = aws_vpc.PACD_VPC.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-west-1a"

  tags = {
    Name = "PACD_PubSN1"
  }
}

# PUBLIC SUBNET 2
resource "aws_subnet" "PACD_PubSN2" {
  vpc_id            = aws_vpc.PACD_VPC.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "eu-west-1b"

  tags = {
    Name = "PACD_PubSN2"
  }
}

# PRIVATE SUBNET 1
resource "aws_subnet" "PACD_PvtSN1" {
  vpc_id            = aws_vpc.PACD_VPC.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "eu-west-1a"

  tags = {
    Name = "PACD_PvtSN1"
  }
}

# PRIVATE SUBNET 2
resource "aws_subnet" "PACD_PvtSN2" {
  vpc_id            = aws_vpc.PACD_VPC.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "eu-west-1b"

  tags = {
    Name = "PACD_PvtSN2"
  }
}


# INTERNET GATEWAY (IGW)
resource "aws_internet_gateway" "PACD_IGW" {
  vpc_id = aws_vpc.PACD_VPC.id
  tags = {
    Name = "PACD_IGW"
  }
}

# NAT GATEWAY
resource "aws_nat_gateway" "PACD_NAT-GW" {
  allocation_id = aws_eip.PACD_EIP.id
  subnet_id     = aws_subnet.PACD_PubSN1.id

  tags = {
    Name = "PACD_NAT-GW"
  }

  depends_on = [aws_internet_gateway.PACD_IGW]
}

# ELASTIC IP
resource "aws_eip" "PACD_EIP" {
  vpc = true

  tags = {
    Name = "PACD_EIP"
  }
}

# ROUTE TABLE FOR PUBLIC SUBNET
resource "aws_route_table" "PACD_RT_Pub" {
  vpc_id = aws_vpc.PACD_VPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.PACD_IGW.id
  }

  tags = {
    Name = "PACD_RT_Pub"
  }
}

# ROUTE TABLE ASSOCIATIONS FOR PUBLIC SUBNET 1
resource "aws_route_table_association" "PACD_RT_Pub_Ass1" {
  subnet_id      = aws_subnet.PACD_PubSN1.id
  route_table_id = aws_route_table.PACD_RT_Pub.id
}

# ROUTE TABLE ASSOCIATIONS FOR PUBLIC SUBNET 2
resource "aws_route_table_association" "PACD_RT_Pub_Ass2" {
  subnet_id      = aws_subnet.PACD_PubSN2.id
  route_table_id = aws_route_table.PACD_RT_Pub.id
}


# ROUTE TABLE FOR PRIVATE SUBNET
resource "aws_route_table" "PACD_RT_Pvt" {
  vpc_id = aws_vpc.PACD_VPC.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.PACD_NAT-GW.id
  }

  tags = {
    Name = "PACD_RT_Pvt"
  }
}

# ROUTE TABLE ASSOCIATIONS FOR PRIVATE SUBNET 1
resource "aws_route_table_association" "PACD_RT_Pvt_Ass1" {
  subnet_id      = aws_subnet.PACD_PvtSN1.id
  route_table_id = aws_route_table.PACD_RT_Pvt.id
}

# ROUTE TABLE ASSOCIATIONS FOR PRIVATE SUBNET 2
resource "aws_route_table_association" "PACD_RT_Pvt2_Ass2" {
  subnet_id      = aws_subnet.PACD_PvtSN2.id
  route_table_id = aws_route_table.PACD_RT_Pvt.id
}

# JENKINS SECURITY GROUP
resource "aws_security_group" "Jenkins_SG" {
  name        = "Jenkins_SG"
  description = "Allow 8080, ssh traffic"
  vpc_id      = aws_vpc.PACD_VPC.id

  ingress {
    description = "TLS from VPC"
    from_port   = var.port_http
    to_port     = var.port_http
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "TLS from VPC"
    from_port   = var.port_proxy
    to_port     = var.port_proxy
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "TLS from VPC"
    from_port   = var.port_ssh
    to_port     = var.port_ssh
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = var.egress
    to_port     = var.egress
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Jenkins_SG"
  }
}

# DOCKER SECURITY GROUP
resource "aws_security_group" "Docker_SG" {
  name        = "Docker_SG"
  description = "Allow 8080, ssh traffic"
  vpc_id      = aws_vpc.PACD_VPC.id

  ingress {
    description = "TLS from VPC"
    from_port   = var.port_http
    to_port     = var.port_http
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "TLS from VPC"
    from_port   = var.port_proxy
    to_port     = var.port_proxy
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "TLS from VPC"
    from_port   = var.port_ssh
    to_port     = var.port_ssh
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = var.egress
    to_port     = var.egress
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Docker_SG"
  }
}

# ANSIBLE SECURITY GROUP
resource "aws_security_group" "Ansible_SG" {
  name        = "Ansible_SG"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.PACD_VPC.id


  ingress {
    description = "TLS from VPC"
    from_port   = var.port_ssh
    to_port     = var.port_ssh
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = var.egress
    to_port     = var.egress
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Ansible_SG"
  }
}

# SONARQUBE SECURITY GROUP
resource "aws_security_group" "Sonar_SG" {
  name        = "sonar_sg"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.PACD_VPC.id
  ingress {
    description = "TLS from VPC"
    from_port   = var.sonar_port
    to_port     = var.sonar_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = var.port_ssh
    to_port     = var.port_ssh
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = var.egress
    to_port     = var.egress
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Sonar_SG"
  }
}

# RDS SECURITY GROUP
resource "aws_security_group" "Mysql_SG" {
  name        = "Mysql_SG"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.PACD_VPC.id

  ingress {
    description = "TLS from VPC"
    from_port   = var.port_mysql_database
    to_port     = var.port_mysql_database
    protocol    = "tcp"
    cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24"]
  }

  ingress {
    description = "TLS from VPC"
    from_port   = var.port_ssh
    to_port     = var.port_ssh
    protocol    = "tcp"
    cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24"]
  }

  egress {
    from_port   = var.egress
    to_port     = var.egress
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = {
    Name = "Mysql_SG"
  }
}

# create KeyPair
resource "aws_key_pair" "server_key" {
  key_name   = "server_key"
  public_key = file(var.server_key)
}

#create database subnet group
resource "aws_db_subnet_group" "pacd_sn_group" {
  name       = "pacd_sn_group"
  subnet_ids = [aws_subnet.PACD_PvtSN1.id, aws_subnet.PACD_PvtSN2.id]

  tags = {
    Name = "pacpd_sn_group"
  }
}

#Create MySQL RDS Instance
resource "aws_db_instance" "pacd_rds" {
  identifier             = "pacd-database"
  storage_type           = "gp2"
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t2.micro"
  port                   = "3306"
  db_name                = "pacdb"
  username               = var.database_username
  password               = var.db_password
  multi_az               = true
  parameter_group_name   = "default.mysql8.0"
  deletion_protection    = false
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.pacd_sn_group.name
  vpc_security_group_ids = [aws_security_group.Mysql_SG.id]
}


# JENKINS SERVER
resource "aws_instance" "PACD_Jenkins_Host" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.PACD_PubSN1.id
  vpc_security_group_ids      = [aws_security_group.Jenkins_SG.id]
  key_name                    = aws_key_pair.server_key.id
  associate_public_ip_address = true
  user_data                   = <<-EOF
#!/bin/bash
sudo yum update –y
sudo yum upgrade -y
sudo yum install wget -y
sudo yum install git -y
sudo yum install maven -y
sudo wget https://get.jenkins.io/redhat/jenkins-2.346-1.1.noarch.rpm
sudo rpm -ivh jenkins-2.346-1.1.noarch.rpm
sudo yum install java-11-openjdk -y
sudo yum install jenkins 
sudo systemctl daemon-reload
sudo systemctl start jenkins
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install docker-ce -y
sudo systemctl start docker
echo "license_key: eu01xx806409169e75514e699c9629ee0b32NRAL" | sudo tee -a /etc/newrelic-infra.yml
sudo curl -o /etc/yum.repos.d/newrelic-infra.repo https://download.newrelic.com/infrastructure_agent/linux/yum/el/7/x86_64/newrelic-infra.repo
sudo yum -q makecache -y --disablerepo='*' --enablerepo='newrelic-infra'
sudo yum install newrelic-infra -y
sudo usermod -aG docker jenkins
sudo usermod -aG docker ec2-user
sudo service sshd restart
sudo hostnamectl set-hostname Jenkins
EOF
  tags = {
    Name = "PACD_Jenkins_Host"
  }
}





# DOCKER SERVER
resource "aws_instance" "PACD_Docker_Host" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.PACD_PubSN1.id
  vpc_security_group_ids      = [aws_security_group.Docker_SG.id]
  key_name                    = aws_key_pair.server_key.id
  associate_public_ip_address = true

  user_data = <<-EOF
#!/bin/bash
sudo yum update -y
sudo yum upgrade -y
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install docker-ce -y
sudo systemctl start docker
sudo systemctl enable docker
echo "license_key: eu01xx806409169e75514e699c9629ee0b32NRAL" | sudo tee -a /etc/newrelic-infra.yml
sudo curl -o /etc/yum.repos.d/newrelic-infra.repo https://download.newrelic.com/infrastructure_agent/linux/yum/el/7/x86_64/newrelic-infra.repo
sudo yum -q makecache -y --disablerepo='*' --enablerepo='newrelic-infra'
sudo yum install newrelic-infra -y
sudo su
echo "PubkeyAcceptedKeyTypes=+ssh-rsa" >> /etc/ssh/sshd_config.d/10-insecure-rsa-keysig.conf
sudo service sshd reload
chmod -R 700 .ssh/
sudo chown -R ec2-user:ec2-user .ssh/
sudo chmod 600 .ssh/authorized_keys
echo "${file(var.server_key)}" >> /home/ec2-user/.ssh/authorized_keys 
sudo hostnamectl set-hostname Docker
EOF
  tags = {
    Name = "PACD_Docker_Host"
  }
}
data "aws_instance" "PACD_Docker_Host" {
  filter {
    name   = "tag:Name"
    values = ["PACD_Docker_Host"]
  }
  depends_on = [
    aws_instance.PACD_Docker_Host
  ]
}






#Create Ansible Host
resource "aws_instance" "PACD_Ansible_Host" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.PACD_PubSN1.id
  vpc_security_group_ids      = [aws_security_group.Ansible_SG.id]
  key_name                    = aws_key_pair.server_key.id
  associate_public_ip_address = true
  user_data                   = <<-EOF
  #!/bin/bash
  sudo apt update -y

  echo "*********Install Ansible********"
  sudo apt install software-properties-common
  sudo add-apt-repository --yes --update ppa:ansible/ansible
  sudo apt update -y
  sudo apt install ansible -y

  echo "****************Copy the private key into the Server **************"
  echo "****************Ansible would use this when connecting to the Docker Server **************"
  echo "${file(var.pacpet1_prvkey_path)}" >> ${var.ans_prvkey_path}

  echo "*********This runs as the root and disables StrictHostChecking********"
  sudo bash -c 'echo "StrictHostKeyChecking No" >> /etc/ssh/ssh_config'

  echo "****Add the Docker Servers IP to the host file and also the localhost for ansible*******"
  sudo bash -c 'echo "localhost ansible_connection=local
  [Docker_Servers]
  ${aws_instance.pacpet1_docker.public_ip} ansible_ssh_private_key_file=${var.ans_prvkey_path}" >> /etc/ansible/hosts'

  echo "*********Install Docker engine ********"
  sudo apt-get install ca-certificates curl gnupg lsb-release -y
  sudo mkdir -p /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt update -y
  sudo apt install docker-ce docker-ce-cli -y

  echo "*******Create Docker File********"
  cd /home/ubuntu/
  mkdir Docker
  echo "*******We change the owner of this directory to ubuntu because ansible********"
  echo "*******would need to drop a file in this directory and it cant do that if its owned by root********"
  sudo chown -R ubuntu:ubuntu Docker
  touch Docker/Dockerfile

  #Insert Content to Docker File
  echo "${file(var.docker_file_path)}" > Docker/Dockerfile

  #Create Ansible Playbook that creates docker image
  mkdir Ansible && touch Ansible/playbook-dockerimage.yaml
  echo "${file(var.docker_image_path)}" > Ansible/playbook-dockerimage.yaml
  
  #Create Ansible Playbook that creates docker container
  touch Ansible/playbook-container.yaml
  echo "${file(var.docker_container_path)}" > Ansible/playbook-container.yaml

  #Create Ansible Playbook that installs new relic infrastructure agent to monitor containers
  touch Ansible/playbook-newrelic.yaml
  echo "${file(var.newrelic_infra_path)}" > Ansible/playbook-newrelic.yaml

  #Install New relic
 curl -Ls https://download.newrelic.com/install/newrelic-cli/scripts/install.sh | bash && sudo NEW_RELIC_API_KEY=NRAK-IWFEY0G9C3Z9US5E18Y3VH0IOJQ NEW_RELIC_ACCOUNT_ID=3643903 NEW_RELIC_REGION=EU /usr/local/bin/newrelic install -y
 
  echo "****************Change Hostname(IP) to something readable**************"
  sudo hostnamectl set-hostname Ansible
  sudo reboot
  EOF
}


# SonarQube Server
resource "aws_instance" "Sonarqube_Server" {
  ami                         = var.sonar_ami
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.server_key.id
  subnet_id                   = aws_subnet.PACD_PubSN1.id
  vpc_security_group_ids      = [aws_security_group.Sonar_SG.id]
  associate_public_ip_address = true
  user_data                   = <<-EOF

  #!/bin/bash
  sudo apt update -y
  echo "***Firstly Modify OS Level values***"
  sudo bash -c 'echo "
  vm.max_map_count=262144
  fs.file-max=65536
  ulimit -n 65536
  ulimit -u 4096" >> /etc/sysctl.conf'
  sudo bash -c 'echo "
  sonarqube   -   nofile   65536
  sonarqube   -   nproc    4096" >> /etc/security/limits.conf'
  echo "***********Install Java JDK***********"
  sudo apt install openjdk-11-jdk -y
  echo "***********Install PostgreSQL***********"
  echo "***********The version of postgres currenlty is 14.5 which is not supported so we have to download v12***********"
  sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
  wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
  sudo apt-get update -y
  sudo apt-get -y install postgresql-12 postgresql-contrib-12
  echo "*****Enable and start, so it starts when system boots up*******"
  sudo systemctl enable postgresql
  sudo systemctl start postgresql

  #Change default password of postgres user
  sudo chpasswd <<<"postgres:Admin123@"

  #Create user sonar without switching technically
  sudo su -c 'createuser sonar' postgres

  #Create SonarQube Database and change sonar password
  sudo su -c "psql -c \"ALTER USER sonar WITH ENCRYPTED PASSWORD 'Admin123'\"" postgres
  sudo su -c "psql -c \"CREATE DATABASE sonarqube OWNER sonar\"" postgres
  sudo su -c "psql -c \"GRANT ALL PRIVILEGES ON DATABASE sonarqube to sonar\"" postgres

  #Restart postgresql for changes to take effect
  sudo systemctl restart postgresql

  #Install SonarQube
  sudo mkdir /sonarqube/
  cd /sonarqube/
  sudo curl -O https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.6.1.59531.zip
  sudo apt install unzip -y
  sudo unzip sonarqube-9.6.1.59531.zip -d /opt/
  sudo mv /opt/sonarqube-9.6.1.59531/ /opt/sonarqube

  #Add group user sonarqube
  sudo groupadd sonar

  #Then, create a user and add the user into the group with directory permission to the /opt/ directory
  sudo useradd -c "SonarQube - User" -d /opt/sonarqube/ -g sonar sonar

  #Change ownership of the directory to sonar
  sudo chown sonar:sonar /opt/sonarqube/ -R
  
  sudo bash -c 'echo "
  sonar.jdbc.username=sonar
  sonar.jdbc.password=Admin123
  sonar.jdbc.url=jdbc:postgresql://localhost/sonarqube
  sonar.search.javaOpts=-Xmx512m -Xms512m -XX:+HeapDumpOnOutOfMemoryError" >> /opt/sonarqube/conf/sonar.properties'
  sudo touch /etc/systemd/system/sonarqube.service
  #Configuring so that we can run commands to start, stop and reload sonarqube service
  sudo bash -c 'echo "
  [Unit]
  Description=SonarQube service
  After=syslog.target network.target
  
  [Service]
  Type=forking
  
  ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
  ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop
  ExecReload=/opt/sonarqube/bin/linux-x86-64/sonar.sh restart
  
  User=sonar
  Group=sonar
  Restart=always
  
  LimitNOFILE=65536
  LimitNPROC=4096


  [Install]
  WantedBy=multi-user.target" >> /etc/systemd/system/sonarqube.service'

  #Enable and Start the Service
  sudo systemctl daemon-reload
  sudo systemctl enable sonarqube.service
  sudo systemctl start sonarqube.service

  #Install net-tools incase we want to debug later
  sudo apt install net-tools -y

  #Install nginx
  sudo apt-get install nginx -y

  #Configure nginx so we can access server from outside
  sudo touch /etc/nginx/sites-enabled/sonarqube.conf
  sudo bash -c 'echo "
  server {
    listen 80;

    access_log  /var/log/nginx/sonar.access.log;
    error_log   /var/log/nginx/sonar.error.log;

    proxy_buffers 16 64k;
    proxy_buffer_size 128k;

    location / {
        proxy_pass  http://127.0.0.1:9000;
        proxy_next_upstream error timeout invalid_header http_500 http_502 http_503 http_504;
        proxy_redirect off;

        proxy_set_header    Host            \$host;
        proxy_set_header    X-Real-IP       \$remote_addr;
        proxy_set_header    X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header    X-Forwarded-Proto http;
    }
  }" >> /etc/nginx/sites-enabled/sonarqube.conf'

  #Remove the default configuration file
  sudo rm /etc/nginx/sites-enabled/default

  #Enable and restart nginix service
  sudo systemctl enable nginx.service
  sudo systemctl stop nginx.service
  sudo systemctl start nginx.service
  
 #Install New relic
  curl -Ls https://download.newrelic.com/install/newrelic-cli/scripts/install.sh | bash && sudo NEW_RELIC_API_KEY=NRAK-IWFEY0G9C3Z9US5E18Y3VH0IOJQ NEW_RELIC_ACCOUNT_ID=3643903 NEW_RELIC_REGION=EU /usr/local/bin/newrelic install -y
  echo "****************Change Hostname(IP) to something readable**************"
  sudo hostnamectl set-hostname Sonarqube
  sudo reboot
  EOF
}



#Create AMI from EC2 Instance
resource "aws_ami_from_instance" "PACD_ami" {
  name               = "PACD_ami"
  source_instance_id = aws_instance.PACD_Docker_Host.id
}




####High Availability, ASG, LB#######


#Add High Availability

#Create Target Group
resource "aws_lb_target_group" "PACD_tg" {
  name     = "PACD-TG"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.PACD_VPC.id
  health_check {
    path                = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 15
    matcher             = "200"
  }
}


#Create Application Load Balancer
resource "aws_lb" "PACD_lb" {
  name               = "PACD-Lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.Jenkins_SG.id}"]
  subnets            = ["${aws_subnet.PACD_PubSN1.id}", "${aws_subnet.PACD_PubSN2.id}"]

  enable_deletion_protection = false

  tags = {
    Name = "PACD-Lb"
  }
}

# Create Load Balancer Listener
resource "aws_lb_listener" "pacd_lb" {
  load_balancer_arn = aws_lb.PACD_lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_lb_target_group.PACD_tg.arn
    type             = "forward"
  }
}

#Create Launch Configuration
resource "aws_launch_configuration" "PACD_lc" {
  name_prefix                 = "PACD_lc"
  image_id                    = aws_ami_from_instance.PACD_ami.id
  instance_type               = "t2.medium"
  associate_public_ip_address = true
  security_groups             = ["${aws_security_group.Jenkins_SG.id}"]
  key_name                    = "server_key"
  lifecycle {
    create_before_destroy = true
  }
}


#Create Auto Scaling group
resource "aws_autoscaling_group" "PACD_asg" {
  name                 = "PACD-ASG"
  launch_configuration = aws_launch_configuration.PACD_lc.name
  #Defines the vpc, az and subnets to launch in
  vpc_zone_identifier       = ["${aws_subnet.PACD_PubSN1.id}", "${aws_subnet.PACD_PubSN2.id}"]
  target_group_arns         = ["${aws_lb_target_group.PACD_tg.arn}"]
  health_check_type         = "EC2"
  health_check_grace_period = 30
  desired_capacity          = 2
  max_size                  = 4
  min_size                  = 2
  force_delete              = true
  lifecycle {
    create_before_destroy = true
  }
}




resource "aws_autoscaling_policy" "PACD_asg_policy" {
  name                   = "PACD_asg_policy"
  policy_type            = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.PACD_asg.name
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 60.0
  }
}

#Create Hosted Zone
resource "aws_route53_zone" "PACD_hosted_zone" {
  name = "kingsleyA.com"
}

resource "aws_route53_record" "PACD_record" {
  zone_id = aws_route53_zone.PACD_hosted_zone.zone_id
  name    = ""
  type    = "A"
  alias {
    name                   = aws_lb.PACD_lb.dns_name
    zone_id                = aws_lb.PACD_lb.zone_id
    evaluate_target_health = true
  }
}