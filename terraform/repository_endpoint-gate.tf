
module "repository_endpoint_gate" {
  source = "./modules/repository"

  name        = "endpoint-gate"
  description = "Endpoint access control for JVM applications — feature flags, conditional access, rollout, and schedules."
  visibility  = "public"
  topics      = ["java", "library", "endpoint-gate", "feature-flag", "spring", "access-control", "rollout"]

  default_branch_protection = {
    required_status_checks = []
    bypass_actors = [
      { actor_id = local.github_app_ids.renovate_bot, actor_type = "Integration" },
      { actor_id = module.team_br_owners.id, actor_type = "Team" }
    ]
  }

  teams = {
    (module.team_br_owners.id) = { permission = "admin" }
  }
}
