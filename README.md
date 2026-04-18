# organization-structure

[日本語版はこちら](README_ja.md)

Terraform configuration for managing GitHub repositories in the **bright-room** organization.

## Overview

This repository manages the lifecycle of public repositories within the bright-room GitHub organization using Terraform. It handles repository creation, issue label configuration, branch protection rulesets, team access permissions, and organization secret assignments.

For organization-level resources (members, teams, secrets, meta-repositories), see [organization-structure-administrator](https://github.com/bright-room/organization-structure-administrator).

## Managed Resources

| Resource Type | Description |
|---|---|
| Repositories | Public repositories with settings, descriptions, and topics |
| Issue Labels | Standardized label sets (Priority, Type, Close) |
| Branch Protection | Default branch rulesets with required approving reviews |
| Tag Protection | Custom rulesets for tag creation/update/deletion |
| Team Access | Repository-level team permissions (push, maintain, admin) |
| Organization Secrets | Per-repository access grants to organization-level secrets |

## Directory Structure

```
organization-structure/
├── .github/workflows/
│   ├── on-pull-request.yml   # Format check, validate, plan on PR
│   └── on-merge.yml          # Auto-apply on merge to main
├── terraform/
│   ├── _terraform.tf         # Provider and backend configuration
│   ├── _data.tf              # Data sources (team lookups)
│   ├── _locals.tf            # Organization secrets map
│   ├── repository_*.tf       # One file per managed repository
│   └── modules/
│       └── repository/       # Reusable repository module
│           ├── main.tf
│           ├── variables.tf
│           ├── outputs.tf
│           ├── data.tf
│           ├── locals.tf
│           └── terraform.tf
└── README.md
```

## How to Add a New Repository

1. Create a new file `terraform/repository_<name>.tf` (use hyphens in the repository name, underscores in the filename):

    ```hcl
    module "repository_example" {
      source = "./modules/repository"

      name        = "example-repo"
      description = "Description of the repository"
      topics      = ["topic1", "topic2"]

      organization_secret_names = [
        # Add organization secret names if needed
        # e.g., "CHLOE_CHAN_APP_PRIVATE_KEY", "PGP_SIGNING_KEY"
      ]
    }
    ```

2. (Optional) Add custom rulesets if you need tag protection or additional branch rules:

    ```hcl
    module "repository_example" {
      source = "./modules/repository"

      # ... base config ...

      custom_rulesets = [
        {
          name          = "tag-protection"
          target        = "tag"
          tag_pattern   = "*"
          creation      = true
          update        = true
          deletion      = true
          bypass_actors = []  # Empty to block all, or add specific actors
        }
      ]
    }
    ```

3. Open a pull request. The CI pipeline will run `terraform fmt`, `terraform validate`, and `terraform plan` automatically.

4. After review and approval, merge to `main`. Terraform apply runs automatically.

## Prerequisites

- [Terraform](https://www.terraform.io/) v1.14.7+
- Cloudflare R2 bucket `github-organization-tfstates` (managed in `br-cloudflare-terraform`) used as the tfstate backend via the S3-compatible API
- GitHub App credentials for chloe-chan-bot (`CHLOE_CHAN_APP_ID` variable, `CHLOE_CHAN_APP_PRIVATE_KEY` secret)
- R2 S3-compatible credentials (`GH_ORGANIZATION_TFSTATE_AWS_ACCESS_KEY_ID` / `GH_ORGANIZATION_TFSTATE_AWS_SECRET_ACCESS_KEY`) scoped to the bucket above

## CI/CD Pipeline

| Trigger | Workflow | Jobs |
|---|---|---|
| Pull Request | `on-pull-request.yml` | `check-code-style` (fmt) → `validate` → `plan` (posts plan as PR comment) |
| Merge to main | `on-merge.yml` | `apply` (auto-approve) |

Both workflows use Terraform v1.14.7 and require `CHLOE_CHAN_APP_PRIVATE_KEY`, `CHLOE_CHAN_APP_ID`, `GH_ORGANIZATION_TFSTATE_AWS_ACCESS_KEY_ID`, and `GH_ORGANIZATION_TFSTATE_AWS_SECRET_ACCESS_KEY`.
