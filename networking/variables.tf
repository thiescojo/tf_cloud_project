#---networking/variables.tf

variable "vpc_cidr_in" {
  type = string
}

variable "public_cidrs_in" {
  type = list(any)
}

variable "private_cidrs_in" {
  type = list(any)
}

variable "public_sn_count" {
  type = number
}

variable "private_sn_count" {
  type = number
}

variable "max_subnets" {
  type = number
}