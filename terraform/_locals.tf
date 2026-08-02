locals {
  # Organization secret names (managed by organization-structure-administrator)
  organization_secrets = {
    chloe_chan_app_private_key = "CHLOE_CHAN_APP_PRIVATE_KEY"
  }

  # Organization variable names (managed by organization-structure-administrator)
  organization_variables = {
    chloe_chan_app_id = "CHLOE_CHAN_APP_ID"
  }

  # 各リポに配置されている security.yml の全ジョブ。
  # 対象リポの required_status_checks に共通で入れる。
  security_status_checks = [
    { context = "hidden-unicode" },
    { context = "secrets" },
    { context = "sca" },
    { context = "workflow-audit" },
    { context = "policy" },
  ]
}
