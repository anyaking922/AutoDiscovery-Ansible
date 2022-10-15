module "dev-vpc" {
  source   = "../../modules/vpc"
  vpc_name = "dev-PACD"
}
module "dev-securityGroups" {
  source   = "../../modules/securityGroups"
  vpc-id   = module.dev-vpc.vpc-id
  sg1_name = "dev-PACD_SG1-docker-jenkins"
  sg2_name = "dev-PACD-SG2-bastion-ansible"
  sg3_name = "dev-PACD-SG3-rds"
}
module "dev-keypair" {
  source     = "../../modules/keypair"
  key_name   = "PACD-key"
  public-key = file("../../modules/secrets/Pap_key.pub")
}
module "dev-jenkins" {
  source        = "../../modules/jenkins"
  ami_name      = "ami-0ad8ecac8af5fc52b"
  instance_type = "t2.medium"
  key-id        = module.dev-keypair.key-pair
  name-tag      = "PACD-jenkins"
  subnet-id     = module.dev-vpc.subnet-id1
  vpc-sg1       = [module.dev-securityGroups.aws_security_group_PACD_SG1]
}
module "dev-ansible" {
  source        = "../../modules/ansible"
  ami_name      = "ami-0ad8ecac8af5fc52b"
  instance_type = "t2.micro"
  key-id        = module.dev-keypair.key-pair
  name-tag      = "PACD-ansible"
  subnet-id     = module.dev-vpc.subnet-id2
  vpc-sg2       = [module.dev-securityGroups.aws_security_group_PACD_SG2]
}
module "dev-loadbalancer" {
  source           = "../../modules/loadbalancer"
  elb_name         = "jenkins-elb"
  elb_tag          = "jenkins-elb"
  subnet-id        = [module.dev-vpc.subnet-id3]
  jenkins-sg1      = [module.dev-securityGroups.aws_security_group_PACD_SG1]
  jenkins-instance = [module.dev-jenkins.jenkins-instance]
  tg_name = "PACD-tg"
  vpc-id = module.dev-vpc.vpc-id
  docker_instance = module.dev-dockerHost.docker-instance
  alb_name = "docker-alb-team1"
  docker_sg1 = [module.dev-securityGroups.aws_security_group_PACD_SG1]
  subnet_id_docker = [module.dev-vpc.subnet-id3, module.dev-vpc.subnet-id4]
  docker_tag = "Docker-lb"
}
module "dev-bastianHost" {
  source        = "../../modules/bastian_host"
  vpc_name      = "dev-PACD"
  sub1_id       = module.dev-vpc.subnet-id3
  ami_name      = "ami-0ad8ecac8af5fc52b"
  instance_type = "t2.micro"
  key-id        = module.dev-keypair.key-pair
  Bastian_SG    = [module.dev-securityGroups.aws_security_group_PACD_SG2]
}
module "dev-dockerHost" {
  source        = "../../modules/docker"
  vpc_name      = "dev-PACD"
  subnet-id     = module.dev-vpc.subnet-id1
  ami_name      = "ami-0ad8ecac8af5fc52b"
  instance_type = "t2.micro"
  key-id        = module.dev-keypair.key-pair
  Docker_SG     = [module.dev-securityGroups.aws_security_group_PACD_SG1]
}
module "dev-asg" {
    source              = "../../modules/asg"
    ami-name = "dev-docker-asg"
    target-instance = module.dev-dockerHost.docker-instance
    launch-configname = "dev-docker-lc"
    instance-type ="t2.micro"
    ami-from-instance = module.dev-asg.ami-from-instance
    sg1 = [module.dev-securityGroups.aws_security_group_PACD_SG1]
    key-id = module.dev-keypair.key-pair
    asg-group-name = "dev-dockerhost-ASG"
    vpc-zone-identifier = [module.dev-vpc.subnet-id1, module.dev-vpc.subnet-id2]
    docker-target-group-arn = [module.dev-loadbalancer.docker-tg-arn] 
    asg-docker-policy = "docker-policy-asg"
}