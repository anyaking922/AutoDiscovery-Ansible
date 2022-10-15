resource "aws_ami_from_instance" "docker_host_AMI" {
  name               = var.ami-name
  source_instance_id = var.target-instance
  #depends_on = [aws_instance.docker_host]
} 
###Creating autoscaling
resource "aws_launch_configuration" "docker_host_ASG_LC" {
  name = var.launch-configname
  instance_type = var.instance-type
  image_id = var.ami-from-instance
  security_groups = var.sg1
  key_name = var.key-id
  user_data = <<-EOF
#!/bin/bash
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum update -y
sudo yum install docker-ce docker-ce-cli containerd.io -y
sudo systemctl start docker
echo "license_key: eu01xxa5bd785023c6cea76f602efd91e1a7NRAL" | sudo tee -a /etc/newrelic-infra.yml
sudo curl -o /etc/yum.repos.d/newrelic-infra.repo https://download.newrelic.com/infrastructure_agent/linux/yum/el/7/x86_64/newrelic-infra.repo
sudo yum -q makecache -y --disablerepo='*' --enablerepo='newrelic-infra'
sudo yum install newrelic-infra -y
sudo usermod -aG docker ec2-user
sudo yum install python3 python3-pip -y
sudo alternatives --set python /usr/bin/python3
sudo pip3 install docker-py 
docker run -p 8080:8080 -d --name my-app cloudhight/sample:latest
sudo hostname Docker-host-ASG
EOF 
}
resource "aws_autoscaling_group"  "Dockerhost_ASG" {
  name = var.asg-group-name 
  max_size = 4
  min_size = 2
  health_check_grace_period = 300
  health_check_type = "EC2"
  force_delete = true
  launch_configuration = aws_launch_configuration.docker_host_ASG_LC.name
  vpc_zone_identifier = var.vpc-zone-identifier
  target_group_arns = var.docker-target-group-arn
}
resource "aws_autoscaling_policy" "Docker_host_ASG_POLICY" {
  name = var.asg-docker-policy
  scaling_adjustment = 1
  adjustment_type = "ChangeInCapacity"
  cooldown = 60
  autoscaling_group_name = aws_autoscaling_group.Dockerhost_ASG.name
}