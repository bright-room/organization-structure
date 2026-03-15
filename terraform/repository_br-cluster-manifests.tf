
module "repository_br_cluster_manifests" {
  source = "./modules/repository"

  name        = "br-cluster-manifests"
  description = "Raspberry Pi on kubernetes cluster で稼働するkubernetesのリソースを管理するリポジトリ"
  visibility  = "public"
  topics      = []

  default_branch_protection = {
    required_status_checks = []
  }
}
