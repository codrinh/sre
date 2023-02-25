locals {
  prefix = "codrin-h"
}

# Create GCP project
module "project" {
  source              = "github.com/GoogleCloudPlatform/cloud-foundation-fabric//modules/project?ref=v20.0.0"
  billing_account     = var.billing_account
  name                = "${var.env}-demo-${local.prefix}"
  auto_create_network = "false"
}

# Enable needed services APIs for app_project
resource "google_project_service" "enable_gcp_apis" {
  project = module.project.name
  for_each = toset([
    "cloudresourcemanager.googleapis.com",
    "compute.googleapis.com",
    "container.googleapis.com",
    "artifactregistry.googleapis.com",
    # "containerregistry.googleapis.com",
    "containersecurity.googleapis.com",
    "containerthreatdetection.googleapis.com",
    "iam.googleapis.com",
    "iap.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
    "oslogin.googleapis.com",
    "secretmanager.googleapis.com"
  ])
  service = each.value
  disable_dependent_services=true
}

# Create terraform state bucket
module "bucket_tform" {
  source     = "github.com/terraform-google-modules/terraform-google-cloud-storage///modules/simple_bucket?ref=v3.4.1"
  name       = "${var.env}-terraform-state-${local.prefix}"
  project_id = module.project.name
  location   = "EU"
  labels = {
    app         = "demo",
    environment = var.env
  }
}

# Create terraform service account
resource "google_service_account" "sa_github_runner" {
  project      = module.project.name
  account_id   = "${var.env}-github-runner-sa"
  display_name = "Github Runner SA ${var.env}"
  description  = "Github Runner account for the ${var.env} project"
}

# Terraform service account permissions
resource "google_project_iam_member" "sa_perms" {
  project = module.project.name
  for_each = toset([
    "roles/compute.admin",
    "roles/compute.instanceAdmin.v1",
    "roles/compute.osAdminLogin",
    "roles/iam.securityAdmin",
    "roles/iam.serviceAccountCreator",
    "roles/iam.serviceAccountKeyAdmin",
    "roles/iam.serviceAccountUser",
    "roles/iap.tunnelResourceAccessor",
    "roles/logging.configWriter",
    "roles/monitoring.admin",
    "roles/secretmanager.admin",
    "roles/storage.admin"
  ])
  role   = each.value
  member = "serviceAccount:${google_service_account.sa_github_runner.email}"
}

resource "google_iam_workload_identity_pool" "github_pool" {
  project                   = module.project.name
  provider                  = google
  workload_identity_pool_id = "github-pool"
}

resource "google_iam_workload_identity_pool_provider" "provider" {
  provider                           = google
  project                            = module.project.name
  workload_identity_pool_id          = google_iam_workload_identity_pool.github_pool.workload_identity_pool_id
  display_name                       = "Github Actions"
  description                        = "OIDC identity pool provider for Github Actions"
  workload_identity_pool_provider_id = "github-provider"
  attribute_condition                = "assertion.repository=='${var.github_org}/${var.github_repo}'"
  attribute_mapping                  = {
    "google.subject"                  = "assertion.sub"
    "attribute.repository"            = "assertion.repository"
  }
  oidc {
    # recommended way https://github.com/google-github-actions/auth#authenticating-via-workload-identity-federation
    allowed_audiences = ["https://iam.googleapis.com/${google_iam_workload_identity_pool.github_pool.name}/providers/github-provider"]
    issuer_uri        = "https://token.actions.githubusercontent.com/"
  }
}

data "google_iam_policy" "wli_user_github_runner" {
  binding {
    role = "roles/iam.workloadIdentityUser"

    members = [
      "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github_pool.name}/attribute.repository/${var.github_org}/${var.github_repo}"
    ]
  }
}

resource "google_service_account_iam_policy" "sa_github_runner_iam" {
  service_account_id = google_service_account.sa_github_runner.name
  policy_data        = data.google_iam_policy.wli_user_github_runner.policy_data
}