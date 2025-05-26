output "workload_identity_provider_name" {
  value       = module.gh_oidc.provider_name
  description = "The provider name of workload identity provider for GitHub Actions"
}

output "service_account_email" {
  value = {
    for repo, sa in google_service_account.gh : repo => sa.email
  }
  description = "The mapping of service accounts for GitHub Actions workload identity"
}
