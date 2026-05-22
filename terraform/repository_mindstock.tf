module "repository_mindstock" {
  source = "./modules/repository"

  name        = "mindstock"
  description = "Household consumables inventory manager — keep your home's stock out of your head."
  visibility  = "public"
  topics      = ["inventory", "household"]

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
