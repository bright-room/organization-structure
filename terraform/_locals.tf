locals {
  # Organization secret names (managed by organization-structure-administrator)
  organization_secrets = {
    chloe_chan_app_private_key = "CHLOE_CHAN_APP_PRIVATE_KEY"
    pgp_signing_key            = "PGP_SIGNING_KEY"
    pgp_signing_key_passphrase = "PGP_SIGNING_KEY_PASSPHRASE"
    sonatype_central_password  = "SONATYPE_CENTRAL_PASSWORD"
    sonatype_central_username  = "SONATYPE_CENTRAL_USERNAME"
  }

  # Organization variable names (managed by organization-structure-administrator)
  organization_variables = {
    chloe_chan_app_id = "CHLOE_CHAN_APP_ID"
  }
}
