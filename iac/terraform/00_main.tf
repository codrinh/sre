locals {
  suffix      = "codrin-h"
  project_id  = "${var.env}-demo-${local.suffix}"
  main_region = "europe-west3"
}

resource "google_service_account" "gke_sa" {
  project      = local.project_id
  account_id   = "${var.env}-gke-sa"
  display_name = "GKE SA ${var.env}"
  description  = "GKE SA for the ${local.project_id} project"
}

resource "google_project_iam_member" "sa_perms" {
  project = local.project_id
  for_each = toset([
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
    "roles/monitoring.viewer",
    "roles/stackdriver.resourceMetadata.writer",
    "roles/storage.objectViewer",
    "roles/artifactregistry.reader"
  ])
  role   = each.value
  member = "serviceAccount:${google_service_account.gke_sa.email}"
}