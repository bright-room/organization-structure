module "repository_uniso" {
  source = "./modules/repository"

  name        = "uniso"
  description = "A unified desktop client for managing multiple SNS accounts in one place."
  visibility  = "public"
  topics      = ["electron", "react", "typescript", "vite", "pnpm", "desktop-app", "sns", "social-media", "multi-account"]

  default_branch_protection = {
    required_status_checks = [
      { context = "vulnerability-audit" },
      { context = "glassworm-detection" },
      { context = "safe-chain" },
      { context = "lint" },
      { context = "check" },
      { context = "e2e" }
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
