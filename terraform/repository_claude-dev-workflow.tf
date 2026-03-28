module "repository_claude_dev_workflow" {
  source = "./modules/repository"

  name        = "claude-dev-workflow"
  description = "Shared Claude Code skills for plan, implement, review, and triage — a reusable development workflow across repositories."
  visibility  = "public"
  topics      = ["claude-code", "claude-skills", "developer-workflow", "sdlc"]

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
