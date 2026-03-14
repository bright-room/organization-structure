import {
  to = module.secret_pgp_signing_key_passphrase.github_actions_organization_secret.this
  id = "PGP_SIGNING_KEY_PASSPHRASE"
}

module "secret_pgp_signing_key_passphrase" {
  source = "./modules/organization_secret"

  secret_name = "PGP_SIGNING_KEY_PASSPHRASE"
}
