import {
  to = module.secret_sonatype_central_username.github_actions_organization_secret.this
  id = "SONATYPE_CENTRAL_USERNAME"
}

module "secret_sonatype_central_username" {
  source = "./modules/organization_secret"

  secret_name = "SONATYPE_CENTRAL_USERNAME"
}
