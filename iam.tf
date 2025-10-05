resource "google_service_account" "github_actions" {
  account_id   = "github-actions-runner"
  display_name = "GitHub Actions Runner"
}

resource "google_project_iam_member" "gke_developer" {
  project = google_service_account.github_actions.project
  role    = "roles/container.developer"
  member  = google_service_account.github_actions.member
}

resource "google_iam_workload_identity_pool" "github_pool" {
  workload_identity_pool_id = "n8n-github-pool-v2"  # <-- Use a new, unique name
  display_name              = "GitHub Actions Pool"
}

# Create the provider for that pool, specifically for GitHub
resource "google_iam_workload_identity_pool_provider" "github_provider" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.github_pool.workload_identity_pool_id
  workload_identity_pool_provider_id = "github-provider"
  display_name                       = "GitHub Actions Provider"

  attribute_mapping = {
    "google.subject"       = "assertion.sub"
    "attribute.actor"      = "assertion.actor"
    "attribute.repository" = "assertion.repository"
  }
  
  attribute_condition = "attribute.repository == '${var.github_repo}'"

  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}

resource "google_service_account_iam_member" "workload_identity_user" {
  service_account_id = google_service_account.github_actions.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github_pool.name}/attribute.repository/${var.github_repo}"
}