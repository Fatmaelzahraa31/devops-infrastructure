resource "google_service_account" "service-acc" {
  account_id = "service-acc"
  project = "fatma120d"
}

resource "google_project_iam_binding" "iam" {
  project = "fatma120d"
  role    = "roles/container.admin"
  members = [
  "serviceAccount:${google_service_account.service-acc.email}"
  ]
}