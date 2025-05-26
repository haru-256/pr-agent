# google cloud project
data "google_project" "project" {
  project_id = var.gcp_project_id
}

# create the bucket for terraform state
module "tfstate_bucket" {
  source         = "../../modules/tfstate_gcs_bucket"
  gcp_project_id = data.google_project.project.project_id
}

# create workload identity pool for GitHub Actions
module "gha_workload_identity" {
  source         = "../../modules/gha_workload_identity"
  gcp_project_id = data.google_project.project.project_id
  repositories   = var.repositories
}
