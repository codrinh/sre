resource "google_artifact_registry_repository" "docker" {
  for_each = toset([
    "docker-dummy-app",
    "dockder-dummy-pdf-or-png",
    "helm-dummy-app",
    "helm-dummy-pdf-or-png"
  ])

  location      = local.main_region
  repository_id = each.key
  format        = "DOCKER"
}