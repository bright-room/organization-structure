module "repository_aws_shortcut_generator" {
  source = "./modules/repository"

  name        = "aws-shortcut-generator"
  description = "AWSのコンソール用ショートカットリンクをワンクリックで生成するためのChrome拡張機能"
  visibility  = "public"
  topics      = ["aws"]

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
