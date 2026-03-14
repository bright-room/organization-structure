import {
  to = module.secret_br_github_manager_email.github_actions_organization_secret.this
  id = "BR_GITHUB_MANAGER_EMAIL"
}

module "secret_br_github_manager_email" {
  source = "./modules/organization_secret"

  secret_name = "BR_GITHUB_MANAGER_EMAIL"
}
