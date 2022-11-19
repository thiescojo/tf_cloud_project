#---elb/main.tf


resource "aws_lb" "alb" {
  count              = length(var.public_subnet_ids)
  name               = "alb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = var.public_subnet_ids[count.index]

  tags = {
    Name = "Application-Load-Balancer"
  }
}

resource "aws_lb_target_group" "alb_tg" {
  name     = "tf-week21-lb-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_listener" "alb_listener" {
  count             = length(aws_lb.alb)
  load_balancer_arn = aws_lb.alb[count.index].arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
}