
module "repository_br_cluster" {
  source = "./modules/repository"

  name        = "br-cluster"
  description = ""
  visibility  = "public"
  topics      = []

  default_branch_protection = {
    required_status_checks = []
  }

  organization_secrets = [
    local.organization_secrets.chloe_chan_app_private_key,
  ]

  organization_variables = [
    local.organization_variables.chloe_chan_app_id,
  ]
}
