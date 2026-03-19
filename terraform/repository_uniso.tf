
module "repository_uniso" {
  source = "./modules/repository"

  name        = "uniso"
  description = "A unified desktop client for managing multiple SNS accounts in one place."
  visibility  = "public"
  topics      = ["kotlin", "compose-multiplatform", "desktop-app", "sns", "social-media", "dashboard", "webview", "kcef", "multiplatform", "jetbrains-compose"]

  default_branch_protection = {
    required_status_checks = []
  }
}
