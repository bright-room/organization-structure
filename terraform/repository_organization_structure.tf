module "repository_organization_structure" {
  source = "./modules/repository"

  name        = "organization-structure"
  description = "Terraform configuration for bright-room GitHub organization"
  topics      = ["github", "terraform", "github-management", "iac"]

  default_branch_protection = {
    required_status_checks = [
      { context = "check-code-style" },
      { context = "plan" },
      { context = "validate" }
    ]
    bypass_actors = [
      { actor_id = local.github_app_ids.renovate_bot, actor_type = "Integration" },
      { actor_id = module.team_br_owners.id, actor_type = "Team" }
    ]
  }

  teams = {
    (module.team_br_owners.id) = { permission = "admin" }
  }
}
