locals {
  # GitHub App IDs for ruleset bypass_actors
  github_app_ids = {
    renovate_bot   = 2740
    chloe_chan_bot = 3155244
  }

  # Fixed bypass_actors for default branch protection
  default_bypass_actors = [
    { actor_id = local.github_app_ids.renovate_bot, actor_type = "Integration", bypass_mode = "pull_request" },
    { actor_id = data.github_team.br_owners.id, actor_type = "Team", bypass_mode = "pull_request" },
    { actor_id = local.github_app_ids.chloe_chan_bot, actor_type = "Integration", bypass_mode = "always" },
  ]

  # Fixed bypass_actors for custom rulesets
  ruleset_bypass_actors = [
    { actor_id = data.github_team.br_owners.id, actor_type = "Team", bypass_mode = "pull_request" },
    { actor_id = local.github_app_ids.chloe_chan_bot, actor_type = "Integration", bypass_mode = "pull_request" },
  ]

  protect_tag_bypass_actors = [
    { actor_id = data.github_team.br_owners.id, actor_type = "Team", bypass_mode = "always" },
    { actor_id = local.github_app_ids.chloe_chan_bot, actor_type = "Integration", bypass_mode = "always" },
  ]

  # Fixed team assignments
  teams = {
    (data.github_team.br_contributors.id) = { permission = "push" }
    (data.github_team.br_maintainers.id)  = { permission = "maintain" }
    (data.github_team.br_owners.id)       = { permission = "admin" }
  }
}
