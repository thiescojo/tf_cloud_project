#---security/outputs.tf

output "bastion_sg_id" {
  value = aws_security_group.bastion_sg.id
}

output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}

output "traffic_sg_id" {
  value = aws_security_group.traffic_sg.id
}