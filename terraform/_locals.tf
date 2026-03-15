locals {
  # Organization secret names (managed by organization-structure-administrator)
  organization_secrets = {
    auth_token                 = "AUTH_TOKEN"
    tf_api_token               = "TF_API_TOKEN"
    pgp_signing_key            = "PGP_SIGNING_KEY"
    pgp_signing_key_passphrase = "PGP_SIGNING_KEY_PASSPHRASE"
    sonatype_central_password  = "SONATYPE_CENTRAL_PASSWORD"
    sonatype_central_username  = "SONATYPE_CENTRAL_USERNAME"
    br_github_manager_name     = "BR_GITHUB_MANAGER_NAME"
    br_github_manager_email    = "BR_GITHUB_MANAGER_EMAIL"
  }
}
