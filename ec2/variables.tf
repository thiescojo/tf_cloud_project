#---ec2/variables.tf


variable "instance_type" {}

variable "bastion_sg_id" {}

variable "alb_sg_id" {}

variable "public_subnet_ids" {}

variable "private_subnet_ids" {}

variable "user_data" {}

variable "key_name" {
  type      = string
  sensitive = true
}

variable "alb_tg_arn" {}