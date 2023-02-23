resource "google_artifact_registry_repository" "dummy-pdf-or-png" {
  location      = local.main_region
  repository_id = "dummy-pdf-or-png"
  description   = "dummy-pdf-or-png docker repository"
  format        = "DOCKER"
}

resource "google_artifact_registry_repository" "dummy-rest-service" {
  location      = local.main_region
  repository_id = "dummy-rest-service"
  description   = "dummy-rest-service docker repository"
  format        = "DOCKER"
}