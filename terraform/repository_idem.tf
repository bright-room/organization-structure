
module "repository_idem" {
  source = "./modules/repository"

  name        = "idem"
  description = "Idempotency key middleware for Go HTTP applications."
  visibility  = "public"
  topics      = ["go", "golang", "middleware", "idempotency", "idempotency-key", "http-middleware", "rest-api", "gin", "echo", "redis"]

  default_branch_protection = {
    required_status_checks = []
    bypass_actors = [
      { actor_id = local.github_app_ids.renovate_bot, actor_type = "Integration" },
      { actor_id = module.team_br_owners.id, actor_type = "Team" }
    ]
  }

  rulesets = {
    "protect-tags" = {
      target = "tag"
      conditions = {
        ref_name = { include = ["~ALL"] }
      }
      bypass_actors = [
        { actor_id = module.team_br_owners.id, actor_type = "Team" }
      ]
      rules = {
        creation = true
        update   = true
        deletion = true
      }
    }
  }

  teams = {
    (module.team_br_owners.id) = { permission = "admin" }
  }
}
