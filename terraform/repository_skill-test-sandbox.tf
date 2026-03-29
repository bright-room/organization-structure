module "repository_skill_test_sandbox" {
  source = "./modules/repository"

  name        = "skill-test-sandbox"
  description = "Sandbox repository for testing dev-workflow skills (implement-plan, fix-review, review, etc.)."
  visibility  = "public"
  topics      = ["claude-code", "testing", "sandbox"]

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
