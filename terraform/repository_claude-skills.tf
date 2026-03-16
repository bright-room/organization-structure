
module "repository_claude_skills" {
  source = "./modules/repository"

  name        = "claude-skills"
  description = "Shared Claude Code skills for use across bright-room repositories via git submodule."
  visibility  = "public"
  topics      = ["claude-code", "claude-skills", "ai", "developer-tools"]

  default_branch_protection = {
    required_status_checks = []
  }
}
