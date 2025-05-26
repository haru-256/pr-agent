variable "gcp_project_id" {
  type        = string
  description = "The ID of GCP project"
}

variable "gcp_default_region" {
  type        = string
  description = "The name of GCP default region"
}

variable "repositories" {
  type        = map(list(string))
  description = <<EOT
Map of GitHub repositories to be granted access to the GHA Workload Identity Pool.
The key is the repository name in the format 'repo' without the owner name, and the value is the role to be assigned.
EOT
}
