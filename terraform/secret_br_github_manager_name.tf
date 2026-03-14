import {
  to = module.secret_br_github_manager_name.github_actions_organization_secret.this
  id = "BR_GITHUB_MANAGER_NAME"
}

module "secret_br_github_manager_name" {
  source = "./modules/organization_secret"

  secret_name = "BR_GITHUB_MANAGER_NAME"
}
