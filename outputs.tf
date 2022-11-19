#---root/outputs.tf

output "vpc_id" {
  value = module.networking.vpc_id
}

output "public_subnet_ids" {
  value = module.networking.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.networking.private_subnet_ids
}

output "bastion_sg_id" {
  value = module.security.bastion_sg_id
}

output "alb_sg_id" {
  value = module.security.alb_sg_id
}

output "traffic_sg_id" {
  value = module.security.traffic_sg_id
}
