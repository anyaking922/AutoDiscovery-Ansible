output "vpc-id" {
  description = "vpc ID"
  value       = aws_vpc.PACD_VPC.id
}
output "subnet-id1" {
  description = "Private Subnets ID 1"
  value       = aws_subnet.PACD_PRV_SN1.id
}
output "subnet-id2" {
  description = "Private Subnets ID 2"
  value       = aws_subnet.PACD_PRV_SN2.id
}
output "subnet-id3" {
  description = "Public Subnets ID 1"
  value       = aws_subnet.PACD_PUB_SN1.id
}
output "subnet-id4" {
  description = "Public Subnets ID 2"
  value       = aws_subnet.PACD_PUB_SN2.id
}