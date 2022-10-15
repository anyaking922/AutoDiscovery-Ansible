output "jenkins-lb-dns" {
  value = aws_elb.jenkins_lb.dns_name
}
output "docker-lb-dns" {
  value = aws_lb.docker-alb.dns_name
}
output "docker-lb-zone-id" {
  value = aws_lb.docker-alb.zone_id
}
output "docker-tg-arn" {
  value = aws_lb_target_group.docker-tg.arn
}
