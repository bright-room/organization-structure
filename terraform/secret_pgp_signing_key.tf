import {
  to = module.secret_pgp_signing_key.github_actions_organization_secret.this
  id = "PGP_SIGNING_KEY"
}

module "secret_pgp_signing_key" {
  source = "./modules/organization_secret"

  secret_name = "PGP_SIGNING_KEY"
}
