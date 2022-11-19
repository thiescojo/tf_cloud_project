# #---ec2/main.tf


# Get latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux_2" {
  most_recent = true


  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }


  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

# # Create Bastion Host in public subnet 10.0.4.0/24
resource "aws_launch_template" "bastion_host_lt" {
  name                   = "bastion_host_lt"
  image_id               = data.aws_ami.amazon_linux_2.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = tolist([var.bastion_sg_id])
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "bastion_host"
    }
  }
}

resource "aws_autoscaling_group" "bastion_host_asg" {
  vpc_zone_identifier = [var.public_subnet_ids[0][1]]
  name                = "bastion_host_asg"
  desired_capacity    = 1
  max_size            = 1
  min_size            = 1

  launch_template {
    id      = aws_launch_template.bastion_host_lt.id
    version = "$Latest"
  }
}

# resource "random_uuid" "server_name" {}

# Create web instances in private
resource "aws_launch_template" "servers_alb_lt" {
  name                   = "servers_alb_lt"
  image_id               = data.aws_ami.amazon_linux_2.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = tolist([var.alb_sg_id])
  user_data              = var.user_data
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "web-server"
    }
  }
}

resource "aws_autoscaling_group" "servers_alb_asg" {
  name                = "web_server_asg"
  desired_capacity    = 3
  max_size            = 6
  min_size            = 2
  vpc_zone_identifier = var.private_subnet_ids

  launch_template {
    id      = aws_launch_template.servers_alb_lt.id
    version = "$Latest"
  }
}

# Create a new ALB Target Group attachment
resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.servers_alb_asg.id
  lb_target_group_arn    = var.alb_tg_arn
}