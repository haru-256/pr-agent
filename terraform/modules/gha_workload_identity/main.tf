# declare resource for connecting between Github Action and GCP

locals {
  owner = "haru-256"

  service_accounts = {
    for repo, _ in var.repositories : repo => "${repo}-github-action"
  }

  _service_account_roles = flatten([
    for repo, roles in var.repositories : [
      for role in roles : {
        repo = repo
        role = role
      }
    ]
  ])

  service_account_roles = {
    for role in local._service_account_roles : "${role.repo}-${role.role}" => role
  }

  sa_mapping = {
    for repo, service_account_name in local.service_accounts : service_account_name => {
      sa_name   = google_service_account.gh[repo].id
      attribute = "attribute.repository/${local.owner}/${repo}"
    }
  }
}

# github action service account
resource "google_service_account" "gh" {
  for_each = local.service_accounts

  project     = var.gcp_project_id
  account_id  = each.value
  description = "Service account for GitHub Actions runner in ${local.owner}/${each.key} repository"
}
resource "google_project_iam_member" "gh_project_member" {
  for_each = local.service_account_roles

  project = var.gcp_project_id
  role    = each.value.role
  member  = "serviceAccount:${google_service_account.gh[each.value.repo].email}"
}


# build workload identity for github actions
# tflint-ignore: terraform_module_version
module "gh_oidc" {
  source      = "terraform-google-modules/github-actions-runners/google//modules/gh-oidc"
  project_id  = var.gcp_project_id
  pool_id     = "github-action"
  provider_id = "github-action"
  attribute_mapping = {
    "google.subject"             = "assertion.sub"
    "attribute.actor"            = "assertion.actor"
    "attribute.aud"              = "assertion.aud"
    "attribute.repository"       = "assertion.repository"
    "attribute.repository_owner" = "assertion.repository_owner"
  }
  attribute_condition = "assertion.repository_owner=='${local.owner}'"
  sa_mapping          = local.sa_mapping
}
