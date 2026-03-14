variable "username" {
  description = "GitHub username"
  type        = string
}

variable "role" {
  description = "Organization role: 'admin' (= Owner) or 'member'"
  type        = string
  default     = "member"

  validation {
    condition     = contains(["admin", "member"], var.role)
    error_message = "Role must be 'admin' (= Owner) or 'member'."
  }
}

variable "organization_role_ids" {
  description = "Set of custom organization role IDs to assign to this user"
  type        = set(string)
  default     = []
}
