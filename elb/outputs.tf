#---elb/outputs.tf

output "alb_tg_arn" {
  value = [aws_lb_target_group.alb_tg][0]["arn"]
}