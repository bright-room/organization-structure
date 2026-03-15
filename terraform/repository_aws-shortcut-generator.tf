module "repository_aws_shortcut_generator" {
  source = "./modules/repository"

  name        = "aws-shortcut-generator"
  description = "AWSのコンソール用ショートカットリンクをワンクリックで生成するためのChrome拡張機能"
  visibility  = "public"
  topics      = ["aws"]

  default_branch_protection = {
    required_status_checks = []
  }
}
