# google cloud project
data "google_project" "project" {
  project_id = var.gcp_project_id
}

# create the bucket for terraform state
module "tfstate_bucket" {
  source         = "../../modules/tfstate_gcs_bucket"
  gcp_project_id = data.google_project.project.project_id
}

# enable the required APIs for the project
module "project-services" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "~> 18.0"

  project_id = var.gcp_project_id

  activate_apis = [
    "iam.googleapis.com",
    "iamcredentials.googleapis.com"
  ]
}

# create workload identity pool for GitHub Actions
module "gha_workload_identity" {
  source         = "../../modules/gha_workload_identity"
  gcp_project_id = data.google_project.project.project_id
  repositories   = var.repositories
}

