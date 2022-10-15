# Create a jenkins load balancer
resource "aws_elb" "jenkins_lb" {
  name            = var.elb_name
  subnets         = var.subnet-id   #[aws_subnet.PACJAD_PUB_SN1.id]
  security_groups = var.jenkins-sg1 #[aws_security_group.PACJAD_SG1.id]

  listener {
    instance_port     = 8080
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:8080"
    interval            = 30
  }

  instances                   = var.jenkins-instance #[aws_instance.PACJAD_jenkins.id]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = var.elb_tag
  }
}


#Create Docker Load Balancer

# Create a Target Group for Load Balancer
resource "aws_lb_target_group" "docker-tg" {
  name     = var.tg_name
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc-id
  health_check {
    healthy_threshold   = 5
    interval            = 30
    timeout             = 5
    unhealthy_threshold = 3
  }
}
resource "aws_lb_target_group_attachment" "PACJADT1-tg-att" {
  target_group_arn = aws_lb_target_group.docker-tg.arn
  target_id        = var.docker_instance
  port             = 80
}
#Add an Application Load Balancer
resource "aws_lb" "docker-alb" {
  name                       = var.alb_name
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = var.docker_sg1
  subnets                    = var.subnet_id_docker
  enable_deletion_protection = false
  tags = {
    name = var.docker_tag
  }
}
#Add a load balancer Listener
resource "aws_lb_listener" "PACJADT1-lb-listener" {
  load_balancer_arn = aws_lb.docker-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.docker-tg.arn
  }
}

