locals {
  # Organization secret names (managed by organization-structure-administrator)
  organization_secrets = {
    chloe_chan_app_private_key = "CHLOE_CHAN_APP_PRIVATE_KEY"
  }

  # Organization variable names (managed by organization-structure-administrator)
  organization_variables = {
    chloe_chan_app_id = "CHLOE_CHAN_APP_ID"
  }
}
