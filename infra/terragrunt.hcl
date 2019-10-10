remote_state {
  backend = "gcs"
  config = {
    # There is one bucket for each environment.  The convention is
    # tf-state-prod-<random id> and tf-state-nonprod-<random id> for
    # environment isolation
    bucket = get_env("TF_STATE_BUCKET", "TF_STATE_BUCKET is unset")
    prefix = "state/infra-controller/${path_relative_to_include()}"
    # Bucket creation is expected to be part of the setup process.
    skip_bucket_creation = true
  }
}
