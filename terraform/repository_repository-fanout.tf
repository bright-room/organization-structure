module "repository_repository_fanout" {
  source = "./modules/repository"

  name        = "repository-fanout"
  description = "Distribute and auto-update common files across repositories via GitHub App and Cloudflare Workflows, controlled by topics."
  visibility  = "public"
  topics      = ["github-app", "cloudflare-workers", "cloudflare-workflows", "automation", "typescript", "file-distribution"]

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
