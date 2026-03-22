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

  organization_secrets = [
    local.organization_secrets.chloe_chan_app_private_key,
  ]

  organization_variables = [
    local.organization_variables.chloe_chan_app_id,
  ]
}
