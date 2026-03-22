
module "repository_claude_plugin" {
  source = "./modules/repository"

  name        = "claude-plugin"
  description = "Shared Claude Code plugin components for use across bright-room repositories."
  visibility  = "public"
  topics      = ["claude-code", "ai", "developer-tools"]

  default_branch_protection = {
    required_status_checks = []
  }
}
