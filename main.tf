#---root/main.tf

module "networking" {
  source           = "./networking"
  vpc_cidr_in      = var.vpc_cidr
  public_sn_count  = 3
  private_sn_count = 4
  max_subnets      = 20
  public_cidrs_in  = [for i in range(2, 255, 2) : cidrsubnet("10.0.0.0/16", 8, i)]
  private_cidrs_in = [for i in range(1, 255, 2) : cidrsubnet("10.0.0.0/16", 8, i)]
}

module "ec2" {
  source             = "./ec2"
  public_subnet_ids  = module.networking.public_subnet_ids
  private_subnet_ids = module.networking.private_subnet_ids
  bastion_sg_id      = module.security.bastion_sg_id
  alb_sg_id          = module.security.alb_sg_id
  alb_tg_arn         = module.elb.alb_tg_arn
  instance_type      = "t2.micro"
  key_name           = var.key_name
  user_data          = filebase64("./bootstrap.sh")
}

module "elb" {
  source            = "./elb"
  alb_sg_id         = module.security.alb_sg_id
  public_subnet_ids = module.networking.public_subnet_ids
  vpc_id            = module.networking.vpc_id
}

module "security" {
  source             = "./security"
  vpc_id             = module.networking.vpc_id
  public_cidrs_in    = [for i in range(2, 255, 2) : cidrsubnet("10.0.0.0/16", 8, i)]
  public_subnet_ids  = module.networking.public_subnet_ids
  private_subnet_ids = module.networking.private_subnet_ids
  specific_ip        = var.specific_ip
}