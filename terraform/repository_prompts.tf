
module "repository_prompts" {
  source = "./modules/repository"

  name        = "prompts"
  description = "Reusable prompt templates and snippets for LLMs across bright-room projects."
  visibility  = "public"
  topics      = ["prompts", "llm", "ai", "developer-tools"]

  default_branch_protection = {
    required_status_checks = []
  }
}
