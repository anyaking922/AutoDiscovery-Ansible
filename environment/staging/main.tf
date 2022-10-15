module "staging-vpc" {
  source = "../../Modules/vpc"
  vpc_name = "staging-PACD"
}