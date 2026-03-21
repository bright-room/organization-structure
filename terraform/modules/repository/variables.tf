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
  description = "Repository visibility (public only)"
  type        = string
  default     = "public"

  validation {
    condition     = var.visibility == "public"
    error_message = "Only public repositories are allowed."
  }
}

variable "default_branch" {
  description = "Default branch name"
  type        = string
  default     = "main"
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
  default     = false
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

variable "delete_branch_on_merge" {
  description = "Automatically delete head branches after merge"
  type        = bool
  default     = true
}

variable "auto_init" {
  description = "Initialize with README"
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

variable "archive_on_destroy" {
  description = "Archive repository instead of deleting on destroy"
  type        = bool
  default     = true
}

variable "vulnerability_alerts" {
  description = "Enable vulnerability alerts"
  type        = bool
  default     = true
}

variable "topics" {
  description = "Repository topics"
  type        = list(string)
  default     = []
}

variable "default_branch_protection" {
  description = "Default branch protection ruleset configuration"
  type = object({
    enabled = optional(bool, true)
    required_status_checks = optional(list(object({
      context        = string
      integration_id = optional(number, null)
    })), [])
  })
  default = {}
}

variable "rulesets" {
  description = "Map of repository rulesets to create"
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
      creation             = optional(bool, false)
      update               = optional(bool, false)
      deletion             = optional(bool, false)
      non_fast_forward     = optional(bool, false)
      required_signatures  = optional(bool, false)
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

