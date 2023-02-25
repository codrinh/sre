output "service_account" {
  description = "Terraform service account outputs"
  value       = google_service_account.sa_github_runner
}

output "state_bucket" {
  description = "Terraform state bucket outputs"
  value       = module.bucket_tform
}
