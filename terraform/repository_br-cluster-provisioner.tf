
module "repository_br_cluster_provisioner" {
  source = "./modules/repository"

  name        = "br-cluster-provisioner"
  description = "Raspberry Pi on kubernetes cluster で利用する各サーバーのプロビジョニングを管理するリポジトリ"
  visibility  = "public"
  topics      = ["ansible", "kubernetes", "raspberry-pi", "1password"]

  default_branch_protection = {
    required_status_checks = []
  }
}
