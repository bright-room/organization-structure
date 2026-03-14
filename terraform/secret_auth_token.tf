import {
  to = module.secret_auth_token.github_actions_organization_secret.this
  id = "AUTH_TOKEN"
}

module "secret_auth_token" {
  source = "./modules/organization_secret"

  secret_name = "AUTH_TOKEN"
}
