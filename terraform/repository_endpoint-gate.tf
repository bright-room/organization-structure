
module "repository_endpoint_gate" {
  source = "./modules/repository"

  name        = "endpoint-gate"
  description = "Endpoint access control for JVM applications — feature flags, conditional access, rollout, and schedules."
  visibility  = "public"
  topics      = ["java", "library", "endpoint-gate", "feature-flag", "spring", "access-control", "rollout"]

  default_branch_protection = {
    required_status_checks = [
      { context = "lint" },
      { context = "unit-test" },
      { context = "integration-test" }
    ]
  }

  organization_secrets = [
    local.organization_secrets.pgp_signing_key,
    local.organization_secrets.pgp_signing_key_passphrase,
    local.organization_secrets.sonatype_central_password,
    local.organization_secrets.sonatype_central_username,
    local.organization_secrets.chloe_chan_app_private_key,
  ]

  organization_variables = [
    local.organization_variables.chloe_chan_app_id,
  ]
}
