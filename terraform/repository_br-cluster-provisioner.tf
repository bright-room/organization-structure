
module "repository_br_cluster_provisioner" {
  source = "./modules/repository"

  name        = "br-cluster-provisioner"
  description = "Raspberry Pi on kubernetes cluster で利用する各サーバーのプロビジョニングを管理するリポジトリ"
  visibility  = "public"
  topics      = ["ansible", "kubernetes", "raspberry-pi", "1password"]

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
