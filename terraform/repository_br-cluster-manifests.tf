
module "repository_br_cluster_manifests" {
  source = "./modules/repository"

  name        = "br-cluster-manifests"
  description = "Raspberry Pi on kubernetes cluster で稼働するkubernetesのリソースを管理するリポジトリ"
  visibility  = "public"
  topics      = []

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
