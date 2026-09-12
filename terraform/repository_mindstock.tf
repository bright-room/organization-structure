module "repository_mindstock" {
  source = "./modules/repository"

  name        = "mindstock"
  description = "Household consumables inventory manager — keep your home's stock out of your head."
  visibility  = "public"
  topics      = ["inventory", "household"]


  organization_secrets = [
    local.organization_secrets.chloe_chan_app_private_key,
  ]

  organization_variables = [
    local.organization_variables.chloe_chan_app_id,
  ]

  default_branch_protection = {
    required_status_checks = [
      { context = "lint" },
      { context = "test-backend" },
      { context = "test-frontend" },
      { context = "integration-test" },
      { context = "hidden-unicode" },
      { context = "secrets" },
      { context = "sca" },
      { context = "workflow-audit" },
      { context = "actionlint" },
    ]
  }
}
