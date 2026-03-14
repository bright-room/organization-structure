import {
  to = module.secret_sonatype_central_password.github_actions_organization_secret.this
  id = "SONATYPE_CENTRAL_PASSWORD"
}

module "secret_sonatype_central_password" {
  source = "./modules/organization_secret"

  secret_name = "SONATYPE_CENTRAL_PASSWORD"
}
