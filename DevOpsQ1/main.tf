

locals {

  project_name  =  "crypto-demo"
  name_context    = "${var.project_name}"

  dynamic_tag   = {
    Project = var.project_name
  }

  tags  = merge(var.global_tag,var.project_tag)
}

module "vpc" {
#  https://github.com/terraform-aws-modules/terraform-aws-vpc
  source = "./modules/terraform-aws-vpc-5.1.1"

  name = "${local.name_context}-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = false

  tags = local.tags
}


module "sg-01" {
  source = "./modules/terraform-aws-security-group-5.1.0"

  name        = "${local.name_context}-crypto-node-sg"
  description = "crypto-node-sg"
  vpc_id      = module.vpc.vpc_id

  ingress_with_source_security_group_id = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "incomming-ssh-bastion"
      source_security_group_id = module.sg-02-bastion.security_group_id
    },
  ]
  ingress_with_cidr_blocks = [
    {
      from_port        = 1317
      to_port          = 1317
      protocol         = "tcp"
      description      = "Tendermint rpc "
      cidr_blocks = module.vpc.private_subnets_cidr_blocks[0]
    },
    {
      from_port        = 26657
      to_port          = 26657
      protocol         = "tcp"
      description      = "Cosmos rpc "
      cidr_blocks = module.vpc.private_subnets_cidr_blocks[0]
    }
  ]
  depends_on = [module.vpc,module.sg-02-bastion]
}
module "sg-02-bastion" {
  source = "./modules/terraform-aws-security-group-5.1.0"

  name        = "${local.name_context}-bastion-node-sg"
  description = "bastion-node-sg"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "incomming-open-temporary"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  egress_rules        = ["ssh-tcp"]

  depends_on = [module.vpc]
}


data "aws_ami" "ubuntu" {
  most_recent = true
  owners = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

module "ec2_instance" {
#  https://github.com/terraform-aws-modules/terraform-aws-ec2-instance
  source  = "./modules/terraform-aws-ec2-instance-5.2.1"

  name = "${local.name_context}-crypto-node"

  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "m5a.large"
  key_name               = "${local.name_context}-key"
  monitoring             = true
  vpc_security_group_ids = [module.sg-01.security_group_id]
  subnet_id              = module.vpc.private_subnets[0]

  tags = local.tags
}
module "ec2_bastion" {
  #  https://github.com/terraform-aws-modules/terraform-aws-ec2-instance
  source  = "./modules/terraform-aws-ec2-instance-5.2.1"

  name = "${local.name_context}-bastion"

  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.small"
  key_name               = "${local.name_context}-key"
  monitoring             = true
  vpc_security_group_ids = [module.sg-02-bastion.security_group_id]
  subnet_id              = module.vpc.public_subnets[0]
  associate_public_ip_address = true

  tags = local.tags
}

resource "aws_volume_attachment" "this" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.this.id
  instance_id = module.ec2_instance.id

  depends_on = [module.ec2_instance]
}

resource "aws_kms_key" "disk-encryp-key" {
  description = "ebs-encryp-key"
  deletion_window_in_days = 7
}

resource "aws_ebs_volume" "this" {
  availability_zone = "ap-southeast-1a"
  size              = 100
  encrypted = true

  kms_key_id = aws_kms_key.disk-encryp-key.arn

  tags = local.tags
  depends_on = [aws_kms_key.disk-encryp-key]
}

output "bastion_ip" {
  value = module.ec2_bastion.public_ip
}