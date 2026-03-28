moved {
  from = module.repository_claude_dev_workflow
  to   = module.repository_br_claude_plugins
}

module "repository_br_claude_plugins" {
  source = "./modules/repository"

  name        = "br-claude-plugins"
  description = "Shared Claude Code plugins — reusable skills and commands across bright-room repositories."
  visibility  = "public"
  topics      = ["claude-code", "claude-plugins", "claude-skills"]

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
