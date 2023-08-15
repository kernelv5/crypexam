variable "region" {
  type = string
  default = "ap-southeast-1"
}

variable "global_tag" {
  type = map
  default = {
    ManagedBy = "Terraform"
  }
}
