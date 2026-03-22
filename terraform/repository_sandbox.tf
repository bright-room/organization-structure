
module "repository_sandbox" {
  source = "./modules/repository"

  name        = "sandbox"
  description = "Sandbox repository for testing GitHub App integration with Terraform."
  visibility  = "public"
  topics      = ["sandbox", "testing"]

  default_branch_protection = {
    required_status_checks = [
      { context = "ci" },
    ]
  }

  rulesets = {
    "protect-tags" = {
      target = "tag"
      conditions = {
        ref_name = { include = ["~ALL"] }
      }
      rules = {
        creation = true
        update   = true
        deletion = true
      }
    }
  }

  organization_secrets = [
    local.organization_secrets.br_github_manager_name,
    local.organization_secrets.br_github_manager_email,
    local.organization_secrets.auth_token,
  ]
}
