
module "repository_br_cluster" {
  source = "./modules/repository"

  name        = "br-cluster"
  description = ""
  visibility  = "public"
  topics      = []

  default_branch_protection = {
    required_status_checks = []
  }
}
