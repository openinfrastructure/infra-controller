terraform {
  # Intentionally empty, managed by terragrunt
  backend "gcs" {}
}

variable "project_id" {
  description = "The project used to contain the GCS bucket.  e.g. infra-controller-nonprod-12345"
}

variable "bucket_name" {
  description = "The name of the bucket to create, e.g. tf-state-nonprod-12345"
}

variable "location" {
  description = "The GCS Location.  See https://cloud.google.com/storage/docs/bucket-locations"
  default     = "us-west1"
}

variable "force_destroy" {
  description = "Allow the bucket to be destroyed with objects inside"
  default     = false
}

resource "google_storage_bucket" "tf-state" {
  name     = var.bucket_name
  location = var.location
  project  = var.project_id

  force_destroy = var.force_destroy

  versioning {
    enabled = true
  }
}
