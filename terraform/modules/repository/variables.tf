# ---------------------------------------------------------------------------
# Per-repository inputs. Security / operational baselines (vulnerability
# alerts, delete branch on merge, archive on destroy, auto_init, default
# branch protection ruleset, signed commits, tag protection, issue labels,
# team assignment) are enforced as hardcoded values in main.tf and
# intentionally cannot be overridden here.
# ---------------------------------------------------------------------------

variable "name" {
  description = "Repository name"
  type        = string
}

variable "description" {
  description = "Repository description"
  type        = string
  default     = ""
}

variable "homepage_url" {
  description = "Repository homepage URL"
  type        = string
  default     = ""
}

variable "visibility" {
  description = "Repository visibility (public only — this module is for the public-repo half of the org)"
  type        = string
  default     = "public"

  validation {
    condition     = var.visibility == "public"
    error_message = "Only public repositories are allowed."
  }
}

variable "topics" {
  description = "Repository topics"
  type        = list(string)
  default     = []
}

variable "has_issues" {
  description = "Enable issues"
  type        = bool
  default     = true
}

variable "has_projects" {
  description = "Enable projects"
  type        = bool
  default     = false
}

variable "has_wiki" {
  description = "Enable wiki"
  type        = bool
  default     = false
}

variable "has_discussions" {
  description = "Enable discussions"
  type        = bool
  default     = true
}

variable "allow_merge_commit" {
  description = "Allow merge commits"
  type        = bool
  default     = true
}

variable "allow_squash_merge" {
  description = "Allow squash merging"
  type        = bool
  default     = true
}

variable "allow_rebase_merge" {
  description = "Allow rebase merging"
  type        = bool
  default     = true
}

variable "is_template" {
  description = "Whether this repository is a template"
  type        = bool
  default     = false
}

variable "archived" {
  description = "Whether to archive this repository"
  type        = bool
  default     = false
}

variable "default_branch_protection" {
  description = "Per-repository tweaks for the default-branch protection ruleset (the ruleset itself is always enforced)"
  type = object({
    required_status_checks = optional(list(object({
      context        = string
      integration_id = optional(number, null)
    })), [])
  })
  default = {}
}

variable "pages" {
  description = "GitHub Pages configuration (opt-in; null = Pages disabled)"
  type = object({
    build_type     = optional(string, "workflow")
    cname          = optional(string, null)
    https_enforced = optional(bool, null)
    source = optional(object({
      branch = string
      path   = optional(string, "/")
    }), null)
  })
  default = null

  validation {
    condition     = var.pages == null ? true : contains(["legacy", "workflow"], var.pages.build_type)
    error_message = "pages.build_type must be either 'legacy' or 'workflow'."
  }

  validation {
    condition     = var.pages == null ? true : (var.pages.build_type != "legacy" || var.pages.source != null)
    error_message = "pages.source is required when build_type is 'legacy'."
  }
}

variable "actions_permissions" {
  description = "Opt-in Actions execution policy (null = leave repository defaults untouched). Useful for repositories holding sensitive secrets or running privileged automation."
  type = object({
    enabled              = optional(bool, true)
    allowed_actions      = string
    sha_pinning_required = optional(bool, false)
    github_owned_allowed = optional(bool, true)
    verified_allowed     = optional(bool, true)
    patterns_allowed     = optional(list(string), [])
  })
  default = null

  validation {
    condition     = var.actions_permissions == null ? true : contains(["all", "local_only", "selected"], var.actions_permissions.allowed_actions)
    error_message = "allowed_actions must be one of 'all', 'local_only', or 'selected'."
  }
}

variable "rulesets" {
  description = "Map of additional repository rulesets to create beyond the enforced baseline"
  type = map(object({
    target      = string
    enforcement = optional(string, "active")
    conditions = object({
      ref_name = object({
        include = list(string)
        exclude = optional(list(string), [])
      })
    })
    rules = object({
      creation            = optional(bool, false)
      update              = optional(bool, false)
      deletion            = optional(bool, false)
      non_fast_forward    = optional(bool, false)
      required_signatures = optional(bool, false)
      pull_request = optional(object({
        dismiss_stale_reviews_on_push   = optional(bool, false)
        require_code_owner_review       = optional(bool, false)
        required_approving_review_count = optional(number, 1)
      }), null)
      required_status_checks = optional(list(object({
        context        = string
        integration_id = optional(number, null)
      })), [])
    })
  }))
  default = {}
}

variable "organization_secrets" {
  description = "List of organization secret names to grant access to this repository"
  type        = set(string)
  default     = []
}

variable "organization_variables" {
  description = "List of organization variable names to grant access to this repository"
  type        = set(string)
  default     = []
}
