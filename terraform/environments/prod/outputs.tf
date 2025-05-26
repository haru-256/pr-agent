output "tfstate_bucket_id" {
  value       = module.tfstate_bucket.tfstate_gcs_bucket_id
  description = "The ID of the bucket used to store terraform state"
}


output "gha_workload_identity_provider_name" {
  value       = module.gha_workload_identity.workload_identity_provider_name
  description = "The mapping of service accounts for GitHub Actions workload identity"

}

output "gha_workload_identity_service_account_email" {
  value = {
    for repo, sa in module.gha_workload_identity.service_account_email : repo => sa
  }
  description = "The mapping of service accounts for GitHub Actions workload identity"
}
