#---security/varaiables.tf

variable "vpc_id" {
  type = string
}

variable "public_cidrs_in" {
  type = list(any)
}

variable "public_subnet_ids" {
  type = list(any)
}

variable "private_subnet_ids" {
  type = list(any)
}

variable "specific_ip" {
  type      = string
  sensitive = true
}

