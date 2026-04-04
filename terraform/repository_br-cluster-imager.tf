
module "repository_br_cluster_imager" {
  source = "./modules/repository"

  name        = "br-cluster-imager"
  description = "Raspberry Pi on kubernetes cluster で利用するOSのゴールデンイメージを管理するリポジトリ"
  visibility  = "public"
  topics      = ["terraform", "1password", "packer", "raspberry-pi", "kubernetes", "cloud-init"]

  default_branch_protection = {
    required_status_checks = [
      { context = "Python Lint" },
      { context = "Python Test" },
      { context = "Packer Validate" }
    ]
  }
}
