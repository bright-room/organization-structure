variable "name" {
  description = "Team name"
  type        = string
}

variable "description" {
  description = "Team description"
  type        = string
  default     = ""
}

variable "privacy" {
  description = "Team privacy (closed or secret)"
  type        = string
  default     = "closed"

  validation {
    condition     = contains(["closed", "secret"], var.privacy)
    error_message = "Privacy must be 'closed' or 'secret'."
  }
}

variable "parent_team_id" {
  description = "Parent team ID for nested teams"
  type        = string
  default     = null
}

variable "members" {
  description = "Map of team members keyed by username"
  type = map(object({
    role = string
  }))
  default = {}

  validation {
    condition     = alltrue([for m in values(var.members) : contains(["maintainer", "member"], m.role)])
    error_message = "Member role must be 'maintainer' or 'member'."
  }
}

variable "organization_role_ids" {
  description = "Set of custom organization role IDs to assign to this team"
  type        = set(string)
  default     = []
}
