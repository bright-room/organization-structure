import {
  to = module.secret_tf_api_token.github_actions_organization_secret.this
  id = "TF_API_TOKEN"
}

module "secret_tf_api_token" {
  source = "./modules/organization_secret"

  secret_name = "TF_API_TOKEN"
}
