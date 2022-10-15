module "dev-vpc-team-1" {
  source   = "../../modules/vpc"
  vpc_name = "dev-PACJAD-team-1"
}
module "dev-securityGroups-team-1" {
  source   = "../../modules/securityGroups"
  vpc-id   = module.dev-vpc-team-1.vpc-id
  sg1_name = "dev-PACJAD_SG1-docker-jenkins"
  sg2_name = "dev-PACJAD-SG2-bastion-ansible"
  sg3_name = "dev-PACJAD-SG3-rds"
}
module "dev-keypair-team-1" {
  source     = "../../modules/keypair"
  key_name   = "PACJAD-key-team-1"
  public-key = file("../../modules/secrets/Pap_key.pub")
}
module "dev-jenkins-team-1" {
  source        = "../../modules/jenkins"
  ami_name      = "ami-0ad8ecac8af5fc52b"
  instance_type = "t2.medium"
  key-id        = module.dev-keypair-team-1.key-pair
  name-tag      = "PACJAD-jenkins-team-1"
  subnet-id     = module.dev-vpc-team-1.subnet-id1
  vpc-sg1       = [module.dev-securityGroups-team-1.aws_security_group_PACJAD_SG1]
}
module "dev-ansible-team-1" {
  source        = "../../modules/ansible"
  ami_name      = "ami-0ad8ecac8af5fc52b"
  instance_type = "t2.micro"
  key-id        = module.dev-keypair-team-1.key-pair
  name-tag      = "PACJAD-ansible-team-1"
  subnet-id     = module.dev-vpc-team-1.subnet-id2
  vpc-sg2       = [module.dev-securityGroups-team-1.aws_security_group_PACJAD_SG2]
}
module "dev-loadbalancer-team-1" {
  source           = "../../modules/loadbalancer"
  elb_name         = "jenkins-elb-team-1"
  elb_tag          = "jenkins-elb-team-1"
  subnet-id        = [module.dev-vpc-team-1.subnet-id3]
  jenkins-sg1      = [module.dev-securityGroups-team-1.aws_security_group_PACJAD_SG1]
  jenkins-instance = [module.dev-jenkins-team-1.jenkins-instance]
  tg_name = "pacjad-tg-team-1"
  vpc-id = module.dev-vpc-team-1.vpc-id
  docker_instance = module.dev-dockerHost-team-1.docker-instance
  alb_name = "docker-alb-team1"
  docker_sg1 = [module.dev-securityGroups-team-1.aws_security_group_PACJAD_SG1]
  subnet_id_docker = [module.dev-vpc-team-1.subnet-id3, module.dev-vpc-team-1.subnet-id4]
  docker_tag = "Docker-lb-team-1"
}
module "dev-bastianHost-team-1" {
  source        = "../../modules/bastian_host"
  vpc_name      = "dev-PACJAD-team-1"
  sub1_id       = module.dev-vpc-team-1.subnet-id3
  ami_name      = "ami-0ad8ecac8af5fc52b"
  instance_type = "t2.micro"
  key-id        = module.dev-keypair-team-1.key-pair
  Bastian_SG    = [module.dev-securityGroups-team-1.aws_security_group_PACJAD_SG2]
}
module "dev-dockerHost-team-1" {
  source        = "../../modules/docker"
  vpc_name      = "dev-PACJAD-team-1"
  subnet-id     = module.dev-vpc-team-1.subnet-id1
  ami_name      = "ami-0ad8ecac8af5fc52b"
  instance_type = "t2.micro"
  key-id        = module.dev-keypair-team-1.key-pair
  Docker_SG     = [module.dev-securityGroups-team-1.aws_security_group_PACJAD_SG1]
}
module "dev-asg-team-1" {
    source              = "../../modules/asg"
    ami-name = "dev-docker-asg-team-1"
    target-instance = module.dev-dockerHost-team-1.docker-instance
    launch-configname = "dev-docker-lc-team-1"
    instance-type ="t2.micro"
    ami-from-instance = module.dev-asg-team-1.ami-from-instance
    sg1 = [module.dev-securityGroups-team-1.aws_security_group_PACJAD_SG1]
    key-id = module.dev-keypair-team-1.key-pair
    asg-group-name = "dev-dockerhost-ASG-team-1"
    vpc-zone-identifier = [module.dev-vpc-team-1.subnet-id1, module.dev-vpc-team-1.subnet-id2]
    docker-target-group-arn = [module.dev-loadbalancer-team-1.docker-tg-arn] 
    asg-docker-policy = "docker-policy-asg-team-1"
}