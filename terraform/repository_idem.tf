
module "repository_idem" {
  source = "./modules/repository"

  name        = "idem"
  description = "Idempotency key middleware for Go HTTP applications."
  visibility  = "public"
  topics      = ["go", "golang", "middleware", "idempotency", "idempotency-key", "http-middleware", "rest-api", "gin", "echo", "redis"]

  default_branch_protection = {
    required_status_checks = [
      { context = "lint" },
      { context = "unit-test" },
      { context = "integration-test" }
    ]
  }

  organization_secrets = [
    local.organization_secrets.chloe_chan_app_private_key,
  ]

  organization_variables = [
    local.organization_variables.chloe_chan_app_id,
  ]
}
