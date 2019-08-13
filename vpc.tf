
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "cloud-init-test"
  cidr = "10.0.0.0/16"

  azs            = ["eu-west-1a"]
  public_subnets = ["10.0.101.0/24"]
}